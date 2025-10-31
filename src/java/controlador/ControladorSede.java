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
import modelo.Sede;
import modeloDAO.SedeDAO;

@WebServlet(name = "ControladorSede", urlPatterns = {"/ControladorSede"})
public class ControladorSede extends HttpServlet {

    SedeDAO sedeDAO = new SedeDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // --- Bloque de Seguridad ---
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("empleadoLogueado") == null) {
            response.sendRedirect("admin.jsp?error=Sesión expirada");
            return;
        }
        
        Empleado empleado = (Empleado) session.getAttribute("empleadoLogueado");
        if (!"ADMINISTRADOR".equals(empleado.getRol())) {
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
                listarSedes(request, response);
                break;
            case "crear":
                crearSede(request, response);
                break;
            case "cambiarEstado":
                cambiarEstadoSede(request, response);
                break;
            /*
            case "editar": // Para implementar después
                mostrarFormularioEditar(request, response);
                break;
            case "actualizar": // Para implementar después
                actualizarSede(request, response);
                break;
            */
            default:
                listarSedes(request, response);
        }
    }

    private void listarSedes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Sede> listaSedes = sedeDAO.listarTodas();
        request.setAttribute("listaSedes", listaSedes);
        request.getRequestDispatcher("panelAdmin.jsp").forward(request, response);
    }

    private void crearSede(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        try {
            Sede sede = new Sede();
            sede.setNombre(request.getParameter("txtNombre"));
            sede.setDireccion(request.getParameter("txtDireccion"));
            sede.setTelefono(request.getParameter("txtTelefono"));
            sede.setTarifaBase(Double.parseDouble(request.getParameter("txtTarifaBase")));

            int idGenerado = sedeDAO.crear(sede);
            if (idGenerado > 0) {
                session.setAttribute("exito", "Sede '" + sede.getNombre() + "' creada exitosamente (ID: " + idGenerado + ").");
            } else {
                session.setAttribute("error", "Error al crear la sede.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "La tarifa base debe ser un número válido.");
        }
        response.sendRedirect("ControladorSede?accion=listar"); // Redirigimos al listado
    }

    private void cambiarEstadoSede(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        try {
            int idSede = Integer.parseInt(request.getParameter("idSede"));
            String nuevoEstado = request.getParameter("estado");

            if (sedeDAO.cambiarEstado(idSede, nuevoEstado)) {
                session.setAttribute("exito", "Estado de la sede " + idSede + " actualizado a " + nuevoEstado);
            } else {
                session.setAttribute("error", "Error al actualizar el estado de la sede.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "ID de sede inválido.");
        }
        response.sendRedirect("ControladorSede?accion=listar"); // Redirigimos al listado
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
