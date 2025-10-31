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
import java.util.List;
import modelo.Empleado;
import modelo.Sede;
import modeloDAO.EmpleadoDAO;
import modeloDAO.SedeDAO;

@WebServlet(name = "ControladorEmpleado", urlPatterns = {"/ControladorEmpleado"})
public class ControladorEmpleado extends HttpServlet {

    EmpleadoDAO empleadoDAO = new EmpleadoDAO();
    SedeDAO sedeDAO = new SedeDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = "loginPage";
        }

        HttpSession session = request.getSession(false);
        Empleado empleadoLogueado = null;

        // --- Bloque de Seguridad ---
        if (session == null || session.getAttribute("empleadoLogueado") == null) {
            if (!accion.equals("login") && !accion.equals("loginPage")) {
                response.sendRedirect("admin.jsp?error=Sesión expirada");
                return;
            }
        } else {
            empleadoLogueado = (Empleado) session.getAttribute("empleadoLogueado");
        }
        // --- Fin Bloque de Seguridad ---

        switch (accion) {
            // --- Acciones de Login (Comunes) ---
            case "loginPage":
                request.getRequestDispatcher("admin.jsp").forward(request, response);
                break;
            case "login":
                iniciarSesionEmpleado(request, response);
                break;
            case "logout":
                cerrarSesion(request, response);
                break;

            // --- Acciones de Administrador (Flujo Admin) ---
            case "verPanelGerentes":
                if (esAdmin(empleadoLogueado, response)) {
                    verPanelGerentes(request, response);
                }
                break;
            case "crearGerente":
                if (esAdmin(empleadoLogueado, response)) {
                    crearGerente(request, response);
                }
                break;
            case "cambiarEstadoEmpleado":
                // Esta acción la pueden usar Admin y Gerente,
                // pero el Gerente solo sobre su personal (lógica pendiente)
                cambiarEstadoEmpleado(request, response);
                break;

            // --- NUEVAS ACCIONES de Gerente (Flujo Gerente) ---
            case "verPanelGerente":
                if (esGerente(empleadoLogueado, response)) {
                    verPanelGerente(request, response);
                }
                break;
            case "crearEmpleado":
                if (esGerente(empleadoLogueado, response)) {
                    crearEmpleado(request, response);
                }
                break;

            default:
                if (empleadoLogueado != null) {
                    redirigirPorRol(empleadoLogueado, response);
                } else {
                    request.getRequestDispatcher("admin.jsp").forward(request, response);
                }
        }
    }

    // --- Métodos de Ayuda (Seguridad de Roles) ---
    private boolean esAdmin(Empleado emp, HttpServletResponse response) throws IOException {
        if (emp != null && "ADMINISTRADOR".equals(emp.getRol())) {
            return true;
        }
        response.sendRedirect("admin.jsp?error=Acceso no autorizado");
        return false;
    }

    private boolean esGerente(Empleado emp, HttpServletResponse response) throws IOException {
        if (emp != null && "GERENTE".equals(emp.getRol())) {
            return true;
        }
        response.sendRedirect("admin.jsp?error=Acceso no autorizado");
        return false;
    }

    // --- Métodos de Login/Sesión (Sin cambios) ---
    private void iniciarSesionEmpleado(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String usuario = request.getParameter("txtUsuario");
        String password = request.getParameter("txtPassword");
        Empleado empleado = empleadoDAO.validar(usuario, password);

        if (empleado != null) {
            HttpSession session = request.getSession();
            session.setAttribute("empleadoLogueado", empleado);
            redirigirPorRol(empleado, response);
        } else {
            request.setAttribute("error", "Usuario o contraseña de empleado incorrectos.");
            request.getRequestDispatcher("admin.jsp").forward(request, response);
        }
    }

    private void redirigirPorRol(Empleado empleado, HttpServletResponse response) throws IOException {
        switch (empleado.getRol()) {
            case "ADMINISTRADOR":
                response.sendRedirect("ControladorSede?accion=listar");
                break;
            case "GERENTE":
                // Redirigimos a la nueva acción que carga el panel
                response.sendRedirect("ControladorEmpleado?accion=verPanelGerente");
                break;
            case "RECEPCIONISTA":
                response.sendRedirect("panelRecepcion.jsp");
                break;
            case "GUARDIA":
                response.sendRedirect("panelGuardia.jsp");
                break;
            default:
                response.sendRedirect("admin.jsp?error=Rol no reconocido");
        }
    }

    private void cerrarSesion(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect("admin.jsp");
    }

    // --- Métodos de Admin (Gestión de Gerentes - Sin cambios) ---
    private void verPanelGerentes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Empleado> listaGerentes = empleadoDAO.listarPorRol("GERENTE");
        List<Sede> listaSedesDisponibles = sedeDAO.listarSedesSinGerente();
        request.setAttribute("listaGerentes", listaGerentes);
        request.setAttribute("listaSedesDisponibles", listaSedesDisponibles);
        request.getRequestDispatcher("panelAdminGerentes.jsp").forward(request, response);
    }

    private void crearGerente(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        Empleado admin = (Empleado) session.getAttribute("empleadoLogueado");
        try {
            Empleado gerente = new Empleado();
            gerente.setIdSede(Integer.parseInt(request.getParameter("selectSede")));
            gerente.setDni(request.getParameter("txtDni"));
            gerente.setNombres(request.getParameter("txtNombres"));
            gerente.setApellidos(request.getParameter("txtApellidos"));
            gerente.setEmail(request.getParameter("txtEmail"));
            gerente.setUsuario(request.getParameter("txtUsuario"));
            gerente.setPassword(request.getParameter("txtPassword"));
            
            String mensajeSP = empleadoDAO.registrarGerente(gerente, admin.getIdEmpleado());
            if (mensajeSP.contains("exitosamente")) {
                session.setAttribute("exito", mensajeSP);
            } else {
                session.setAttribute("error", mensajeSP);
            }
        } catch (Exception e) {
            session.setAttribute("error", "Error inesperado: " + e.getMessage());
        }
        response.sendRedirect("ControladorEmpleado?accion=verPanelGerentes");
    }

    private void cambiarEstadoEmpleado(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        HttpSession session = request.getSession();
        Empleado empleadoLogueado = (Empleado) session.getAttribute("empleadoLogueado");
        
        // Definimos a dónde regresar en caso de éxito o error
        String returnURL = "admin.jsp"; // Fallback
        if ("ADMINISTRADOR".equals(empleadoLogueado.getRol())) {
            returnURL = "ControladorEmpleado?accion=verPanelGerentes";
        } else if ("GERENTE".equals(empleadoLogueado.getRol())) {
            returnURL = "ControladorEmpleado?accion=verPanelGerente";
        }

        try {
            int idEmpleadoTarget = Integer.parseInt(request.getParameter("idEmpleado"));
            String nuevoEstado = request.getParameter("estado");

            // --- INICIO DE VALIDACIONES DE SEGURIDAD ---
            
            // 1. Un empleado no puede modificarse a sí mismo
            if (idEmpleadoTarget == empleadoLogueado.getIdEmpleado()) {
                session.setAttribute("error", "No puedes cambiar tu propio estado.");
                response.sendRedirect(returnURL);
                return;
            }

            // 2. Obtenemos los datos del empleado que se quiere modificar
            Empleado empleadoTarget = empleadoDAO.buscarPorId(idEmpleadoTarget);
            if (empleadoTarget == null) {
                session.setAttribute("error", "Empleado a modificar no encontrado.");
                response.sendRedirect(returnURL);
                return;
            }

            // 3. NADIE puede modificar a un ADMINISTRADOR
            if ("ADMINISTRADOR".equals(empleadoTarget.getRol())) {
                session.setAttribute("error", "Acción no permitida. No se puede modificar a un Administrador.");
                response.sendRedirect(returnURL);
                return;
            }

            // 4. Reglas específicas para el GERENTE
            if ("GERENTE".equals(empleadoLogueado.getRol())) {
                
                // 4a. Un Gerente no puede modificar a otro Gerente
                if ("GERENTE".equals(empleadoTarget.getRol())) {
                    session.setAttribute("error", "Un Gerente no puede modificar a otro Gerente.");
                    response.sendRedirect(returnURL);
                    return;
                }
                
                // 4b. Un Gerente solo puede modificar empleados de SU sede
                if (empleadoTarget.getIdSede() != empleadoLogueado.getIdSede()) {
                    session.setAttribute("error", "Solo puedes modificar empleados de tu propia sede.");
                    response.sendRedirect(returnURL);
                    return;
                }
            }
            
            String mensaje = empleadoDAO.cambiarEstado(idEmpleadoTarget, nuevoEstado);
            
            if (mensaje.contains("actualizado")) {
                session.setAttribute("exito", mensaje);
            } else {
                session.setAttribute("error", mensaje);
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("error", "ID de empleado inválido.");
        }
        
        response.sendRedirect(returnURL);
    }

    // --- NUEVOS MÉTODOS (Gestión de Empleados del Gerente) ---
    private void verPanelGerente(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Empleado gerente = (Empleado) session.getAttribute("empleadoLogueado");
        
        // 1. Obtenemos la lista de empleados SOLO de la sede del Gerente
        List<Empleado> listaEmpleadosSede = empleadoDAO.listarPorSede(gerente.getIdSede());
        
        // 2. Ponemos la lista en la solicitud
        request.setAttribute("listaEmpleadosSede", listaEmpleadosSede);
        
        // 3. Enviamos al nuevo JSP
        request.getRequestDispatcher("panelGerente.jsp").forward(request, response);
    }

    private void crearEmpleado(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        Empleado gerente = (Empleado) session.getAttribute("empleadoLogueado");
        
        try {
            Empleado empleado = new Empleado();
            empleado.setDni(request.getParameter("txtDni"));
            empleado.setNombres(request.getParameter("txtNombres"));
            empleado.setApellidos(request.getParameter("txtApellidos"));
            empleado.setEmail(request.getParameter("txtEmail"));
            empleado.setUsuario(request.getParameter("txtUsuario"));
            empleado.setPassword(request.getParameter("txtPassword"));
            empleado.setRol(request.getParameter("selectRol")); // 'RECEPCIONISTA' o 'GUARDIA'
            
            // Validamos que el rol sea correcto
            if (!"RECEPCIONISTA".equals(empleado.getRol()) && !"GUARDIA".equals(empleado.getRol())) {
                 session.setAttribute("error", "Rol no válido.");
                 response.sendRedirect("ControladorEmpleado?accion=verPanelGerente");
                 return;
            }
            
            // Usamos el SP 'sp_crear_empleado' que ya teníamos en el DAO
            String mensajeSP = empleadoDAO.registrarEmpleado(empleado, gerente.getIdEmpleado());
            
            if (mensajeSP.contains("exitosamente")) {
                session.setAttribute("exito", mensajeSP);
            } else {
                session.setAttribute("error", mensajeSP);
            }
            
        } catch (Exception e) {
            session.setAttribute("error", "Error inesperado: " + e.getMessage());
        }
        response.sendRedirect("ControladorEmpleado?accion=verPanelGerente");
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