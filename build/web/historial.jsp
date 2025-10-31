<%-- 
    Document   : historial
    Created on : 28 oct. 2025, 8:59:40 a. m.
    Author     : ASUS
--%>

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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historial de Estacionamiento - Estación Resguarda</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .navbar { box-shadow: 0 2px 4px rgba(0,0,0,.1); }
        .navbar-brand { color: #004e92 !important; font-weight: 700; }
        .card { border: none; border-radius: 15px; box-shadow: 0 4px 15px rgba(0,0,0,.08); }
        .table th { background-color: #e9ecef; }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-light bg-white sticky-top">
        <div class="container-fluid">
            <a class="navbar-brand" href="ControladorCliente?accion=verPanel">
                <i class="bi bi-shield-lock-fill"></i> Estación Resguarda
            </a>
            <div class="d-flex align-items-center">
                <span class="navbar-text me-3">
                    Hola, <strong class="text-dark"><%= clienteLogueado.getNombres() %></strong>
                </span>
                <a href="ControladorCliente?accion=verMisVehiculos" class="btn btn-sm btn-outline-primary me-2">Mis Vehículos</a>
                <a href="ControladorCliente?accion=verHistorial" class="btn btn-sm btn-outline-secondary me-2 active">Mi Historial</a>
                <a href="ControladorCliente?accion=logout" class="btn btn-outline-danger btn-sm">
                    <i class="bi bi-box-arrow-right me-1"></i> Cerrar Sesión
                </a>
            </div>
        </div>
    </nav>

    <div class="container mt-5">

        <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
            <h1 class="h2">Historial de Estacionamientos</h1>
        </div>

        <div class="card">
            <div class="card-body">
                <% if (listaHistorial.isEmpty()) { %>
                    <p class="text-center text-muted">No tienes registros de estacionamiento finalizados.</p>
                <% } else { %>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
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
                                        <td><strong><%= entry.getPlacaVehiculo() %></strong></td>
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
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
