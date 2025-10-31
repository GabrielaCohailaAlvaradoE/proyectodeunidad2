<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="modelo.Cliente" %>
<%@ page import="modelo.HistorialEntry" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.Date" %>
<%
    Cliente clienteLogueado = (Cliente) session.getAttribute("clienteLogueado");
    if (clienteLogueado == null) {
        response.sendRedirect("login.jsp?error=Sesión expirada");
        return;
    }

    List<HistorialEntry> listaHistorial = (List<HistorialEntry>) request.getAttribute("listaHistorial");
    if (listaHistorial == null) {
        listaHistorial = new ArrayList<>();
    }

    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("es", "PE"));
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Historial de Estacionamiento - Estación Resguarda</title>
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
                    <li class="nav-item"><a class="nav-link" href="ControladorCliente?accion=verMisVehiculos">Mis Vehículos</a></li>
                    <li class="nav-item"><a class="nav-link active" href="ControladorCliente?accion=verHistorial">Historial</a></li>
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
            <div class="mb-4" data-animate>
                <h1 class="section-title">Historial de estacionamientos</h1>
                <p class="section-subtitle">Consulta los ingresos y salidas de tus vehículos, además de los montos pagados.</p>
            </div>

            <div class="app-card p-0" data-animate>
                <% if (listaHistorial.isEmpty()) { %>
                    <div class="p-5 text-center text-muted">No tienes registros de estacionamiento finalizados.</div>
                <% } else { %>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0 table-dark-mode">
                            <thead>
                                <tr>
                                    <th># Registro</th>
                                    <th>Vehículo</th>
                                    <th>Placa</th>
                                    <th>Hora Entrada</th>
                                    <th>Hora Salida</th>
                                    <th>Monto Pagado</th>
                                    <th>Fecha Pago</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (HistorialEntry entry : listaHistorial) { %>
                                    <tr>
                                        <td><%= entry.getIdRegistro() %></td>
                                        <td><%= entry.getMarcaModeloVehiculo() != null ? entry.getMarcaModeloVehiculo() : "N/A" %></td>
                                        <td class="fw-semibold text-white"><%= entry.getPlacaVehiculo() %></td>
                                        <td><%= entry.getHoraEntrada() != null ? dateFormat.format(entry.getHoraEntrada()) : "N/A" %></td>
                                        <td><%= entry.getHoraSalida() != null ? dateFormat.format(entry.getHoraSalida()) : "N/A" %></td>
                                        <td><%= currencyFormatter.format(entry.getMontoPagado()).replace("PEN", "S/") %></td>
                                        <td><%= entry.getFechaPago() != null ? dateFormat.format(entry.getFechaPago()) : "N/A" %></td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>
            </div>
        </div>
    </main>

    <footer class="py-4 text-center text-muted small mt-auto">
        &copy; <%= java.time.Year.now() %> Estación Resguarda.
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/app.js"></script>
</body>
</html>