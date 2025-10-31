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
        listaPisos = new ArrayList<>();
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Gestión de Pisos y Espacios - Gerente</title>
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
            <a class="navbar-brand" href="ControladorEmpleado?accion=verPanelGerente">
                <i class="bi bi-buildings me-2"></i><span class="brand-accent">Resguarda</span> Gerencia
            </a>
            <button class="navbar-toggler text-strong border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarGerente" aria-controls="navbarGerente" aria-expanded="false" aria-label="Alternar navegación">
                <i class="bi bi-list fs-3"></i>
            </button>
            <div class="collapse navbar-collapse justify-content-end" id="navbarGerente">
                <ul class="navbar-nav align-items-lg-center me-lg-3">
                    <li class="nav-item"><a class="nav-link" href="ControladorEmpleado?accion=verPanelGerente">Equipo</a></li>
                    <li class="nav-item"><a class="nav-link active" href="ControladorSedeGestion?accion=listar">Pisos y espacios</a></li>
                    <li class="nav-item"><span class="nav-link">Sede <strong class="text-strong"><%= empleadoLogueado.getIdSede() %></strong></span></li>
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
                    <h1 class="section-title">Pisos y espacios de estacionamiento</h1>
                    <p class="section-subtitle">Administra la disponibilidad de la sede y crea nuevos pisos o espacios cuando sea necesario.</p>
                </div>
                <div class="col-lg-4 text-lg-end mt-3 mt-lg-0 d-flex flex-wrap gap-2 justify-content-lg-end">
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalNuevoPiso">
                        <i class="bi bi-plus-circle me-2"></i> Nuevo piso
                    </button>
                    <button class="btn btn-outline-accent" data-bs-toggle="modal" data-bs-target="#modalNuevoEspacio">
                        <i class="bi bi-plus-square me-2"></i> Nuevo espacio
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

            <div class="app-card p-4" data-animate>
                <div class="accordion" id="acordeonPisos">
                    <% int count = 0; %>
                    <% for (Piso piso : listaPisos) { %>
                        <% boolean isFirst = (count == 0); %>
                        <div class="accordion-item">
                            <h2 class="accordion-header">
                                <button class="accordion-button <%= isFirst ? "" : "collapsed" %>" type="button" data-bs-toggle="collapse" data-bs-target="#collapse-<%= piso.getIdPiso() %>">
                                    <div class="d-flex flex-column flex-md-row w-100 justify-content-between">
                                        <div>
                                            <span class="fw-semibold"> <%= piso.getNombrePiso() %> </span>
                                            <span class="text-muted ms-2">Nivel <%= piso.getNumeroPiso() %></span>
                                        </div>
                                        <div class="d-flex gap-2 flex-wrap mt-2 mt-md-0">
                                            <span class="badge bg-secondary">Capacidad: <%= piso.getCapacidadTotal() %></span>
                                            <% if ("ACTIVO".equals(piso.getEstado())) { %>
                                                <span class="badge bg-success">Activo</span>
                                            <% } else { %>
                                                <span class="badge bg-danger">Inactivo</span>
                                            <% } %>
                                        </div>
                                    </div>
                                </button>
                            </h2>
                            <div id="collapse-<%= piso.getIdPiso() %>" class="accordion-collapse collapse <%= isFirst ? "show" : "" %>" data-bs-parent="#acordeonPisos">
                                <div class="accordion-body">
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <h5 class="mb-0">Espacios registrados</h5>
                                        <div>
                                            <% if ("ACTIVO".equals(piso.getEstado())) { %>
                                                <a href="ControladorSedeGestion?accion=cambiarEstadoPiso&idPiso=<%= piso.getIdPiso() %>&estado=INACTIVO" class="btn btn-sm btn-outline-danger">Desactivar piso</a>
                                            <% } else { %>
                                                <a href="ControladorSedeGestion?accion=cambiarEstadoPiso&idPiso=<%= piso.getIdPiso() %>&estado=ACTIVO" class="btn btn-sm btn-outline-success">Activar piso</a>
                                            <% } %>
                                        </div>
                                    </div>

                                    <% List<Espacio> espaciosDelPiso = piso.getEspacios(); %>
                                    <% if (espaciosDelPiso == null || espaciosDelPiso.isEmpty()) { %>
                                        <p class="text-muted">No hay espacios registrados en este piso.</p>
                                    <% } else { %>
                                        <div class="d-flex flex-wrap gap-2">
                                            <% for (Espacio espacio : espaciosDelPiso) { %>
                                                <% String badgeClass = "";
                                                   if ("LIBRE".equals(espacio.getEstado())) badgeClass = "text-bg-success";
                                                   else if ("OCUPADO".equals(espacio.getEstado())) badgeClass = "text-bg-danger";
                                                   else if ("MANTENIMIENTO".equals(espacio.getEstado())) badgeClass = "text-bg-warning";
                                                   else badgeClass = "text-bg-secondary";
                                                %>
                                                <span class="badge espacio-badge <%= badgeClass %>"><%= espacio.getNumeroEspacio() %></span>
                                            <% } %>
                                        </div>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                        <% count++; %>
                    <% } %>
                </div>
            </div>
        </div>
    </main>

    <footer class="py-4 text-center text-muted small mt-auto">
        &copy; <%= java.time.Year.now() %> Estación Resguarda.
    </footer>

    <div class="modal fade" id="modalNuevoPiso" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Registrar nuevo piso</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="ControladorSedeGestion" method="POST">
                    <input type="hidden" name="accion" value="crearPiso">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Nombre del piso</label>
                            <input type="text" name="txtNombrePiso" class="form-control" required>
                        </div>
                        <div class="row g-3">
                            <div class="col-6">
                                <label class="form-label">Número de piso</label>
                                <input type="number" name="txtNumeroPiso" class="form-control" required>
                            </div>
                            <div class="col-6">
                                <label class="form-label">Capacidad total</label>
                                <input type="number" name="txtCapacidadPiso" class="form-control" required>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-outline-primary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-primary">Guardar piso</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="modalNuevoEspacio" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Registrar nuevo espacio</h5>
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
                            <label class="form-label">Número de espacio</label>
                            <input type="text" name="txtNumeroEspacio" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Descripción (opcional)</label>
                            <input type="text" name="txtDescripcionEspacio" class="form-control" placeholder="Ej: Cerca al ascensor">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-outline-primary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-primary">Guardar espacio</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/app.js"></script>
</body>
</html>