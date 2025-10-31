<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Acceso Personal - Estación Resguarda</title>
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
                <span class="brand-accent">Resguarda</span> Staff
            </a>
            <div class="d-flex align-items-center gap-2">
                <a class="nav-link" href="index.jsp">
                    <i class="bi bi-arrow-left-short me-1"></i>Inicio
                </a>
                <a class="nav-link" href="login.jsp">Área Clientes</a>
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
                    <span class="hero-badge"><i class="bi bi-shield-shaded"></i> Personal Autorizado</span>
                    <h1 class="hero-title mt-4">Control absoluto para la mejor empresa</h1>
                    <p class="hero-subtitle">Supervisa sedes, pisos y colaboradores dentro de una interfaz poderosa con degradados profundos y destellos eléctricos.</p>
                    <div class="d-flex flex-wrap gap-2 mt-4">
                        <span class="feature-pill"><i class="bi bi-diagram-3"></i>Gestión de sedes</span>
                        <span class="feature-pill"><i class="bi bi-people"></i>Roles y permisos</span>
                        <span class="feature-pill"><i class="bi bi-speedometer"></i>Monitoreo en vivo</span>
                    </div>
                </div>
                <div class="col-lg-5 offset-lg-1 col-md-8" data-animate>
                    <div class="floating-bubbles">
                        <div class="app-card p-4 p-lg-5">
                            <div class="text-center mb-4">
                                <div class="icon-wrapper mx-auto">
                                    <i class="bi bi-shield-lock-fill"></i>
                                </div>
                                <h2 class="mt-3 fw-bold text-uppercase">Acceso del Personal</h2>
                            <p class="text-muted">Ingresa tus credenciales para administrar la plataforma</p>
                        </div>

                        <% if (error != null && !error.isEmpty()) { %>
                            <div class="alert alert-danger" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i> <%= error %>
                            </div>
                        <% } %>

                        <form method="POST" action="ControladorEmpleado" class="mt-4">
                            <input type="hidden" name="accion" value="login">
                            <div class="mb-3">
                                <label for="usuario" class="form-label">Usuario</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-person-gear"></i></span>
                                    <input type="text" class="form-control" id="usuario" name="txtUsuario" placeholder="Ingresa tu usuario" required>
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
                                    <i class="bi bi-door-open-fill me-2"></i>Ingresar
                                </button>
                            </div>
                        </form>

                            <div class="text-center mt-4">
                                <p class="text-muted">¿Eres cliente? <a href="login.jsp" class="btn-accent-text">Ingresa aquí</a></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <footer class="py-4 text-center text-muted small">
        &copy; <%= java.time.Year.now() %> Estación Resguarda. Gestión inteligente de estacionamientos.
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/app.js"></script>
</body>
</html>