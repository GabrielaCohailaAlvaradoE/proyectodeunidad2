<%-- 
    Document   : panel
    Created on : 30 set. 2025, 10:51:07 a. m.
    Author     : ASUS
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="modelo.Cliente" %>

<%
    Cliente clienteLogueado = (Cliente) session.getAttribute("clienteLogueado");

    if (clienteLogueado == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Cliente - Estación Resguarda</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <style>
        body {
            background-color: #f8f9fa;
        }
        .navbar {
            box-shadow: 0 2px 4px rgba(0,0,0,.1);
        }
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,.08);
            transition: transform 0.2s;
        }
        .card:hover {
            transform: translateY(-5px);
        }
        .card-header {
            background-color: #004e92;
            color: white;
            font-weight: bold;
            border-top-left-radius: 15px;
            border-top-right-radius: 15px;
        }
        .navbar-brand {
             color: #004e92 !important;
             font-weight: 700;
        }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-light bg-white sticky-top">
        <div class="container-fluid">
            <a class="navbar-brand fw-bold text-primary" href="ControladorCliente?accion=verPanel">
                <i class="bi bi-shield-lock-fill"></i>
                Estación Resguarda
            </a>
            <div class="d-flex align-items-center">
                <span class="navbar-text me-3">
                    Hola, <strong class="text-dark"><%= clienteLogueado.getNombres() %></strong>
                </span>
                 <a href="ControladorCliente?accion=verMisVehiculos" class="btn btn-sm btn-outline-primary me-2">Mis Vehículos</a>
                 <a href="#" class="btn btn-sm btn-outline-secondary me-2 disabled">Mi Historial</a>
                <a href="ControladorCliente?accion=logout" class="btn btn-outline-danger btn-sm">
                    <i class="bi bi-box-arrow-right me-1"></i> Cerrar Sesión
                </a>
            </div>
        </div>
    </nav>

    <div class="container mt-5">
        
        <div class="row mb-4">
            <div class="col-lg-8">
                <h3>Panel de Control</h3>
                <p class="text-muted">Gestiona tus vehículos e historial de estacionamiento.</p>
            </div>
            <div class="col-lg-4 text-lg-end">
                <a href="#" class="btn btn-primary disabled">
                    <i class="bi bi-qr-code me-1"></i> Ver QR/PIN de Salida (Próximamente)
                </a>
            </div>
        </div>

        <div class="row g-4">
            
            <div class="col-md-6 col-lg-4">
                <div class="card h-100">
                    <div class="card-header"><i class="bi bi-car-front-fill me-2"></i> Mis Vehículos</div>
                    <div class="card-body">
                        <%-- Aquí podrías añadir lógica para mostrar el último vehículo o estado --%>
                        <p class="card-text text-muted">Consulta y administra los vehículos asociados a tu cuenta.</p>
                        <hr>
                        <a href="ControladorCliente?accion=verMisVehiculos" class="btn btn-secondary btn-sm">Gestionar Vehículos</a>
                    </div>
                </div>
            </div>

            <div class="col-md-6 col-lg-4">
                <div class="card h-100">
                    <div class="card-header"><i class="bi bi-receipt me-2"></i> Historial de Pagos</div>
                    <div class="card-body">
                         <%-- Aquí podrías añadir lógica para mostrar el último pago --%>
                        <p class="card-text text-muted">Revisa tus pagos y detalles de estacionamientos anteriores.</p>
                        <hr>
                        <a href="#" class="btn btn-secondary btn-sm disabled">Ver Historial (Próximamente)</a>
                    </div>
                </div>
            </div>

            <div class="col-md-6 col-lg-4">
                <div class="card h-100">
                    <div class="card-header"><i class="bi bi-person-circle me-2"></i> Mi Cuenta</div>
                    <div class="card-body">
                        <h5 class="card-title"><%= clienteLogueado.getNombres() %> <%= clienteLogueado.getApellidos() %></h5>
                        <p class="card-text text-muted"><%= clienteLogueado.getEmail() %></p>
                        <hr>
                        <a href="#" class="btn btn-secondary btn-sm me-2 disabled">Cambiar Contraseña</a>
                        <a href="#" class="btn btn-secondary btn-sm disabled">Editar Correo</a>
                    </div>
                </div>
            </div>

        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>