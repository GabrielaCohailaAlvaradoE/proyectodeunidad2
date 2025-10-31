<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String error = (String) request.getAttribute("error");
    String exito = (String) request.getAttribute("exito");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Inicio de Sesión - Estación Resguarda</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Poppins:wght@500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="css/theme.css">
</head>
<body data-theme="dark" class="d-flex flex-column min-vh-100">
    <nav class="navbar navbar-expand-lg app-navbar fixed-top">
        <div class="container">
            <a class="navbar-brand" href="index.jsp">
                <span class="brand-accent">Resguarda</span> Parking
            </a>
            <div class="d-flex align-items-center gap-2">
                <a class="nav-link" href="index.jsp">
                    <i class="bi bi-arrow-left-short me-1"></i>Inicio
                </a>
                <button class="btn btn-sm btn-outline-accent btn-theme-toggle" type="button" data-action="toggle-theme" aria-label="Cambiar tema">
                    <i class="bi bi-sun-fill" data-theme-icon></i>
                    <span class="ms-2" data-theme-label>Modo Claro</span>
                </button>
            </div>
        </div>
    </nav>

    <main class="flex-grow-1 d-flex align-items-center py-5">
        <div class="container py-5 position-relative">
            <div class="blur-lights d-none d-lg-block"></div>
            <div class="row align-items-center g-5">
                <div class="col-lg-6" data-animate>
                    <span class="hero-badge"><i class="bi bi-person-hearts"></i> Área Clientes</span>
                    <h1 class="hero-title mt-4">Tu espacio luminoso para gestionar estacionamientos</h1>
                    <p class="hero-subtitle">Accede a un panel renovado con tarjetas brillantes, efectos flotantes y la seguridad que siempre nos caracteriza.</p>
                    <div class="d-flex flex-wrap gap-2 mt-4">
                        <span class="feature-pill"><i class="bi bi-car-front"></i>Control de vehículos</span>
                        <span class="feature-pill"><i class="bi bi-clock-history"></i>Historial inmediato</span>
                        <span class="feature-pill"><i class="bi bi-lightning"></i>Respuesta ágil</span>
                    </div>
                </div>
                <div class="col-lg-5 offset-lg-1 col-md-8" data-animate>
                    <div class="floating-bubbles">
                        <div class="app-card p-4 p-lg-5">
                            <div class="text-center mb-4">
                                <img src="images/Logo.png" alt="Logo Estacionamientos Resguarda" class="img-fluid" style="max-width: 180px;">
                                <h2 class="mt-3 fw-bold text-uppercase">Bienvenido</h2>
                                <p class="text-muted mb-0">Ingresa tus credenciales para continuar</p>
                            </div>

                        <% if (error != null && !error.isEmpty()) { %>
                            <div class="alert alert-danger" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i> <%= error %>
                            </div>
                        <% } %>

                        <% if (exito != null && !exito.isEmpty()) { %>
                            <div class="alert alert-success" role="alert">
                                <i class="bi bi-check-circle-fill me-2"></i> <%= exito %>
                            </div>
                        <% } %>

                        <form method="POST" action="ControladorCliente" class="mt-4">
                            <input type="hidden" name="accion" value="login">
                            <div class="mb-3">
                                <label for="dni" class="form-label">DNI</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-person"></i></span>
                                    <input type="text" class="form-control" id="dni" name="txtDni" placeholder="Ingresa tu DNI" required pattern="[0-9]{8}" title="El DNI debe tener 8 dígitos">
                                </div>
                            </div>

                            <div class="mb-4">
                                <label for="password" class="form-label">Contraseña</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-lock"></i></span>
                                    <input type="password" class="form-control" id="password" name="txtPassword" placeholder="Ingresa tu contraseña" required>
                                </div>
                            </div>

                            <div class="d-grid">
                                <button type="submit" class="btn btn-primary btn-lg">
                                    <i class="bi bi-box-arrow-in-right me-2"></i>Ingresar
                                </button>
                            </div>
                        </form>

                            <div class="text-center mt-4">
                                <p class="text-muted mb-1">¿No tienes una cuenta?</p>
                                <a href="registro.jsp" class="btn btn-outline-primary btn-sm">Crear cuenta</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <footer class="py-4 text-center text-muted small">
        &copy; <%= java.time.Year.now() %> Estación Resguarda. Todos los derechos reservados.
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/app.js"></script>
</body>
</html>