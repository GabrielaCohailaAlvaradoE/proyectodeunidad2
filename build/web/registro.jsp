<%-- 
    Document   : registro
    Created on : 30 set. 2025, 10:39:57 a. m.
    Author     : ASUS
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crear Cuenta - Estación Resguarda</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <style>
        body {
            background: linear-gradient(to right, #000428, #004e92);
            font-family: 'Segoe UI', sans-serif;
            padding: 2rem 0;
        }
        .register-card {
            background: rgba(255, 255, 255, 0.95);
            border: none;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            backdrop-filter: blur(10px);
        }
        .register-card .card-body { padding: 2.5rem; }
        .register-card .form-control {
            border-radius: 10px;
            padding: 0.75rem 1rem;
            padding-left: 2.5rem;
            border: 1px solid #ced4da;
        }
        .input-group-text {
            background-color: transparent; border: none; position: absolute;
            left: 10px; top: 50%; transform: translateY(-50%); z-index: 10; color: #6c757d;
        }
        .btn-primary {
            background-color: #004e92; border: none; border-radius: 10px;
            padding: 0.75rem; font-weight: bold; transition: background-color 0.3s;
        }
        .btn-primary:hover { background-color: #003a6e; }
        .spinner-border-sm { display: none; }
    </style>
</head>
<body>

    <div class="container d-flex align-items-center justify-content-center">
        <div class="card register-card my-5" style="width: 32rem;">
            <div class="card-body">
                
                <div class="text-center mb-4">
                    <h3 class="text-secondary">Crea tu Cuenta</h3>
                    <p class="text-muted">Completa tus datos para empezar.</p>
                </div>

                <% if (error != null && !error.isEmpty()) { %>
                    <div class="alert alert-danger" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i> <%= error %>
                    </div>
                <% } %>

                <form id="registroForm" method="POST" action="ControladorCliente">
                    <input type="hidden" name="accion" value="registrar">
                    
                    <div class="mb-3 position-relative">
                        <label for="dni" class="form-label text-muted">DNI</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-person-badge"></i></span>
                            <input type="text" class="form-control" id="dni" name="txtDni" placeholder="Tu DNI de 8 dígitos" required pattern="[0-9]{8}" maxlength="8" title="El DNI debe tener 8 dígitos">
                            <span class="spinner-border spinner-border-sm position-absolute" style="right: 10px; top: 35px;" role="status" id="dniSpinner"></span>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3 position-relative">
                            <label for="nombres" class="form-label text-muted">Nombres</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-person-text"></i></span>
                                <input type="text" class="form-control" id="nombres" name="txtNombres" placeholder="Tus nombres" required>
                            </div>
                        </div>
                        <div class="col-md-6 mb-3 position-relative">
                            <label for="apellidos" class="form-label text-muted">Apellidos</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-person-text"></i></span>
                                <input type="text" class="form-control" id="apellidos" name="txtApellidos" placeholder="Tus apellidos" required>
                            </div>
                        </div>
                    </div>

                    <div class="mb-3 position-relative">
                        <label for="email" class="form-label text-muted">Correo Electrónico</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                            <input type="email" class="form-control" id="email" name="txtEmail" placeholder="ejemplo@correo.com" required>
                        </div>
                    </div>

                    <div class="mb-3 position-relative">
                        <label for="password" class="form-label text-muted">Contraseña</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-lock"></i></span>
                            <input type="password" class="form-control" id="password" name="txtPassword" placeholder="Crea una contraseña segura" required>
                        </div>
                    </div>

                    <div class="mb-4 position-relative">
                        <label for="fechaNacimiento" class="form-label text-muted">Fecha de Nacimiento</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-calendar-event"></i></span>
                            <input type="date" class="form-control" id="fechaNacimiento" name="txtFechaNacimiento" required>
                        </div>
                    </div>

                    <div class="d-grid">
                        <button type="submit" class="btn btn-primary">Crear Cuenta</button>
                    </div>
                </form>

                <div class="text-center mt-4">
                    <p class="text-muted">¿Ya tienes una cuenta? <a href="login.jsp">Inicia Sesión</a></p>
                </div>
            </div>
        </div>
    </div>

    <script>
        const dniInput = document.getElementById('dni');
        const nombresInput = document.getElementById('nombres');
        const apellidosInput = document.getElementById('apellidos');
        const spinner = document.getElementById('dniSpinner');

        dniInput.addEventListener('input', function() {
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
                            nombresInput.value = data.nombres;
                            apellidosInput.value = data.apellidos;
                            nombresInput.readOnly = true;
                            apellidosInput.readOnly = true;
                        } else {
                            console.error('Error desde la API:', data.error);
                            nombresInput.value = '';
                            apellidosInput.value = '';
                            nombresInput.readOnly = false;
                            apellidosInput.readOnly = false;
                        }
                    })
                    .catch(error => {
                        console.error('Error en la llamada fetch:', error);
                    })
                    .finally(() => {
                        spinner.style.display = 'none';
                    });
            } else {
                 nombresInput.value = '';
                 apellidosInput.value = '';
                 nombresInput.readOnly = false;
                 apellidosInput.readOnly = false;
            }
        });
    </script>
</body>
</html>