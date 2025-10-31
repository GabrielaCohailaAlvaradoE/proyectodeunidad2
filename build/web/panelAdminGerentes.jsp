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
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Gestión de Gerentes - Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Poppins:wght@500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="css/theme.css">
</head>
<body data-theme="dark" class="min-vh-100 d-flex flex-column">
    <nav class="navbar navbar-expand-lg app-navbar sticky-top">
        <div class="container-fluid px-4">
            <a class="navbar-brand" href="ControladorSede?accion=listar">
                <i class="bi bi-diagram-3 me-2"></i><span class="brand-accent">Resguarda</span> Admin
            </a>
            <button class="navbar-toggler text-strong border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarAdmin" aria-controls="navbarAdmin" aria-expanded="false" aria-label="Alternar navegación">
                <i class="bi bi-list fs-3"></i>
            </button>
            <div class="collapse navbar-collapse justify-content-end" id="navbarAdmin">
                <ul class="navbar-nav align-items-lg-center me-lg-3">
                    <li class="nav-item"><a class="nav-link" href="ControladorSede?accion=listar">Sedes</a></li>
                    <li class="nav-item"><a class="nav-link active" href="ControladorEmpleado?accion=verPanelGerentes">Gerentes</a></li>
                    <li class="nav-item"><span class="nav-link">Admin: <strong class="text-strong"><%= empleadoLogueado.getNombres() %></strong></span></li>
                </ul>
                <div class="d-flex align-items-center gap-2">
                    <button class="btn btn-sm btn-outline-accent btn-theme-toggle" type="button" data-action="toggle-theme" aria-label="Cambiar tema">
                        <i class="bi bi-sun-fill" data-theme-icon></i>
                        <span class="ms-2" data-theme-label>Modo Claro</span>
                    </button>
                    <a href="ControladorEmpleado?accion=logout" class="btn btn-outline-primary btn-sm">
                        <i class="bi bi-box-arrow-right me-1"></i>Salir
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <main class="flex-grow-1">
        <div class="container-fluid px-4 py-5">
            <div class="row align-items-center mb-4" data-animate>
                <div class="col-lg-8">
                    <h1 class="section-title">Gestión de gerentes de sede</h1>
                    <p class="section-subtitle">Asigna gerentes a sedes disponibles y controla su estado operativo.</p>
                </div>
                <div class="col-lg-4 text-lg-end mt-3 mt-lg-0">
                    <button class="btn btn-primary btn-lg" data-bs-toggle="modal" data-bs-target="#modalNuevoGerente">
                        <i class="bi bi-plus-circle me-2"></i> Nuevo gerente
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

            <div class="app-card p-0" data-animate>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0 table-dark-mode">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Nombre completo</th>
                                <th>DNI</th>
                                <th>Sede asignada</th>
                                <th>Usuario</th>
                                <th>Estado</th>
                                <th class="text-center">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Empleado gerente : listaGerentes) { %>
                                <tr>
                                    <td><%= gerente.getIdEmpleado() %></td>
                                    <td class="fw-semibold text-strong"><%= gerente.getNombres() %> <%= gerente.getApellidos() %></td>
                                    <td><%= gerente.getDni() %></td>
                                    <td><%= gerente.getIdSede() %></td>
                                    <td><%= gerente.getUsuario() %></td>
                                    <td>
                                        <% if ("ACTIVO".equals(gerente.getEstado())) { %>
                                            <span class="badge bg-success">Activo</span>
                                        <% } else { %>
                                            <span class="badge bg-danger">Inactivo</span>
                                        <% } %>
                                    </td>
                                    <td class="text-center">
                                        <% if ("ACTIVO".equals(gerente.getEstado())) { %>
                                            <a href="ControladorEmpleado?accion=cambiarEstadoEmpleado&idEmpleado=<%= gerente.getIdEmpleado() %>&estado=INACTIVO" class="btn btn-sm btn-outline-danger" data-bs-toggle="tooltip" data-bs-title="Desactivar">
                                                <i class="bi bi-toggle-off"></i>
                                            </a>
                                        <% } else { %>
                                            <a href="ControladorEmpleado?accion=cambiarEstadoEmpleado&idEmpleado=<%= gerente.getIdEmpleado() %>&estado=ACTIVA" class="btn btn-sm btn-outline-success" data-bs-toggle="tooltip" data-bs-title="Activar">
                                                <i class="bi bi-toggle-on"></i>
                                            </a>
                                        <% } %>
                                        <button class="btn btn-sm btn-outline-secondary ms-1" disabled data-bs-toggle="tooltip" data-bs-title="Próximamente">
                                            <i class="bi bi-pencil"></i>
                                        </button>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>

    <footer class="py-4 text-center text-muted small mt-auto">
        &copy; <%= java.time.Year.now() %> Estación Resguarda.
    </footer>

    <div class="modal fade" id="modalNuevoGerente" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Registrar nuevo gerente</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="ControladorEmpleado" method="POST">
                    <input type="hidden" name="accion" value="crearGerente">
                    <div class="modal-body">
                        <div class="alert alert-info" role="alert">
                            <i class="bi bi-info-circle-fill me-2"></i>
                            Solo se muestran sedes activas sin un gerente asignado.
                        </div>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">DNI</label>
                                <input type="text" name="txtDni" class="form-control" required pattern="[0-9]{8}" maxlength="8">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Sede a asignar</label>
                                <select name="selectSede" class="form-select" required>
                                    <option value="">-- Seleccione una sede disponible --</option>
                                    <% for (Sede sede : listaSedesDisponibles) { %>
                                        <option value="<%= sede.getIdSede() %>"><%= sede.getNombre() %></option>
                                    <% } %>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Nombres</label>
                                <input type="text" name="txtNombres" class="form-control" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Apellidos</label>
                                <input type="text" name="txtApellidos" class="form-control" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Email</label>
                                <input type="email" name="txtEmail" class="form-control" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Nombre de usuario</label>
                                <input type="text" name="txtUsuario" class="form-control" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Contraseña</label>
                                <input type="password" name="txtPassword" class="form-control" required>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-outline-primary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-primary">Guardar gerente</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/app.js"></script>
</body>
</html>