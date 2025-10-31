<%-- 
    Document   : admin
    Created on : 22 oct. 2025, 8:19:24 a. m.
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
    <title>Acceso Personal - Estación Resguarda</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        body {
            background: linear-gradient(to right, #000428, #004e92);
            font-family: 'Segoe UI', sans-serif;
        }
        .login-card {
            background: rgba(255, 255, 255, 0.95);
            border: none;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        .login-card .card-body { padding: 2.5rem; }
        .login-card .form-control {
            border-radius: 10px;
            padding: 0.75rem 1rem;
            padding-left: 2.5rem;
        }
        .input-group-text {
            background-color: transparent; border: none; position: absolute;
            left: 10px; top: 50%; transform: translateY(-50%); z-index: 10; color: #6c757d;
        }
        .btn-primary {
            background-color: #004e92; border: none; border-radius: 10px;
            padding: 0.75rem; font-weight: bold;
        }
    </style>
</head>
<body>

    <div class="container-fluid d-flex align-items-center justify-content-center vh-100">
        <div class="card login-card" style="width: 25rem;">
            <div class="card-body">
                
                <div class="text-center mb-4">
                    <i class="bi bi-shield-lock-fill text-primary" style="font-size: 3rem;"></i>
                    <h3 class="mt-3 text-secondary">Acceso de Personal</h3>
                </div>

                <% if (error != null && !error.isEmpty()) { %>
                    <div class="alert alert-danger" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i> <%= error %>
                    </div>
                <% } %>

                <form method="POST" action="ControladorEmpleado">
                    <input type="hidden" name="accion" value="login">
                    
                    <div class="mb-3 position-relative">
                        <label for="usuario" class="form-label text-muted">Usuario</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-person-gear"></i></span>
                            <input type="text" class="form-control" id="usuario" name="txtUsuario" placeholder="Ingresa tu usuario (ej: admin)" required>
                        </div>
                    </div>

                    <div class="mb-4 position-relative">
                        <label for="password" class="form-label text-muted">Contraseña</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-lock"></i></span>
                            <input type="password" class="form-control" id="password" name="txtPassword" placeholder="Ingresa tu contraseña" required>
                        </div>
                    </div>

                    <div class="d-grid">
                        <button type="submit" class="btn btn-primary">Ingresar</button>
                    </div>
                </form>
                
                <div class="text-center mt-4">
                    <p class="text-muted">¿Eres cliente? <a href="login.jsp">Ingresa aquí</a></p>
                </div>

            </div>
        </div>
    </div>

</body>
</html>