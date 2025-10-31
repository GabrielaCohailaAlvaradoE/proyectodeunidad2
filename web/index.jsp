<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Estación Resguarda - Control Inteligente</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Poppins:wght@500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="css/theme.css">
</head>
<body data-theme="dark" class="min-vh-100 d-flex flex-column">
    <nav class="navbar navbar-expand-lg app-navbar fixed-top">
        <div class="container">
            <a class="navbar-brand" href="#">
                <span class="brand-accent">Resguarda</span> Station
            </a>
            <button class="navbar-toggler text-strong" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent" aria-controls="navbarContent" aria-expanded="false" aria-label="Toggle navigation">                <i class="bi bi-list"></i>
            </button>
            <div class="collapse navbar-collapse justify-content-end" id="navbarContent">
                <ul class="navbar-nav align-items-lg-center me-lg-3">
                    <li class="nav-item"><a class="nav-link" href="login.jsp">Clientes</a></li>
                    <li class="nav-item"><a class="nav-link" href="admin.jsp">Personal</a></li>
                    <li class="nav-item"><a class="nav-link" href="registro.jsp">Registro</a></li>
                </ul>
                <button class="btn btn-sm btn-outline-accent btn-theme-toggle" type="button" data-action="toggle-theme" aria-label="Cambiar tema">
                    <i class="bi bi-sun-fill" data-theme-icon></i>
                    <span class="ms-2" data-theme-label>Modo Claro</span>
                </button>
            </div>
        </div>
    </nav>

    <main class="flex-grow-1 d-flex align-items-center">
        <div class="container py-5">
            <section class="hero-section" data-animate>
                <p class="text-uppercase fw-semibold small text-muted letter-spacing">Gestión integral de estacionamientos</p>
                <h1 class="hero-title">Elige cómo deseas ingresar</h1>
                <p class="hero-subtitle">Accede como cliente para controlar tus vehículos o como personal autorizado para administrar sedes, pisos y operaciones diarias.</p>
            </section>

            <div class="row g-4 align-items-stretch">
                <div class="col-lg-6" data-animate>
                    <div class="option-card h-100">
                        <div class="icon-wrapper">
                            <i class="bi bi-person-bounding-box"></i>
                        </div>
                        <h3 class="fw-bold mb-3">Ingresar como Usuario</h3>
                        <p class="mb-4">Gestiona tus vehículos, consulta tu historial y administra tus reservas desde un panel intuitivo.</p>
                        <div class="d-flex gap-3 flex-wrap">
                            <a href="login.jsp" class="btn btn-primary btn-lg">
                                <i class="bi bi-box-arrow-in-right me-2"></i>Ir al login de clientes
                            </a>
                            <div class="d-flex align-items-center text-muted small gap-2">
                                <i class="bi bi-shield-check"></i>
                                <span>Acceso seguro con DNI y contraseña</span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-6" data-animate>
                    <div class="option-card h-100">
                        <div class="icon-wrapper">
                            <i class="bi bi-diagram-3"></i>
                        </div>
                        <h3 class="fw-bold mb-3">Ingresar como Administrador</h3>
                        <p class="mb-4">Controla sedes, supervisa personal, administra pisos y monitorea la operación de tu estacionamiento.</p>
                        <div class="d-flex gap-3 flex-wrap">
                            <a href="admin.jsp" class="btn btn-outline-accent btn-lg">
                                <i class="bi bi-door-open-fill me-2"></i>Acceso a personal autorizado
                            </a>
                            <div class="d-flex align-items-center text-muted small gap-2">
                                <i class="bi bi-motherboard"></i>
                                <span>Control avanzado con roles y permisos</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <section class="mt-5" data-animate>
                <div class="surface-panel">
                    <div class="row align-items-center g-4">
                        <div class="col-lg-7">
                            <h2 class="section-title mb-3">Experiencia moderna y eficiente</h2>
                            <p class="section-subtitle">Diseñamos una interfaz perfecta que combina la elegancia y profesionalidad. Todo optimizado para ofrecer una mejor experiencia y manejo a nuestros usuarios.</p>
                            <ul class="list-unstyled mt-4 mb-0 row row-cols-1 row-cols-sm-2 g-3">
                                <li class="col d-flex align-items-center gap-2"><i class="bi bi-brightness-alt-high"></i><span>Transparencia en nuestra seguridad</span></li>
                                <li class="col d-flex align-items-center gap-2"><i class="bi bi-phone"></i><span>Diseño responsive para cualquier dispositivo</span></li>
                                <li class="col d-flex align-items-center gap-2"><i class="bi bi-gem"></i><span>Conocimiento de tu mejor forma de seguridad</span></li>
                                <li class="col d-flex align-items-center gap-2"><i class="bi bi-columns-gap"></i><span>Plataformas modernas e intuitivas</span></li>
                            </ul>
                        </div>
                        <div class="col-lg-5">
                            <div class="gradient-overlay h-100">
                                <h5 class="text-uppercase text-white-soft">¿Nuevo por aquí?</h5>
                                <h3 class="fw-bold text-strong mt-2">Regístrate y obtén acceso completo</h3>
                                <p class="text-soft">Crea tu cuenta en minutos y asocia tus vehículos para simplificar tu experiencia de estacionamiento.</p>
                                <a href="registro.jsp" class="btn btn-primary btn-lg mt-3">
                                    <i class="bi bi-pencil-square me-2"></i>Crear cuenta
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </main>

    <footer class="py-4 text-center text-muted small">
        &copy; <span id="currentYear"></span> Estación Resguarda. Innovación en movilidad urbana.
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/app.js"></script>
    <script>
        document.getElementById('currentYear').textContent = new Date().getFullYear();
    </script>
</body>
</html>