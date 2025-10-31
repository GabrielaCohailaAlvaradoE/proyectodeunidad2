<%-- 
    Document   : login
    Created on : 30 set. 2025, 10:31:05 a. m.
    Author     : ASUS
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String error = (String) request.getAttribute("error");
    String exito = (String) request.getAttribute("exito");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inicio de Sesión - Estación Resguarda</title>
    
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
            backdrop-filter: blur(10px);
        }
        .login-card .card-body {
            padding: 2.5rem;
        }
        .login-card .form-control {
            border-radius: 10px;
            padding: 0.75rem 1rem;
            padding-left: 2.5rem;
            border: 1px solid #ced4da;
        }
        .input-group-text {
            background-color: transparent;
            border: none;
            position: absolute;
            left: 10px;
            top: 50%;
            transform: translateY(-50%);
            z-index: 10;
            color: #6c757d;
        }
        .btn-primary {
            background-color: #004e92;
            border: none;
            border-radius: 10px;
            padding: 0.75rem;
            font-weight: bold;
            transition: background-color 0.3s;
        }
        .btn-primary:hover {
            background-color: #003a6e;
        }
    </style>
</head>
<body>

    <div class="container-fluid d-flex align-items-center justify-content-center vh-100">
        <div class="card login-card" style="width: 25rem;">
            <div class="card-body">
                
                <div class="text-center mb-4">
                    <img src="images/Logo.png"
                         alt="Logo Estacionamientos Resguarda"
                         width="200"
                         height="auto">
                    <h3 class="mt-3 text-secondary">Bienvenido</h3>
                </div>

                <%-- Mostrar alerta de error si existe --%>
                <% if (error != null && !error.isEmpty()) { %>
                    <div class="alert alert-danger" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i> <%= error %>
                    </div>
                <% } %>

                <%-- Mostrar alerta de éxito si existe --%>
                <% if (exito != null && !exito.isEmpty()) { %>
                    <div class="alert alert-success" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i> <%= exito %>
                    </div>
                <% } %>

                <form method="POST" action="ControladorCliente">
                    <input type="hidden" name="accion" value="login">
                    
                    <div class="mb-3 position-relative">
                        <label for="dni" class="form-label text-muted">DNI</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-person"></i></span>
                            <input type="text" class="form-control" id="dni" name="txtDni" placeholder="Ingresa tu DNI" required pattern="[0-9]{8}" title="El DNI debe tener 8 dígitos">
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
                    <p class="text-muted">¿No tienes una cuenta? <a href="registro.jsp">Regístrate aquí</a></p>
                </div>

            </div>
        </div>
    </div>

</body>
</html>