<%-- 
    Document   : panelAdminGerentes
    Created on : 22 oct. 2025, 8:35:39 a. m.
    Author     : ASUS
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="modelo.Empleado" %>
<%@ page import="modelo.Sede" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

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

    List<Empleado> listaGerentes = (List<Empleado>) request.getAttribute("listaGerentes");
    List<Sede> listaSedesDisponibles = (List<Sede>) request.getAttribute("listaSedesDisponibles");

    if (listaGerentes == null) listaGerentes = new ArrayList<>();
    if (listaSedesDisponibles == null) listaSedesDisponibles = new ArrayList<>();
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Gerentes - Admin</title>
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
                            <a class="nav-link" href="ControladorSede?accion=listar">
                                <i class="bi bi-buildings-fill me-2"></i> Gestión de Sedes
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="ControladorEmpleado?accion=verPanelGerentes">
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
                    <h1 class="h2">Gestión de Gerentes de Sede</h1>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalNuevoGerente">
                        <i class="bi bi-plus-circle me-1"></i> Nuevo Gerente
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
                                    <th>Nombres Completos</th>
                                    <th>DNI</th>
                                    <th>Sede Asignada (ID)</th>
                                    <th>Usuario</th>
                                    <th>Estado</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Empleado gerente : listaGerentes) { %>
                                    <tr>
                                        <td><%= gerente.getIdEmpleado() %></td>
                                        <td><strong><%= gerente.getNombres() %> <%= gerente.getApellidos() %></strong></td>
                                        <td><%= gerente.getDni() %></td>
                                        <td><%= gerente.getIdSede() %></td>
                                        <td><%= gerente.getUsuario() %></td>
                                        <td>
                                            <% if ("ACTIVO".equals(gerente.getEstado())) { %><span class="badge bg-success">Activo</span><% } %>
                                            <% if ("INACTIVO".equals(gerente.getEstado())) { %><span class="badge bg-danger">Inactivo</span><% } %>
                                        </td>
                                        <td>
                                            <% if ("ACTIVO".equals(gerente.getEstado())) { %>
                                                <a href="ControladorEmpleado?accion=cambiarEstadoEmpleado&idEmpleado=<%= gerente.getIdEmpleado() %>&estado=INACTIVO" class="btn btn-sm btn-outline-danger" title="Desactivar">
                                                    <i class="bi bi-toggle-off"></i>
                                                </a>
                                            <% } else { %>
                                                <a href="ControladorEmpleado?accion=cambiarEstadoEmpleado&idEmpleado=<%= gerente.getIdEmpleado() %>&estado=ACTIVA" class="btn btn-sm btn-outline-success" title="Activar">
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

    <div class="modal fade" id="modalNuevoGerente" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Registrar Nuevo Gerente</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="ControladorEmpleado" method="POST">
                    <input type="hidden" name="accion" value="crearGerente">
                    <div class="modal-body">
                        
                        <div class="alert alert-info" role="alert">
                            <i class="bi bi-info-circle-fill me-2"></i>
                            Solo se muestran las sedes <strong>activas</strong> que <strong>no tienen</strong> un gerente asignado.
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">DNI</label>
                                <input type="text" name="txtDni" class="form-control" required pattern="[0-9]{8}" maxlength="8">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Sede a Asignar</label>
                                <select name="selectSede" class="form-select" required>
                                    <option value="">-- Seleccione una sede disponible --</option>
                                    <% for (Sede sede : listaSedesDisponibles) { %>
                                        <option value="<%= sede.getIdSede() %>"><%= sede.getNombre() %></option>
                                    <% } %>
                                </select>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Nombres</label>
                                <input type="text" name="txtNombres" class="form-control" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Apellidos</label>
                                <input type="text" name="txtApellidos" class="form-control" required>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Email</label>
                            <input type="email" name="txtEmail" class="form-control" required>
                        </div>
                        
                        <hr>
                        
                         <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Nombre de Usuario</label>
                                <input type="text" name="txtUsuario" class="form-control" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Contraseña</label>
                                <input type="password" name="txtPassword" class="form-control" required>
                            </div>
                        </div>

                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-primary">Guardar Gerente</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
