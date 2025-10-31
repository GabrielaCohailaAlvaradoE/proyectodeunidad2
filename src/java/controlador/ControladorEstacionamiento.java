/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controlador;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder; // Para formatear fechas
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import modelo.Empleado;
import modelo.Espacio;
import modelo.RegistroEntrada;
import modelo.RegistroEstacionamiento; // Importar el nuevo modelo
import modelo.Vehiculo;
import modeloDAO.EspacioDAO;
import modeloDAO.EstacionamientoDAO;
import modeloDAO.VehiculoDAO;

@WebServlet(name = "ControladorEstacionamiento", urlPatterns = {"/ControladorEstacionamiento"})
public class ControladorEstacionamiento extends HttpServlet {

    private final Gson gson = new GsonBuilder()
            .setDateFormat("yyyy-MM-dd HH:mm:ss") // Formato de fecha consistente
            .create();

    private final VehiculoDAO vehiculoDAO = new VehiculoDAO();
    private final EspacioDAO espacioDAO = new EspacioDAO();
    private final EstacionamientoDAO estacionamientoDAO = new EstacionamientoDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // --- Bloque de Seguridad: Solo Empleados Logueados ---
        HttpSession session = request.getSession(false); // No crear nueva sesión si no existe
        Empleado empleado = null;

