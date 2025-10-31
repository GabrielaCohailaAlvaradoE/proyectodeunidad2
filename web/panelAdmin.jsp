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
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Panel de Administrador - Resguarda</title>
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
            <button class="navbar-toggler text-white border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarAdmin" aria-controls="navbarAdmin" aria-expanded="false" aria-label="Alternar navegación">
                <i class="bi bi-list fs-3"></i>
            </button>
            <div class="collapse navbar-collapse justify-content-end" id="navbarAdmin">
                <ul class="navbar-nav align-items-lg-center me-lg-3">
                    <li class="nav-item"><a class="nav-link active" href="ControladorSede?accion=listar">Sedes</a></li>
                    <li class="nav-item"><a class="nav-link" href="ControladorEmpleado?accion=verPanelGerentes">Gerentes</a></li>
                    <li class="nav-item"><span class="nav-link">Admin: <strong class="text-white"><%= empleadoLogueado.getNombres() %></strong></span></li>
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
                    <h1 class="section-title">Gestión de sedes</h1>
                    <p class="section-subtitle">Administra las sedes activas, sus tarifas base y su estado operativo.</p>
                </div>
                <div class="col-lg-4 text-lg-end mt-3 mt-lg-0">
                    <button class="btn btn-primary btn-lg" data-bs-toggle="modal" data-bs-target="#modalNuevaSede">
                        <i class="bi bi-plus-circle me-2"></i>Nueva sede
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
                                <th>Nombre</th>
                                <th>Dirección</th>
                                <th>Teléfono</th>
                                <th>Tarifa Base</th>
                                <th>Estado</th>
                                <th class="text-center">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Sede sede : listaSedes) { %>
                                <tr>
                                    <td><%= sede.getIdSede() %></td>
                                    <td class="fw-semibold text-white"><%= sede.getNombre() %></td>
                                    <td><%= sede.getDireccion() != null ? sede.getDireccion() : "" %></td>
                                    <td><%= sede.getTelefono() != null ? sede.getTelefono() : "" %></td>
                                    <td><%= currencyFormatter.format(sede.getTarifaBase()).replace("PEN", "S/") %></td>
                                    <td>
                                        <% if ("ACTIVA".equals(sede.getEstado())) { %>
                                            <span class="badge bg-success">Activa</span>
                                        <% } else { %>
                                            <span class="badge bg-danger">Inactiva</span>
                                        <% } %>
                                    </td>
                                    <td class="text-center">
                                        <% if ("ACTIVA".equals(sede.getEstado())) { %>
                                            <a href="ControladorSede?accion=cambiarEstado&idSede=<%= sede.getIdSede() %>&estado=INACTIVA" class="btn btn-sm btn-outline-danger" data-bs-toggle="tooltip" data-bs-title="Desactivar">
                                                <i class="bi bi-toggle-off"></i>
                                            </a>
                                        <% } else { %>
                                            <a href="ControladorSede?accion=cambiarEstado&idSede=<%= sede.getIdSede() %>&estado=ACTIVA" class="btn btn-sm btn-outline-success" data-bs-toggle="tooltip" data-bs-title="Activar">
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

    <div class="modal fade" id="modalNuevaSede" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Registrar nueva sede</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="ControladorSede" method="POST">
                    <input type="hidden" name="accion" value="crear">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Nombre de la sede</label>
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
                            <label class="form-label">Tarifa base por hora (S/)</label>
                            <input type="number" step="0.01" name="txtTarifaBase" class="form-control" required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-outline-primary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-primary">Guardar sede</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/app.js"></script>
</body>
</html>