<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="modelo.Cliente" %>
<%@ page import="modelo.Vehiculo" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%
    Cliente clienteLogueado = (Cliente) session.getAttribute("clienteLogueado");
    if (clienteLogueado == null) {
        response.sendRedirect("login.jsp?error=Sesión expirada");
        return;
    }

    String exito = (String) session.getAttribute("exito");
    String error = (String) session.getAttribute("error");
    if (exito != null) session.removeAttribute("exito");
    if (error != null) session.removeAttribute("error");

    List<Vehiculo> listaVehiculos = (List<Vehiculo>) request.getAttribute("listaVehiculos");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Mis Vehículos - Estación Resguarda</title>
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
            <a class="navbar-brand" href="ControladorCliente?accion=verPanel">
                <i class="bi bi-shield-lock-fill me-2"></i><span class="brand-accent">Resguarda</span> Cliente
            </a>
            <button class="navbar-toggler text-white border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarCliente" aria-controls="navbarCliente" aria-expanded="false" aria-label="Alternar navegación">
                <i class="bi bi-list fs-3"></i>
            </button>
            <div class="collapse navbar-collapse justify-content-end" id="navbarCliente">
                <ul class="navbar-nav align-items-lg-center me-lg-3">
                    <li class="nav-item"><span class="nav-link">Hola, <strong class="text-white"><%= clienteLogueado.getNombres() %></strong></span></li>
                    <li class="nav-item"><a class="nav-link" href="ControladorCliente?accion=verPanel">Panel</a></li>
                    <li class="nav-item"><a class="nav-link active" href="ControladorCliente?accion=verMisVehiculos">Mis Vehículos</a></li>
                    <li class="nav-item"><a class="nav-link" href="ControladorCliente?accion=verHistorial">Historial</a></li>
                </ul>
                <div class="d-flex align-items-center gap-2">
                    <button class="btn btn-sm btn-outline-accent btn-theme-toggle" type="button" data-action="toggle-theme" aria-label="Cambiar tema">
                        <i class="bi bi-sun-fill" data-theme-icon></i>
                        <span class="ms-2" data-theme-label>Modo Claro</span>
                    </button>
                    <a href="ControladorCliente?accion=logout" class="btn btn-outline-primary btn-sm">
                        <i class="bi bi-box-arrow-right me-1"></i>Salir
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <main class="flex-grow-1">
        <div class="container py-5">
            <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-center mb-4 gap-3" data-animate>
                <div>
                    <h1 class="section-title mb-2">Mis vehículos registrados</h1>
                    <p class="section-subtitle mb-0">Mantén tu flota personal organizada y lista para ingresar o salir.</p>
                </div>
                <button class="btn btn-primary btn-lg" data-bs-toggle="modal" data-bs-target="#modalNuevoVehiculo">
                    <i class="bi bi-plus-circle me-2"></i> Agregar vehículo
                </button>
            </div>

            <% if (exito != null) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i> <%= exito %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>
            <% if (error != null) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i> <%= error %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>

            <div class="app-card p-0" data-animate>
                <div class="table-responsive">
                    <% if (listaVehiculos == null || listaVehiculos.isEmpty()) { %>
                        <div class="p-5 text-center text-muted">Aún no tienes vehículos registrados.</div>
                    <% } else { %>
                        <table class="table table-hover align-middle mb-0 table-dark-mode">
                            <thead>
                                <tr>
                                    <th>Placa</th>
                                    <th>Marca</th>
                                    <th>Modelo</th>
                                    <th>Color</th>
                                    <th>Año</th>
                                    <th>SOAT</th>
                                    <th>VIN</th>
                                    <th class="text-center">Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Vehiculo vehiculo : listaVehiculos) { %>
                                    <tr>
                                        <td class="fw-semibold text-white"><%= vehiculo.getPlaca() %></td>
                                        <td><%= vehiculo.getMarca() != null ? vehiculo.getMarca() : "" %></td>
                                        <td><%= vehiculo.getModelo() != null ? vehiculo.getModelo() : "" %></td>
                                        <td><%= vehiculo.getColor() != null ? vehiculo.getColor() : "" %></td>
                                        <td><%= vehiculo.getAnioFabricacion() > 0 ? vehiculo.getAnioFabricacion() : "" %></td>
                                        <td>
                                            <% String estadoSoat = vehiculo.getEstadoSoat();
                                               if ("VIGENTE".equals(estadoSoat)) { %>
                                                <span class="badge bg-success">Vigente</span>
                                            <% } else if ("VENCIDO".equals(estadoSoat)) { %>
                                                <span class="badge bg-danger">Vencido</span>
                                            <% } else { %>
                                                <span class="badge bg-secondary">N/A</span>
                                            <% } %>
                                        </td>
                                        <td><%= vehiculo.getVin() != null ? vehiculo.getVin() : "" %></td>
                                        <td class="text-center">
                                            <button class="btn btn-sm btn-outline-danger disabled" data-bs-toggle="tooltip" data-bs-title="Próximamente">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    <% } %>
                </div>
            </div>
        </div>
    </main>

    <footer class="py-4 text-center text-muted small mt-auto">
        &copy; <%= java.time.Year.now() %> Estación Resguarda.
    </footer>

    <div class="modal fade" id="modalNuevoVehiculo" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Agregar nuevo vehículo</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="ControladorCliente" method="POST">
                    <input type="hidden" name="accion" value="agregarVehiculo">
                    <div class="modal-body">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Placa (*)</label>
                                <input type="text" name="txtPlaca" class="form-control" placeholder="ABC-123" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">VIN (Opcional)</label>
                                <input type="text" name="txtVin" class="form-control" placeholder="Número de chasis">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Marca (*)</label>
                                <input type="text" name="txtMarca" class="form-control" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Modelo (*)</label>
                                <input type="text" name="txtModelo" class="form-control" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Color</label>
                                <input type="text" name="txtColor" class="form-control">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Año de fabricación</label>
                                <input type="number" name="txtAnio" class="form-control" placeholder="Ej: 2023" min="1900" max="2099">
                            </div>
                            <div class="col-12">
                                <label class="form-label">Estado del SOAT</label>
                                <select name="selectSoat" class="form-select">
                                    <option value="">No especificar</option>
                                    <option value="VIGENTE">Vigente</option>
                                    <option value="VENCIDO">Vencido</option>
                                </select>
                            </div>
                        </div>
                        <p class="text-muted small mt-3">(*) Campos obligatorios.</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-outline-primary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-primary">Guardar vehículo</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/app.js"></script>
</body>
</html>