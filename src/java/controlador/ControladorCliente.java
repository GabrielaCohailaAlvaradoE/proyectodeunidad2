/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import modelo.Cliente;
import modelo.Vehiculo;
import modelo.HistorialEntry; // Import the new model
import modeloDAO.ClienteDAO;
import modeloDAO.VehiculoDAO;
import modeloDAO.EstacionamientoDAO; // Import the DAO
import util.ApiClientDni;
import com.google.gson.Gson;

@WebServlet(name = "ControladorCliente", urlPatterns = {"/ControladorCliente"})
public class ControladorCliente extends HttpServlet {

    ClienteDAO clienteDAO = new ClienteDAO();
    VehiculoDAO vehiculoDAO = new VehiculoDAO();
    EstacionamientoDAO estacionamientoDAO = new EstacionamientoDAO(); // Instantiate DAO
    ApiClientDni apiClient = new ApiClientDni();
    Gson gson = new Gson();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        HttpSession session = request.getSession(false);
        Cliente clienteLogueado = null;
        boolean requiresLogin = !(accion != null && (accion.equals("login") || accion.equals("registrar") || accion.equals("consultarDni")));

        if (requiresLogin) {
            if (session == null || session.getAttribute("clienteLogueado") == null) {
                response.sendRedirect("login.jsp?error=Sesión expirada");
                return;
            } else {
                clienteLogueado = (Cliente) session.getAttribute("clienteLogueado");
            }
        }

        if (accion != null) {
            switch (accion) {
                case "consultarDni":
                    consultarDni(request, response);
                    break;
                case "registrar":
                    registrarCliente(request, response);
                    break;
                case "login":
                    iniciarSesion(request, response);
                    break;
                case "logout":
                    cerrarSesion(request, response);
                    break;
                case "verPanel":
                     response.sendRedirect("panel.jsp");
                     break;
                case "verMisVehiculos":
                    verMisVehiculos(request, response, clienteLogueado);
                    break;
                case "agregarVehiculo":
                    agregarVehiculo(request, response, clienteLogueado);
                    break;
                // --- NEW ACTION ---
                case "verHistorial":
                    verHistorial(request, response, clienteLogueado);
                    break;

                default:
                    if (clienteLogueado != null) {
                        response.sendRedirect("panel.jsp");
                    } else {
                        response.sendRedirect("login.jsp");
                    }
            }
        } else {
             if (clienteLogueado != null) {
                 response.sendRedirect("panel.jsp");
             } else {
                 response.sendRedirect("login.jsp");
             }
        }
    }

    private void consultarDni(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String dni = request.getParameter("dni");
        Cliente clienteConsultado = apiClient.consultarDni(dni);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        String jsonRespuesta;
        if (clienteConsultado != null) {
            jsonRespuesta = gson.toJson(clienteConsultado);
        } else {
            jsonRespuesta = "{\"error\":\"DNI no encontrado o inválido\"}";
        }
        response.getWriter().write(jsonRespuesta);
    }

    private void registrarCliente(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String dni = request.getParameter("txtDni");
            String nombres = request.getParameter("txtNombres");
            String apellidos = request.getParameter("txtApellidos");
            String email = request.getParameter("txtEmail");
            String password = request.getParameter("txtPassword");
            String fechaNacStr = request.getParameter("txtFechaNacimiento");

            if (clienteDAO.verificarExistencia(dni, email)) {
                request.setAttribute("error", "El DNI o correo electrónico ya se encuentra registrado.");
                request.getRequestDispatcher("registro.jsp").forward(request, response);
                return;
            }

            Cliente nuevoCliente = new Cliente();
            nuevoCliente.setDni(dni);
            nuevoCliente.setNombres(nombres);
            nuevoCliente.setApellidos(apellidos);
            nuevoCliente.setEmail(email);
            nuevoCliente.setPassword(password);

            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
            Date fechaNacimiento = formatter.parse(fechaNacStr);
            nuevoCliente.setFechaNacimiento(fechaNacimiento);

            boolean registrado = clienteDAO.registrar(nuevoCliente);

            if (registrado) {
                request.setAttribute("exito", "¡Cuenta creada con éxito! Ya puedes iniciar sesión.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Ocurrió un error durante el registro.");
                request.getRequestDispatcher("registro.jsp").forward(request, response);
            }
        } catch (ParseException e) {
            request.setAttribute("error", "El formato de la fecha de nacimiento no es válido.");
            request.getRequestDispatcher("registro.jsp").forward(request, response);
            e.printStackTrace();
        }
    }

    private void iniciarSesion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String dni = request.getParameter("txtDni");
        String password = request.getParameter("txtPassword");
        Cliente cliente = clienteDAO.validar(dni, password);

        if (cliente != null) {
            HttpSession session = request.getSession();
            session.setAttribute("clienteLogueado", cliente);
            response.sendRedirect("panel.jsp");
        } else {
            request.setAttribute("error", "DNI o contraseña incorrectos. Inténtalo de nuevo.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    private void cerrarSesion(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect("login.jsp");
    }

    private void verMisVehiculos(HttpServletRequest request, HttpServletResponse response, Cliente cliente)
            throws ServletException, IOException {
        List<Vehiculo> misVehiculos = vehiculoDAO.listarPorPropietario(cliente.getIdUsuario());
        request.setAttribute("listaVehiculos", misVehiculos);
        request.getRequestDispatcher("misVehiculos.jsp").forward(request, response);
    }

    private void agregarVehiculo(HttpServletRequest request, HttpServletResponse response, Cliente cliente)
            throws IOException {
        HttpSession session = request.getSession();
        try {
            Vehiculo vehiculo = new Vehiculo();
            vehiculo.setPlaca(request.getParameter("txtPlaca").toUpperCase());
            vehiculo.setMarca(request.getParameter("txtMarca"));
            vehiculo.setModelo(request.getParameter("txtModelo"));
            vehiculo.setColor(request.getParameter("txtColor"));
            vehiculo.setVin(request.getParameter("txtVin"));
            vehiculo.setEstadoSoat(request.getParameter("selectSoat"));

            String anioStr = request.getParameter("txtAnio");
            if (anioStr != null && !anioStr.isEmpty()) {
                vehiculo.setAnioFabricacion(Integer.parseInt(anioStr));
            } else {
                 vehiculo.setAnioFabricacion(0);
            }

            vehiculo.setIdPropietario(cliente.getIdUsuario());

            if (vehiculoDAO.crear(vehiculo)) {
                session.setAttribute("exito", "Vehículo " + vehiculo.getPlaca() + " agregado exitosamente.");
            } else {
                session.setAttribute("error", "Error al agregar el vehículo. Verifique si la placa o VIN ya existen.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "El año de fabricación debe ser un número válido.");
        } catch (Exception e) {
             session.setAttribute("error", "Error inesperado: " + e.getMessage());
             e.printStackTrace();
        }
        response.sendRedirect("ControladorCliente?accion=verMisVehiculos");
    }

    // --- NEW HISTORY METHOD ---
    private void verHistorial(HttpServletRequest request, HttpServletResponse response, Cliente cliente)
            throws ServletException, IOException {
        // Call the DAO to get the history list for the logged-in client
        List<HistorialEntry> historial = estacionamientoDAO.obtenerHistorialCliente(cliente.getIdUsuario());

        // Set the list as an attribute for the JSP
        request.setAttribute("listaHistorial", historial);

        // Forward to the new JSP page
        request.getRequestDispatcher("historial.jsp").forward(request, response);
    }

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