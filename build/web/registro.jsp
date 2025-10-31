<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Crear Cuenta - Estación Resguarda</title>
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
                <span class="brand-accent">Resguarda</span> Registro
            </a>
            <div class="d-flex align-items-center gap-2">
                <a class="nav-link" href="login.jsp">Iniciar sesión</a>
                <button class="btn btn-sm btn-outline-accent btn-theme-toggle" type="button" data-action="toggle-theme" aria-label="Cambiar tema">
                    <i class="bi bi-sun-fill" data-theme-icon></i>
                    <span class="ms-2" data-theme-label>Modo Claro</span>
                </button>
            </div>
        </div>
    </nav>

    <main class="flex-grow-1 d-flex align-items-center justify-content-center py-5">
        <div class="container py-5">
            <div class="row justify-content-center">
                <div class="col-lg-6 col-xl-5" data-animate>
                    <div class="app-card p-4 p-lg-5">
                        <div class="text-center mb-4">
                            <div class="icon-wrapper mx-auto">
                                <i class="bi bi-pencil-square"></i>
                            </div>
                            <h2 class="fw-bold mt-3">Crea tu cuenta</h2>
                            <p class="text-muted mb-0">Completa tus datos y empieza a disfrutar de Resguarda.</p>
                        </div>

                        <% if (error != null && !error.isEmpty()) { %>
                            <div class="alert alert-danger" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i> <%= error %>
                            </div>
                        <% } %>

                        <form id="registroForm" method="POST" action="ControladorCliente" class="mt-4">
                            <input type="hidden" name="accion" value="registrar">
                            <div class="mb-3">
                                <label for="dni" class="form-label">DNI</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-person-badge"></i></span>
                                    <input type="text" class="form-control" id="dni" name="txtDni" placeholder="Tu DNI de 8 dígitos" required pattern="[0-9]{8}" maxlength="8" title="El DNI debe tener 8 dígitos">
                                    <span class="spinner-border spinner-border-sm ms-2" role="status" aria-hidden="true" id="dniSpinner" style="display:none;"></span>
                                </div>
                            </div>

                            <div class="row g-3">
                                <div class="col-sm-6">
                                    <label for="nombres" class="form-label">Nombres</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="bi bi-person"></i></span>
                                        <input type="text" class="form-control" id="nombres" name="txtNombres" placeholder="Tus nombres" required>
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <label for="apellidos" class="form-label">Apellidos</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="bi bi-person"></i></span>
                                        <input type="text" class="form-control" id="apellidos" name="txtApellidos" placeholder="Tus apellidos" required>
                                    </div>
                                </div>
                            </div>

                            <div class="mt-3">
                                <label for="email" class="form-label">Correo electrónico</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                                    <input type="email" class="form-control" id="email" name="txtEmail" placeholder="ejemplo@correo.com" required>
                                </div>
                            </div>

                            <div class="mt-3">
                                <label for="password" class="form-label">Contraseña</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-lock"></i></span>
                                    <input type="password" class="form-control" id="password" name="txtPassword" placeholder="Crea una contraseña segura" required>
                                </div>
                            </div>

                            <div class="mt-3">
                                <label for="fechaNacimiento" class="form-label">Fecha de nacimiento</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-calendar-event"></i></span>
                                    <input type="date" class="form-control" id="fechaNacimiento" name="txtFechaNacimiento" required>
                                </div>
                            </div>

                            <div class="d-grid mt-4">
                                <button type="submit" class="btn btn-primary btn-lg">Crear cuenta</button>
                            </div>
                        </form>

                        <div class="text-center mt-4">
                            <p class="text-muted mb-1">¿Ya tienes una cuenta?</p>
                            <a href="login.jsp" class="btn btn-outline-primary btn-sm">Iniciar sesión</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <footer class="py-4 text-center text-muted small">
        &copy; <%= java.time.Year.now() %> Estación Resguarda.
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/app.js"></script>
    <script>
        const dniInput = document.getElementById('dni');
        const nombresInput = document.getElementById('nombres');
        const apellidosInput = document.getElementById('apellidos');
        const spinner = document.getElementById('dniSpinner');

        dniInput.addEventListener('input', function () {
            if (this.value.length === 8) {
                spinner.style.display = 'inline-block';
                fetch('ControladorCliente?accion=consultarDni&dni=' + this.value)
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('Error en la respuesta del servidor');
                        }
                        return response.json();
                    })
                    .then(data => {
                        if (data && !data.error) {
                            nombresInput.value = data.nombres || '';
                            apellidosInput.value = data.apellidos || '';
                            nombresInput.readOnly = true;
                            apellidosInput.readOnly = true;
                        } else {
                            nombresInput.value = '';
                            apellidosInput.value = '';
                            nombresInput.readOnly = false;
                            apellidosInput.readOnly = false;
                        }
                    })
                    .catch(() => {
                        nombresInput.value = '';
                        apellidosInput.value = '';
                        nombresInput.readOnly = false;
                        apellidosInput.readOnly = false;
                    })
                    .finally(() => {
                        spinner.style.display = 'none';
                    });
            } else {
                spinner.style.display = 'none';
                nombresInput.value = '';
                apellidosInput.value = '';
                nombresInput.readOnly = false;
                apellidosInput.readOnly = false;
            }
        });
    </script>
</body>
</html>