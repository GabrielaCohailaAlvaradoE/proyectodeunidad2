<%-- 
    Document   : misVehiculos
    Created on : 28 oct. 2025, 8:20:15 a. m.
    Author     : ASUS
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="modelo.Cliente" %>
<%@ page import="modelo.Vehiculo" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>

<%-- Bloque de Seguridad: Cliente debe estar logueado --%>
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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Vehículos - Estación Resguarda</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .navbar { box-shadow: 0 2px 4px rgba(0,0,0,.1); }
        .navbar-brand { color: #004e92 !important; font-weight: 700; }
        .card { border: none; border-radius: 15px; box-shadow: 0 4px 15px rgba(0,0,0,.08); }
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
                <a href="ControladorCliente?accion=verMisVehiculos" class="btn btn-sm btn-outline-primary me-2 active">Mis Vehículos</a>
                <a href="#" class="btn btn-sm btn-outline-secondary me-2 disabled">Mi Historial</a>
                <a href="ControladorCliente?accion=logout" class="btn btn-outline-danger btn-sm">
                    <i class="bi bi-box-arrow-right me-1"></i> Cerrar Sesión
                </a>
            </div>
        </div>
    </nav>

    <div class="container mt-5">

        <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
            <h1 class="h2">Mis Vehículos Registrados</h1>
            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalNuevoVehiculo">
                <i class="bi bi-plus-circle me-1"></i> Agregar Vehículo
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

        <div class="card">
            <div class="card-body">
                <% if (listaVehiculos == null || listaVehiculos.isEmpty()) { %>
                    <p class="text-center text-muted">Aún no tienes vehículos registrados.</p>
                <% } else { %>
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>Placa</th>
                                <th>Marca</th>
                                <th>Modelo</th>
                                <th>Color</th>
                                <th>Año</th>
                                <th>SOAT</th>
                                <th>VIN</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Vehiculo vehiculo : listaVehiculos) { %>
                                <tr>
                                    <td><strong><%= vehiculo.getPlaca() %></strong></td>
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
                                    <td>
                                        <button class="btn btn-sm btn-outline-danger disabled" title="Eliminar (No implementado)">
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

    <div class="modal fade" id="modalNuevoVehiculo" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Agregar Nuevo Vehículo</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="ControladorCliente" method="POST">
                    <input type="hidden" name="accion" value="agregarVehiculo">
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Placa (*)</label>
                                <input type="text" name="txtPlaca" class="form-control" placeholder="ABC-123" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">VIN (Número de Chasis)</label>
                                <input type="text" name="txtVin" class="form-control" placeholder="Opcional">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Marca (*)</label>
                                <input type="text" name="txtMarca" class="form-control" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Modelo (*)</label>
                                <input type="text" name="txtModelo" class="form-control" required>
                            </div>
                        </div>
                         <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Color</label>
                                <input type="text" name="txtColor" class="form-control">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Año de Fabricación</label>
                                <input type="number" name="txtAnio" class="form-control" placeholder="Ej: 2023" min="1900" max="2099">
                            </div>
                        </div>
                        <div class="mb-3">
                             <label class="form-label">Estado del SOAT</label>
                             <select name="selectSoat" class="form-select">
                                 <option value="">No especificar</option>
                                 <option value="VIGENTE">Vigente</option>
                                 <option value="VENCIDO">Vencido</option>
                             </select>
                         </div>
                         <p class="text-muted small">(*) Campos obligatorios.</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-primary">Guardar Vehículo</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>