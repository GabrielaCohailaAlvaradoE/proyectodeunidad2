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
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Panel de Cliente - Estación Resguarda</title>
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
            <button class="navbar-toggler text-strong border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarCliente" aria-controls="navbarCliente" aria-expanded="false" aria-label="Alternar navegación">
            <i class="bi bi-list fs-3"></i>
            </button>
            <div class="collapse navbar-collapse justify-content-end" id="navbarCliente">
                <ul class="navbar-nav align-items-lg-center me-lg-3">
                    <li class="nav-item"><span class="nav-link">Hola, <strong class="text-strong"> <%= clienteLogueado.getNombres()%></strong></span></li>
                    <li class="nav-item"><a class="nav-link active" href="ControladorCliente?accion=verPanel">Panel</a></li>
                    <li class="nav-item"><a class="nav-link" href="ControladorCliente?accion=verMisVehiculos">Mis Vehículos</a></li>
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
            <div class="row align-items-center mb-5" data-animate>
                <div class="col-lg-8">
                    <h1 class="section-title">Bienvenido, <%= clienteLogueado.getNombres() %></h1>
                    <p class="section-subtitle">Gestiona tus vehículos, consulta tu historial y mantén el control de tus ingresos y salidas en Resguarda.</p>
                </div>
                <div class="col-lg-4 text-lg-end mt-4 mt-lg-0">
                    <a href="#" class="btn btn-outline-accent btn-lg disabled" data-bs-toggle="tooltip" data-bs-title="Disponible próximamente">
                        <i class="bi bi-qr-code me-2"></i> Ver QR/PIN de salida
                    </a>
                </div>
            </div>

            <div class="row g-4">
                <div class="col-md-6 col-xl-4" data-animate>
                    <div class="app-card h-100 p-4">
                        <div class="d-flex align-items-center justify-content-between mb-3">
                            <span class="text-uppercase small text-muted">Gestión</span>
                            <i class="bi bi-car-front-fill fs-3 text-accent"></i>
                        </div>
                        <h4 class="fw-bold text-strong">Mis Vehículos</h4>
                        <p class="text-muted">Consulta y administra los vehículos asociados a tu cuenta.</p>
                        <a href="ControladorCliente?accion=verMisVehiculos" class="btn btn-primary mt-3">
                            Gestionar vehículos
                        </a>
                    </div>
                </div>

                <div class="col-md-6 col-xl-4" data-animate>
                    <div class="app-card h-100 p-4">
                        <div class="d-flex align-items-center justify-content-between mb-3">
                            <span class="text-uppercase small text-muted">Pagos</span>
                            <i class="bi bi-receipt fs-3 text-accent"></i>
                        </div>
                        <h4 class="fw-bold text-strong">Historial de pagos</h4>
                        <p class="text-muted">Revisa tus pagos y detalles de estacionamientos anteriores.</p>
                        <a href="ControladorCliente?accion=verHistorial" class="btn btn-outline-primary mt-3">
                            Ver historial
                        </a>
                    </div>
                </div>

                <div class="col-md-6 col-xl-4" data-animate>
                    <div class="app-card h-100 p-4">
                        <div class="d-flex align-items-center justify-content-between mb-3">
                            <span class="text-uppercase small text-muted">Cuenta</span>
                            <i class="bi bi-person-circle fs-3 text-accent"></i>
                        </div>
                        <h4 class="fw-bold text-strong">Mi perfil</h4>
                        <p class="text-muted mb-4">Mantén tus datos actualizados y controla tus preferencias.</p>
                        <ul class="list-unstyled text-muted mb-4">
                            <li class="d-flex align-items-center gap-2"><i class="bi bi-envelope-open"></i><span><%= clienteLogueado.getEmail() %></span></li>
                            <li class="d-flex align-items-center gap-2"><i class="bi bi-person"></i><span><%= clienteLogueado.getApellidos() %></span></li>
                        </ul>
                        <div class="d-flex gap-2 flex-wrap">
                            <a href="#" class="btn btn-outline-primary disabled" data-bs-toggle="tooltip" data-bs-title="Próximamente">Actualizar contraseña</a>
                            <a href="#" class="btn btn-outline-primary disabled" data-bs-toggle="tooltip" data-bs-title="Próximamente">Editar correo</a>
                        </div>
                    </div>
                </div>
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