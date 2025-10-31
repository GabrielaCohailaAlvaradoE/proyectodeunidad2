<%-- 
    Document   : panelGerente
    Created on : 22 oct. 2025, 8:38:40 a. m.
    Author     : ASUS
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="modelo.Empleado" %>
<%@ page import="modelo.Piso" %>
<%@ page import="modelo.Espacio" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%
    Empleado empleadoLogueado = (Empleado) session.getAttribute("empleadoLogueado");

    if (empleadoLogueado == null) {
        response.sendRedirect("admin.jsp");
        return;
    }

    if (!"GERENTE".equals(empleadoLogueado.getRol())) {
        response.sendRedirect("admin.jsp?error=No tiene permisos de Gerente");
        return;
    }

    String exito = (String) session.getAttribute("exito");
    String error = (String) session.getAttribute("error");
    if (exito != null) session.removeAttribute("exito");
    if (error != null) session.removeAttribute("error");

    List<Piso> listaPisos = (List<Piso>) request.getAttribute("listaPisos");
    if (listaPisos == null) {
        listaPisos = new ArrayList<>(); // Evita NullPointerException si la lista no se carga
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión Pisos/Espacios (Sede <%= empleadoLogueado.getIdSede() %>)</title>
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
        .espacio-badge { font-size: 0.9em; margin: 2px; }
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
                            <a class="nav-link" href="ControladorEmpleado?accion=verPanelGerente">
                                <i class="bi bi-person-workspace me-2"></i> Gestión de Empleados
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="ControladorSedeGestion?accion=listar">
                                <i class="bi bi-layout-wtf me-2"></i> Gestión de Pisos/Espacios
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">
                                <i class="bi bi-clipboard-data me-2"></i> Auditoría (Mi Sede)
                            </a>
                        </li>
                    </ul>
                    <hr>
                    <div class="dropdown p-3">
                        <a href="#" class="d-flex align-items-center text-dark text-decoration-none dropdown-toggle" data-bs-toggle="dropdown">
                            <i class="bi bi-person-video3 fs-4 me-2"></i>
                            <strong><%= empleadoLogueado.getNombres() %></strong>
                        </a>
                        <ul class="dropdown-menu">
                            <li><span class="dropdown-item-text">Gerente (Sede <%= empleadoLogueado.getIdSede() %>)</span></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="ControladorEmpleado?accion=logout">Cerrar Sesión</a></li>
                        </ul>
                    </div>
                </div>
            </nav>

            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 content">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Gestión de Pisos y Espacios</h1>
                    <div>
                        <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#modalNuevoEspacio">
                            <i class="bi bi-plus-square me-1"></i> Nuevo Espacio
                        </button>
                        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalNuevoPiso">
                            <i class="bi bi-plus-circle me-1"></i> Nuevo Piso
                        </button>
                    </div>
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

                <div class="accordion" id="acordeonPisos">
                    <% int count = 0; %>
                    <% for (Piso piso : listaPisos) { %>
                        <% boolean isFirst = (count == 0); %>
                        <div class="accordion-item">
                            <h2 class="accordion-header">
                                <button class="accordion-button <%= isFirst ? "" : "collapsed" %>" type="button" data-bs-toggle="collapse" data-bs-target="#collapse-<%= piso.getIdPiso() %>">
                                    <span class="fs-5 me-3"><%= piso.getNombrePiso() %> (Nivel <%= piso.getNumeroPiso() %>)</span>
                                    <% if ("ACTIVO".equals(piso.getEstado())) { %><span class="badge bg-success me-3">Activo</span><% } %>
                                    <% if ("INACTIVO".equals(piso.getEstado())) { %><span class="badge bg-danger me-3">Inactivo</span><% } %>
                                    <span class="badge bg-secondary">Capacidad: <%= piso.getCapacidadTotal() %></span>
                                </button>
                            </h2>
                            <div id="collapse-<%= piso.getIdPiso() %>" class="accordion-collapse collapse <%= isFirst ? "show" : "" %>" data-bs-parent="#acordeonPisos">
                                <div class="accordion-body">
                                    <div class="d-flex justify-content-between mb-3">
                                        <h5>Espacios del <%= piso.getNombrePiso() %></h5>
                                        <div>
                                            <% if ("ACTIVO".equals(piso.getEstado())) { %>
                                                <a href="ControladorSedeGestion?accion=cambiarEstadoPiso&idPiso=<%= piso.getIdPiso() %>&estado=INACTIVO" class="btn btn-sm btn-outline-danger">Desactivar Piso</a>
                                            <% } else { %>
                                                <a href="ControladorSedeGestion?accion=cambiarEstadoPiso&idPiso=<%= piso.getIdPiso() %>&estado=ACTIVO" class="btn btn-sm btn-outline-success">Activar Piso</a>
                                            <% } %>
                                        </div>
                                    </div>
                                    
                                    <% List<Espacio> espaciosDelPiso = piso.getEspacios(); %>
                                    <% if (espaciosDelPiso == null || espaciosDelPiso.isEmpty()) { %>
                                        <p class="text-muted">No hay espacios registrados en este piso.</p>
                                    <% } else { %>
                                        <div class="d-flex flex-wrap">
                                            <% for (Espacio espacio : espaciosDelPiso) { %>
                                                <% String badgeClass = "";
                                                   if ("LIBRE".equals(espacio.getEstado())) badgeClass = "text-bg-success";
                                                   else if ("OCUPADO".equals(espacio.getEstado())) badgeClass = "text-bg-danger";
                                                   else if ("MANTENIMIENTO".equals(espacio.getEstado())) badgeClass = "text-bg-warning";
                                                   else badgeClass = "text-bg-secondary";
                                                %>
                                                <span class="badge espacio-badge <%= badgeClass %>">
                                                    <%= espacio.getNumeroEspacio() %>
                                                </span>
                                            <% } %>
                                        </div>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                        <% count++; %>
                    <% } %>
                </div>
            </main>
        </div>
    </div>

    <div class="modal fade" id="modalNuevoPiso" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Registrar Nuevo Piso</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="ControladorSedeGestion" method="POST">
                    <input type="hidden" name="accion" value="crearPiso">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Nombre del Piso (Ej: Sótano 1, Nivel 2)</label>
                            <input type="text" name="txtNombrePiso" class="form-control" required>
                        </div>
                        <div class="row">
                            <div class="col-6">
                                <label class="form-label">Número de Piso (Ej: -1, 2)</label>
                                <input type="number" name="txtNumeroPiso" class="form-control" required>
                            </div>
                            <div class="col-6">
                                <label class="form-label">Capacidad Total (Vehículos)</label>
                                <input type="number" name="txtCapacidadPiso" class="form-control" required>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-primary">Guardar Piso</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <div class="modal fade" id="modalNuevoEspacio" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Registrar Nuevo Espacio</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="ControladorSedeGestion" method="POST">
                    <input type="hidden" name="accion" value="crearEspacio">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Piso al que pertenece</label>
                            <select name="selectIdPiso" class="form-select" required>
                                <option value="">-- Seleccione un piso de su sede --</option>
                                <% for (Piso piso : listaPisos) { %>
                                    <% if ("ACTIVO".equals(piso.getEstado())) { %>
                                        <option value="<%= piso.getIdPiso() %>"><%= piso.getNombrePiso() %></option>
                                    <% } %>
                                <% } %>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Número de Espacio (Ej: A01, B12)</label>
                            <input type="text" name="txtNumeroEspacio" class="form-control" required>
                        </div>
                         <div class="mb-3">
                            <label class="form-label">Descripción (Opcional)</label>
                            <input type="text" name="txtDescripcionEspacio" class="form-control" placeholder="Ej: Cerca al ascensor">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-primary">Guardar Espacio</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>