/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
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
import modelo.Espacio;
import modelo.Piso;
import modeloDAO.EspacioDAO;
import modeloDAO.PisoDAO;

@WebServlet(name = "ControladorSedeGestion", urlPatterns = {"/ControladorSedeGestion"})
public class ControladorSedeGestion extends HttpServlet {

    PisoDAO pisoDAO = new PisoDAO();
    EspacioDAO espacioDAO = new EspacioDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // --- Bloque de Seguridad: Solo Gerentes ---
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("empleadoLogueado") == null) {
            response.sendRedirect("admin.jsp?error=Sesión expirada");
            return;
        }
        
        Empleado empleado = (Empleado) session.getAttribute("empleadoLogueado");
        if (!"GERENTE".equals(empleado.getRol())) {
            response.sendRedirect("admin.jsp?error=Acceso no autorizado");
            return;
        }
        // --- Fin del Bloque de Seguridad ---
        
        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = "listar"; // Acción por defecto
        }

        switch (accion) {
            case "listar":
                listarPisosYEspacios(request, response);
                break;
            case "crearPiso":
                crearPiso(request, response, empleado);
                break;
            case "crearEspacio":
                crearEspacio(request, response, empleado);
                break;
            case "cambiarEstadoPiso":
                cambiarEstadoPiso(request, response);
                break;
            case "cambiarEstadoEspacio":
                cambiarEstadoEspacio(request, response);
                break;
            default:
                listarPisosYEspacios(request, response);
        }
    }

    private void listarPisosYEspacios(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Empleado gerente = (Empleado) request.getSession().getAttribute("empleadoLogueado");
        
        // 1. Obtenemos los pisos de la sede del gerente
        List<Piso> pisos = pisoDAO.listarPorSede(gerente.getIdSede());
        
        // 2. Para cada piso, obtenemos sus espacios (Anidado)
        for (Piso piso : pisos) {
            List<Espacio> espacios = espacioDAO.listarPorPiso(piso.getIdPiso());
            piso.setEspacios(espacios);
        }
        
        request.setAttribute("listaPisos", pisos);
        request.getRequestDispatcher("panelGerentePisos.jsp").forward(request, response);
    }

    private void crearPiso(HttpServletRequest request, HttpServletResponse response, Empleado gerente)
            throws IOException {
        HttpSession session = request.getSession();
        try {
            Piso piso = new Piso();
            piso.setIdSede(gerente.getIdSede()); // Sede del Gerente
            piso.setCreadoPor(gerente.getIdEmpleado()); // Gerente
            piso.setNumeroPiso(Integer.parseInt(request.getParameter("txtNumeroPiso")));
            piso.setNombrePiso(request.getParameter("txtNombrePiso"));
            piso.setCapacidadTotal(Integer.parseInt(request.getParameter("txtCapacidadPiso")));

            if (pisoDAO.crear(piso)) {
                session.setAttribute("exito", "Piso '" + piso.getNombrePiso() + "' creado exitosamente.");
            } else {
                session.setAttribute("error", "Error al crear el piso.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Datos numéricos inválidos.");
        }
        response.sendRedirect("ControladorSedeGestion?accion=listar");
    }

    private void crearEspacio(HttpServletRequest request, HttpServletResponse response, Empleado gerente)
            throws IOException {
        HttpSession session = request.getSession();
        try {
            Espacio espacio = new Espacio();
            espacio.setIdPiso(Integer.parseInt(request.getParameter("selectIdPiso")));
            espacio.setCreadoPor(gerente.getIdEmpleado());
            espacio.setNumeroEspacio(request.getParameter("txtNumeroEspacio"));
            espacio.setDescripcion(request.getParameter("txtDescripcionEspacio"));

            // (Validación pendiente: Gerente solo puede crear en pisos de su sede)
            
            if (espacioDAO.crear(espacio)) {
                session.setAttribute("exito", "Espacio '" + espacio.getNumeroEspacio() + "' creado exitosamente.");
            } else {
                session.setAttribute("error", "Error al crear el espacio.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "ID de Piso inválido.");
        }
        response.sendRedirect("ControladorSedeGestion?accion=listar");
    }

    private void cambiarEstadoPiso(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        try {
            int idPiso = Integer.parseInt(request.getParameter("idPiso"));
            String nuevoEstado = request.getParameter("estado");
            
            if (pisoDAO.cambiarEstado(idPiso, nuevoEstado)) {
                session.setAttribute("exito", "Estado del piso actualizado.");
            } else {
                session.setAttribute("error", "Error al cambiar estado del piso.");
            }
        } catch (Exception e) {
            session.setAttribute("error", "Error: " + e.getMessage());
        }
        response.sendRedirect("ControladorSedeGestion?accion=listar");
    }

    private void cambiarEstadoEspacio(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        try {
            int idEspacio = Integer.parseInt(request.getParameter("idEspacio"));
            String nuevoEstado = request.getParameter("estado");
            
            if (espacioDAO.cambiarEstado(idEspacio, nuevoEstado)) {
                session.setAttribute("exito", "Estado del espacio actualizado.");
            } else {
                session.setAttribute("error", "Error al cambiar estado del espacio.");
            }
        } catch (Exception e) {
            session.setAttribute("error", "Error: " + e.getMessage());
        }
        response.sendRedirect("ControladorSedeGestion?accion=listar");
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