        // Verifica si hay sesión Y si el atributo 'empleadoLogueado' existe
        if (session == null || session.getAttribute("empleadoLogueado") == null) {
            // Si la petición NO es AJAX, redirige al login
            if (!"XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.sendRedirect("admin.jsp?error=Sesión expirada");
            } else {
                // Si ES AJAX, envía un error 401 (No Autorizado)
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"status\":\"error\", \"message\":\"Sesión expirada o inválida.\"}");
            }
            return; // Detiene la ejecución si no hay sesión válida
        } else {
            empleado = (Empleado) session.getAttribute("empleadoLogueado");
        }
        // --- Fin del Bloque de Seguridad ---

        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = "panel";
        }

        switch (accion) {
            // --- ACCIONES DE ENTRADA ---
            case "buscarPlaca":
                buscarPlaca(request, response);
                break;
            case "listarEspacios":
                listarEspaciosLibres(request, response, empleado.getIdSede());
                break;
            case "registrarEntrada":
                registrarEntrada(request, response, empleado.getIdEmpleado());
                break;

            // --- ACCIONES DE SALIDA ---
            case "buscarVehiculoSalida":
                buscarVehiculoSalida(request, response);
                break;
            case "registrarSalida":
                registrarSalida(request, response, empleado.getIdEmpleado());
                break;

            default:
                response.sendRedirect("panelRecepcion.jsp");
        }
    }

    // ===============================================
    // MÉTODOS DE REGISTRO DE ENTRADA (Sin cambios)
    // ===============================================

    private void buscarPlaca(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Map<String, Object> jsonResponse = new HashMap<>();
        try {
            String placa = request.getParameter("placa");
            if (placa == null || placa.trim().isEmpty()) {
                throw new IllegalArgumentException("Placa no proporcionada.");
            }
            Vehiculo vehiculo = vehiculoDAO.buscarPorPlaca(placa.trim().toUpperCase());
            if (vehiculo != null) {
                jsonResponse.put("status", "success");
                jsonResponse.put("vehiculo", vehiculo);
            } else {
                jsonResponse.put("status", "not_found");
                jsonResponse.put("message", "Vehículo no registrado. Se registrará como invitado.");
            }
        } catch (Exception e) {
            jsonResponse.put("status", "error");
            jsonResponse.put("message", "Error: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        }
        response.getWriter().write(gson.toJson(jsonResponse));
    }

    private void listarEspaciosLibres(HttpServletRequest request, HttpServletResponse response, int idSede) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Map<String, Object> jsonResponse = new HashMap<>();
        try {
            List<Espacio> espacios = espacioDAO.listarLibresPorSede(idSede);
            jsonResponse.put("status", "success");
            jsonResponse.put("espacios", espacios);
        } catch (Exception e) {
            jsonResponse.put("status", "error");
            jsonResponse.put("message", "Error al cargar espacios: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
        response.getWriter().write(gson.toJson(jsonResponse));
    }

    private void registrarEntrada(HttpServletRequest request, HttpServletResponse response, int idRecepcionista) throws IOException {
        HttpSession session = request.getSession();
        try {
            RegistroEntrada entrada = new RegistroEntrada();
            entrada.setPlaca(request.getParameter("txtPlaca"));
            entrada.setDniConductor(request.getParameter("txtDniConductor"));
            entrada.setEmailConductor(request.getParameter("txtEmailConductor"));
            entrada.setIdEspacio(Integer.parseInt(request.getParameter("selectEspacio")));
            entrada.setIdRecepcionista(idRecepcionista);

            String mensajeSP = estacionamientoDAO.registrarEntrada(entrada);

            if (mensajeSP.contains("exitosamente")) {
                session.setAttribute("exito", mensajeSP);
            } else {
                session.setAttribute("error", mensajeSP);
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Datos inválidos. Asegúrate de seleccionar un espacio.");
        } catch (Exception e) {
            session.setAttribute("error", "Error inesperado: " + e.getMessage());
        }
        response.sendRedirect("panelRecepcion.jsp");
    }

    // ===============================================
    // MÉTODOS DE REGISTRO DE SALIDA (Revisar)
    // ===============================================

    /**
     * [AJAX] Busca un registro activo por PIN o Placa, calcula el monto
     * y devuelve un JSON con los detalles.
     */
    private void buscarVehiculoSalida(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Map<String, Object> jsonResponse = new HashMap<>();

        try {
            String placaOPin = request.getParameter("placaOPin");
            if (placaOPin == null || placaOPin.trim().isEmpty()) {
                throw new IllegalArgumentException("PIN o Placa no proporcionados.");
            }

            // Llamada al DAO
            RegistroEstacionamiento reg = estacionamientoDAO.buscarRegistroActivo(placaOPin);
            System.out.println(">>> DEBUG parametro recibido (placaOPin): '" + request.getParameter("placaOPin") + "'");
            if (reg != null) {
                // Cálculo de Pago
                double tarifaBase = reg.getTarifaBaseSede();
                double minutos = reg.getMinutosTranscurridos();
                double horasACobrar = Math.ceil(minutos / 60.0);
                if (horasACobrar == 0) horasACobrar = 1; // Cobrar mínimo 1 hora
                double montoCalculado = tarifaBase * horasACobrar;
                reg.setMontoCalculado(montoCalculado);

                jsonResponse.put("status", "success");
                jsonResponse.put("registro", reg);
            } else {
                jsonResponse.put("status", "not_found");
                jsonResponse.put("message", "Vehículo no encontrado o ya fue retirado.");
            }
        } catch (Exception e) {
            System.err.println("Error en buscarVehiculoSalida: " + e.getMessage()); // Imprimir error en consola del servidor
            e.printStackTrace(); // Imprimir stack trace completo
            jsonResponse.put("status", "error");
            jsonResponse.put("message", "Error interno del servidor al buscar: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // Enviar 500 si hay error
        }

        response.getWriter().write(gson.toJson(jsonResponse));
    }

    /**
     * [FORM POST] Registra el pago y la salida del vehículo.
     */
    private void registrarSalida(HttpServletRequest request, HttpServletResponse response, int idEmpleadoSalida) throws IOException {
        HttpSession session = request.getSession();
        try {
            int idRegistro = Integer.parseInt(request.getParameter("txtIdRegistroSalida"));
            double montoTotal = Double.parseDouble(request.getParameter("txtMontoTotalSalida"));
            double montoRecibido = Double.parseDouble(request.getParameter("txtMontoRecibido"));

            String mensajeSP = estacionamientoDAO.registrarPagoYSalida(idRegistro, idEmpleadoSalida, montoTotal, montoRecibido);

            if (mensajeSP.contains("exitosamente")) {
                session.setAttribute("exito", mensajeSP);
            } else {
                session.setAttribute("error", mensajeSP);
            }

        } catch (NumberFormatException e) {
            session.setAttribute("error", "Datos de pago inválidos. El monto recibido debe ser un número.");
        } catch (Exception e) {
            session.setAttribute("error", "Error inesperado: " + e.getMessage());
        }

        response.sendRedirect("panelRecepcion.jsp");
    }

    // --- (doGet y doPost) ---
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}