<%-- 
    Document   : panelAdmin
    Created on : 22 oct. 2025, 8:30:53 a. m.
    Author     : ASUS
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="modelo.Empleado" %>
<%@ page import="modelo.Sede" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>

<%
    Empleado empleadoLogueado = (Empleado) session.getAttribute("empleadoLogueado");

    if (empleadoLogueado == null) {
        response.sendRedirect("admin.jsp");
        return;
    }

    if (!"ADMINISTRADOR".equals(empleadoLogueado.getRol())) {
        response.sendRedirect("admin.jsp?error=No tiene permisos de Administrador");
        return;
    }

    String exito = (String) session.getAttribute("exito");
    String error = (String) session.getAttribute("error");
    if (exito != null) session.removeAttribute("exito");
    if (error != null) session.removeAttribute("error");

    List<Sede> listaSedes = (List<Sede>) request.getAttribute("listaSedes");
    if (listaSedes == null) {
        listaSedes = new ArrayList<>();
    }

    NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("es", "PE"));
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Administrador - Resguarda</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        body { background-color: #f0f2f5; }
        .sidebar {
            background-color: #fff; min-height: 100vh;
            box-shadow: 0 0 1rem 0 rgba(0, 0, 0, .05);
        }
        .nav-link { color: #555; font-weight: 500; }
        .nav-link.active { color: #004e92; background-color: #e6f0fa; }
        .nav-link:hover { background-color: #f8f9fa; }
        .navbar-brand { color: #004e92 !important; font-weight: 700; }
        .content { min-height: 100vh; }
    </style>
</head>
<body>

    <div class="container-fluid">
        <div class="row">
            <nav class="col-md-3 col-lg-2 d-md-block sidebar collapse">
                <div class="position-sticky pt-3">
                    <a class="navbar-brand ms-3 mb-3" href="#">
                        <i class="bi bi-shield-lock-fill"></i> Resguarda
                    </a>
                    
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link active" href="ControladorSede?accion=listar">
                                <i class="bi bi-buildings-fill me-2"></i> Gestión de Sedes
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="ControladorEmpleado?accion=verPanelGerentes">
                                <i class="bi bi-person-video3 me-2"></i> Gestión de Gerentes
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">
                                <i class="bi bi-people-fill me-2"></i> Gestión de Usuarios
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">
                                <i class="bi bi-archive-fill me-2"></i> Reportes y Auditoría
                            </a>
                        </li>
                    </ul>
                    <hr>
                    <div class="dropdown p-3">
                        <a href="#" class="d-flex align-items-center text-dark text-decoration-none dropdown-toggle" data-bs-toggle="dropdown">
                            <i class="bi bi-person-circle fs-4 me-2"></i>
                            <strong><%= empleadoLogueado.getNombres() %></strong>
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="#">Mi Perfil</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="ControladorEmpleado?accion=logout">Cerrar Sesión</a></li>
                        </ul>
                    </div>
                </div>
            </nav>

            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 content">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Gestión de Sedes</h1>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalNuevaSede">
                        <i class="bi bi-plus-circle me-1"></i> Nueva Sede
                    </button>
                </div>

                <% if (exito != null) { %>
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <%= exito %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>
                <% if (error != null) { %>
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <%= error %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>


                <div class="card shadow-sm">
                    <div class="card-body">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Nombre Sede</th>
                                    <th>Dirección</th>
                                    <th>Teléfono</th>
                                    <th>Tarifa Base (Hora)</th>
                                    <th>Estado</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Sede sede : listaSedes) { %>
                                    <tr>
                                        <td><%= sede.getIdSede() %></td>
                                        <td><strong><%= sede.getNombre() %></strong></td>
                                        <td><%= sede.getDireccion() != null ? sede.getDireccion() : "" %></td>
                                        <td><%= sede.getTelefono() != null ? sede.getTelefono() : "" %></td>
                                        <td><%= currencyFormatter.format(sede.getTarifaBase()).replace("PEN", "S/") %></td>
                                        <td>
                                            <% if ("ACTIVA".equals(sede.getEstado())) { %><span class="badge bg-success">Activa</span><% } %>
                                            <% if ("INACTIVA".equals(sede.getEstado())) { %><span class="badge bg-danger">Inactiva</span><% } %>
                                        </td>
                                        <td>
                                            <% if ("ACTIVA".equals(sede.getEstado())) { %>
                                                <a href="ControladorSede?accion=cambiarEstado&idSede=<%= sede.getIdSede() %>&estado=INACTIVA" class="btn btn-sm btn-outline-danger" title="Desactivar">
                                                    <i class="bi bi-toggle-off"></i>
                                                </a>
                                            <% } else { %>
                                                <a href="ControladorSede?accion=cambiarEstado&idSede=<%= sede.getIdSede() %>&estado=ACTIVA" class="btn btn-sm btn-outline-success" title="Activar">
                                                    <i class="bi bi-toggle-on"></i>
                                                </a>
                                            <% } %>
                                            <button class="btn btn-sm btn-outline-secondary" title="Editar" disabled>
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <div class="modal fade" id="modalNuevaSede" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Registrar Nueva Sede</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="ControladorSede" method="POST">
                    <input type="hidden" name="accion" value="crear">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Nombre de la Sede</label>
                            <input type="text" name="txtNombre" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Dirección</label>
                            <input type="text" name="txtDireccion" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Teléfono</label>
                            <input type="tel" name="txtTelefono" class="form-control">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Tarifa Base por Hora (Ej: 5.00)</label>
                            <input type="number" step="0.01" name="txtTarifaBase" class="form-control" required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-primary">Guardar Sede</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>