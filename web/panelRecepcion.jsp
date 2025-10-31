<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="modelo.Empleado" %>
<%
    Empleado empleadoLogueado = (Empleado) session.getAttribute("empleadoLogueado");
    if (empleadoLogueado == null) {
        response.sendRedirect("admin.jsp");
        return;
    }
    String empleadoRol = empleadoLogueado.getRol();
    if (!"RECEPCIONISTA".equals(empleadoRol) && !"GERENTE".equals(empleadoRol) && !"ADMINISTRADOR".equals(empleadoRol)) {
        response.sendRedirect("admin.jsp?error=No tiene permisos de Recepción");
        return;
    }

    String exito = (String) session.getAttribute("exito");
    String error = (String) session.getAttribute("error");
    if (exito != null) session.removeAttribute("exito");
    if (error != null) session.removeAttribute("error");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Panel de Recepción - Sede <%= empleadoLogueado.getIdSede() %></title>
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
            <a class="navbar-brand" href="#">
                <i class="bi bi-columns-gap me-2"></i><span class="brand-accent">Resguarda</span> Recepción
            </a>
            <button class="navbar-toggler text-strong border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarRecepcion" aria-controls="navbarRecepcion" aria-expanded="false" aria-label="Alternar navegación">
                <i class="bi bi-list fs-3"></i>
            </button>
            <div class="collapse navbar-collapse justify-content-end" id="navbarRecepcion">
                <ul class="navbar-nav align-items-lg-center me-lg-3">
                    <li class="nav-item"><span class="nav-link"><i class="bi bi-headset me-1"></i>Hola, <strong class="text-strong"><%= empleadoLogueado.getNombres() %></strong></span></li>
                    <li class="nav-item"><span class="nav-link">Sede <strong class="text-strong"><%= empleadoLogueado.getIdSede() %></strong></span></li>
                </ul>
                <div class="d-flex align-items-center gap-2">
                    <button class="btn btn-sm btn-outline-accent btn-theme-toggle" type="button" data-action="toggle-theme" aria-label="Cambiar tema">
                        <i class="bi bi-sun-fill" data-theme-icon></i>
                        <span class="ms-2" data-theme-label>Modo Claro</span>
                    </button>
                    <a href="ControladorEmpleado?accion=logout" class="btn btn-outline-primary btn-sm">
                        <i class="bi bi-box-arrow-right me-1"></i>Salir
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <main class="flex-grow-1">
        <div class="container-fluid px-4 py-4 py-lg-5">
            <div class="row mb-4" data-animate>
                <div class="col-lg-8">
                    <h1 class="section-title">Recepción de vehículos</h1>
                    <p class="section-subtitle">Registra ingresos y salidas con un flujo guiado y actualizaciones en tiempo real.</p>
                </div>
                <div class="col-lg-4">
                    <div class="callout h-100">
                        <strong>Consejo:</strong> Mantén actualizados los correos para enviar PIN y QR de salida.
                    </div>
                </div>
            </div>

            <% if (exito != null) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert" data-animate>
                    <i class="bi bi-check-circle-fill me-2"></i> <%= exito %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>
            <% if (error != null) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert" data-animate>
                    <i class="bi bi-exclamation-triangle-fill me-2"></i> <%= error %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>

            <div class="app-card p-0" data-animate>
                <div class="card-header border-0 bg-transparent px-4 pt-4">
                    <ul class="nav nav-pills nav-fill" id="pills-tab" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="pills-entrada-tab" data-bs-toggle="pill" data-bs-target="#pills-entrada" type="button" role="tab">
                                <i class="bi bi-box-arrow-in-right me-2"></i>Registrar entrada
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="pills-salida-tab" data-bs-toggle="pill" data-bs-target="#pills-salida" type="button" role="tab">
                                <i class="bi bi-box-arrow-left me-2"></i>Registrar salida
                            </button>
                        </li>
                    </ul>
                </div>
                <div class="card-body p-4">
                    <div class="tab-content" id="pills-tabContent">
                        <div class="tab-pane fade show active" id="pills-entrada" role="tabpanel">
                            <div class="row g-4">
                                <div class="col-lg-7">
                                    <div class="surface-panel h-100">
                                        <h4 class="mb-4">1. Datos del vehículo</h4>
                                        <form id="formEntrada" action="ControladorEstacionamiento" method="POST" class="row g-3">
                                            <input type="hidden" name="accion" value="registrarEntrada">
                                            <div class="col-12">
                                                <label class="form-label">Placa</label>
                                                <div class="input-group">
                                                    <input type="text" class="form-control" id="txtPlaca" name="txtPlaca" placeholder="ABC-123" required>
                                                    <button class="btn btn-primary" type="button" id="btnBuscarPlaca">
                                                        <span class="spinner-border spinner-border-sm" id="spinnerPlaca" role="status" aria-hidden="true"></span>
                                                        <i class="bi bi-search" id="iconPlaca"></i>
                                                        Buscar
                                                    </button>
                                                </div>
                                                <div id="alertaPlaca" class="mt-2"></div>
                                            </div>
                                            <div id="infoVehiculo" class="col-12" style="display:none;">
                                                <div class="row g-3">
                                                    <div class="col-md-6">
                                                        <label class="form-label">Marca</label>
                                                        <input type="text" class="form-control" id="infoMarca" readOnly>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <label class="form-label">Modelo</label>
                                                        <input type="text" class="form-control" id="infoModelo" readOnly>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-12">
                                                <hr class="my-3">
                                                <h4 class="mb-3">2. Datos del conductor</h4>
                                                <div class="form-check mb-3">
                                                    <input class="form-check-input" type="checkbox" id="checkEsPropietario">
                                                    <label class="form-check-label" for="checkEsPropietario">El conductor es el propietario registrado</label>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label">DNI del conductor</label>
                                                <input type="text" class="form-control" id="txtDniConductor" name="txtDniConductor" pattern="[0-9]{8}" maxlength="8" required>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label">Email del conductor</label>
                                                <input type="email" class="form-control" id="txtEmailConductor" name="txtEmailConductor" required>
                                            </div>
                                            <div class="col-12">
                                                <hr class="my-3">
                                                <h4 class="mb-3">3. Asignar espacio</h4>
                                                <div class="input-group">
                                                    <span class="input-group-text"><i class="bi bi-p-circle"></i></span>
                                                    <select class="form-select" id="selectEspacio" name="selectEspacio" required>
                                                        <option value="">Cargando espacios...</option>
                                                    </select>
                                                    <span class="spinner-border spinner-border-sm m-2" id="spinnerEspacios" role="status"></span>
                                                </div>
                                                <div id="alertaEspacio" class="mt-2"></div>
                                            </div>
                                            <div class="col-12">
                                                <div class="d-grid">
                                                    <button type="submit" class="btn btn-success btn-lg">
                                                        <i class="bi bi-check-circle-fill me-2"></i>Registrar ingreso
                                                    </button>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                                <div class="col-lg-5">
                                    <div class="surface-panel h-100">
                                        <h4 class="mb-3">Resumen rápido</h4>
                                        <p class="text-muted mb-1">• Al buscar la placa obtendrás datos del propietario si está registrado.</p>
                                        <p class="text-muted mb-1">• Puedes asignar espacios disponibles por piso en tiempo real.</p>
                                        <p class="text-muted mb-0">• El correo ingresado recibirá el PIN de salida automático.</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="tab-pane fade" id="pills-salida" role="tabpanel">
                            <div class="surface-panel mb-4">
                                <h4 class="mb-3">Buscar registro activo</h4>
                                <div class="row justify-content-center">
                                    <div class="col-lg-6">
                                        <label class="form-label">PIN temporal o placa</label>
                                        <div class="input-group input-group-lg">
                                            <input type="text" class="form-control" id="txtBusquedaSalida" placeholder="Ingrese PIN o Placa" required>
                                            <button class="btn btn-primary" type="button" id="btnBuscarSalida">
                                                <span class="spinner-border spinner-border-sm" id="spinnerSalida" role="status" aria-hidden="true"></span>
                                                <i class="bi bi-search" id="iconSalida"></i>
                                                Buscar
                                            </button>
                                        </div>
                                        <div id="alertaSalida" class="mt-2"></div>
                                    </div>
                                </div>
                            </div>

                            <form id="formSalida" action="ControladorEstacionamiento" method="POST" class="row g-4" style="display:none;">
                                <input type="hidden" name="accion" value="registrarSalida">
                                <input type="hidden" id="txtIdRegistroSalida" name="txtIdRegistroSalida">

                                <div class="col-lg-7">
                                    <div class="surface-panel payment-details h-100">
                                        <h4 class="mb-3">Detalles del registro</h4>
                                        <p>Placa: <strong id="salidaPlaca">---</strong></p>
                                        <p>Vehículo: <strong id="salidaVehiculo">---</strong></p>
                                        <p>Espacio: <strong id="salidaEspacio">---</strong></p>
                                        <hr>
                                        <p>Hora entrada: <strong id="salidaHoraEntrada">---</strong></p>
                                        <p>Tiempo transcurrido: <strong id="salidaTiempo">---</strong></p>
                                        <p>Tarifa por hora: <strong id="salidaTarifa">---</strong></p>
                                    </div>
                                </div>
                                <div class="col-lg-5">
                                    <div class="surface-panel h-100">
                                        <h4 class="mb-3">Simulación de pago</h4>
                                        <div class="mb-3">
                                            <label class="form-label">Monto total (S/)</label>
                                            <input type="text" id="salidaMontoTotal" name="txtMontoTotalSalida" class="form-control form-control-lg" readOnly>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Monto recibido (S/)</label>
                                            <input type="number" step="0.10" id="txtMontoRecibido" name="txtMontoRecibido" class="form-control form-control-lg" required>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Vuelto (S/)</label>
                                            <input type="text" id="txtVuelto" class="form-control form-control-lg" readOnly>
                                        </div>
                                        <div class="d-grid">
                                            <button type="submit" id="btnRegistrarSalida" class="btn btn-success btn-lg" disabled>
                                                <i class="bi bi-cash-coin me-2"></i>Registrar pago y salida
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </form>
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
    <script>
        let vehiculoEncontrado = null;
        let montoTotalCalculado = 0;

        const btnBuscarPlaca = document.getElementById('btnBuscarPlaca');
        const txtPlaca = document.getElementById('txtPlaca');
        const alertaPlaca = document.getElementById('alertaPlaca');
        const infoVehiculo = document.getElementById('infoVehiculo');
        const infoMarca = document.getElementById('infoMarca');
        const infoModelo = document.getElementById('infoModelo');
        const spinnerPlaca = document.getElementById('spinnerPlaca');
        const iconPlaca = document.getElementById('iconPlaca');
        const checkEsPropietario = document.getElementById('checkEsPropietario');
        const txtDniConductor = document.getElementById('txtDniConductor');
        const txtEmailConductor = document.getElementById('txtEmailConductor');
        const selectEspacio = document.getElementById('selectEspacio');
        const alertaEspacio = document.getElementById('alertaEspacio');
        const spinnerEspacios = document.getElementById('spinnerEspacios');

        const btnBuscarSalida = document.getElementById('btnBuscarSalida');
        const txtBusquedaSalida = document.getElementById('txtBusquedaSalida');
        const spinnerSalida = document.getElementById('spinnerSalida');
        const iconSalida = document.getElementById('iconSalida');
        const alertaSalida = document.getElementById('alertaSalida');
        const formSalida = document.getElementById('formSalida');
        const txtIdRegistroSalida = document.getElementById('txtIdRegistroSalida');
        const txtMontoTotalSalida = document.getElementById('salidaMontoTotal');
        const txtMontoTotalOculto = document.getElementsByName('txtMontoTotalSalida')[0];
        const txtMontoRecibido = document.getElementById('txtMontoRecibido');
        const txtVuelto = document.getElementById('txtVuelto');
        const btnRegistrarSalida = document.getElementById('btnRegistrarSalida');
        const salidaPlaca = document.getElementById('salidaPlaca');
        const salidaVehiculo = document.getElementById('salidaVehiculo');
        const salidaEspacio = document.getElementById('salidaEspacio');
        const salidaHoraEntrada = document.getElementById('salidaHoraEntrada');
        const salidaTiempo = document.getElementById('salidaTiempo');
        const salidaTarifa = document.getElementById('salidaTarifa');

        const entradaTab = document.getElementById('pills-entrada-tab');
        const salidaTab = document.getElementById('pills-salida-tab');

        document.addEventListener('DOMContentLoaded', () => {
            cargarEspaciosLibres();
        });

        entradaTab.addEventListener('shown.bs.tab', () => {
            cargarEspaciosLibres();
            resetFormularioSalida();
        });

        salidaTab.addEventListener('shown.bs.tab', () => {
            resetFormularioSalida();
            txtBusquedaSalida.focus();
        });

        btnBuscarPlaca.addEventListener('click', async () => {
            const placa = txtPlaca.value.trim().toUpperCase();
            if (placa.length < 5) {
                mostrarAlerta(alertaPlaca, 'warning', 'Ingrese una placa válida.');
                return;
            }

            toggleSpinner(true, spinnerPlaca, iconPlaca, btnBuscarPlaca);
            infoVehiculo.style.display = 'none';
            vehiculoEncontrado = null;
            checkEsPropietario.checked = false;

            try {
                const response = await fetch(`ControladorEstacionamiento?accion=buscarPlaca&placa=${placa}`);
                const data = await response.json();

                if (data.status === 'success') {
                    vehiculoEncontrado = data.vehiculo;
                    mostrarAlerta(alertaPlaca, 'success', 'Vehículo encontrado. Propietario: ' + vehiculoEncontrado.propietario.nombres);
                    infoMarca.value = vehiculoEncontrado.marca;
                    infoModelo.value = vehiculoEncontrado.modelo;
                    infoVehiculo.style.display = 'flex';

                    txtDniConductor.value = vehiculoEncontrado.propietario.dni;
                    txtEmailConductor.value = vehiculoEncontrado.propietario.email;
                    checkEsPropietario.checked = true;

                } else {
                    mostrarAlerta(alertaPlaca, 'info', data.message);
                    vehiculoEncontrado = null;
                }
            } catch (error) {
                mostrarAlerta(alertaPlaca, 'danger', 'Error de red al buscar la placa.');
            } finally {
                toggleSpinner(false, spinnerPlaca, iconPlaca, btnBuscarPlaca);
            }
        });

        checkEsPropietario.addEventListener('change', () => {
            if (checkEsPropietario.checked && vehiculoEncontrado) {
                txtDniConductor.value = vehiculoEncontrado.propietario.dni;
                txtEmailConductor.value = vehiculoEncontrado.propietario.email;
            } else {
                txtDniConductor.value = '';
                txtEmailConductor.value = '';
            }
        });

        async function cargarEspaciosLibres() {
            toggleSpinner(true, spinnerEspacios);
            try {
                const response = await fetch('ControladorEstacionamiento?accion=listarEspacios');
                const data = await response.json();

                if (data.status === 'success') {
                    selectEspacio.innerHTML = '<option value="">-- Seleccione un espacio --</option>';
                    let pisos = {};
                    data.espacios.forEach(esp => {
                        if (!pisos[esp.nombrePiso]) { pisos[esp.nombrePiso] = []; }
                        pisos[esp.nombrePiso].push(esp);
                    });

                    for (const nombrePiso in pisos) {
                        let optgroup = document.createElement('optgroup');
                        optgroup.label = nombrePiso;
                        pisos[nombrePiso].forEach(esp => {
                            let option = document.createElement('option');
                            option.value = esp.idEspacio;
                            option.textContent = esp.numeroEspacio;
                            optgroup.appendChild(option);
                        });
                        selectEspacio.appendChild(optgroup);
                    }
                } else {
                    mostrarAlerta(alertaEspacio, 'danger', data.message);
                }
            } catch (error) {
                mostrarAlerta(alertaEspacio, 'danger', 'Error de red al cargar espacios.');
            } finally {
                toggleSpinner(false, spinnerEspacios);
            }
        }

        btnBuscarSalida.addEventListener('click', async () => {
            const placaOPin = txtBusquedaSalida.value.trim();
            if (!placaOPin) {
                mostrarAlerta(alertaSalida, 'warning', 'Debe ingresar un PIN o Placa.');
                return;
            }

            toggleSpinner(true, spinnerSalida, iconSalida, btnBuscarSalida);
            resetFormularioSalida(false);

            try {
                const response = await fetch(`ControladorEstacionamiento?accion=buscarVehiculoSalida&placaOPin=${placaOPin}`);
                if (response.status === 401) {
                    mostrarAlerta(alertaSalida, 'danger', 'Su sesión ha expirado. Por favor, inicie sesión de nuevo.');
                    return;
                }
                if (!response.ok) {
                    throw new Error(`Error HTTP ${response.status}: ${response.statusText}`);
                }
                const data = await response.json();

                if (data.status === 'success') {
                    const reg = data.registro;
                    montoTotalCalculado = reg.montoCalculado;
                    txtIdRegistroSalida.value = reg.idRegistro;
                    txtMontoTotalOculto.value = reg.montoCalculado.toFixed(2);
                    salidaPlaca.textContent = reg.vehiculo.placa;
                    salidaVehiculo.textContent = `${reg.vehiculo.marca} ${reg.vehiculo.modelo}`;
                    salidaEspacio.textContent = `${reg.espacio.nombrePiso} - ${reg.espacio.numeroEspacio}`;
                    salidaHoraEntrada.textContent = new Date(reg.horaEntrada).toLocaleString('es-PE');
                    salidaTiempo.textContent = `${reg.minutosTranscurridos} minutos`;
                    salidaTarifa.textContent = `S/ ${reg.tarifaBaseSede.toFixed(2)} por hora`;
                    txtMontoTotalSalida.value = reg.montoCalculado.toFixed(2);
                    txtMontoRecibido.value = '';
                    txtVuelto.value = '';
                    btnRegistrarSalida.disabled = true;
                    formSalida.style.display = 'flex';
                    txtMontoRecibido.focus();
                } else if (data.status === 'not_found') {
                    mostrarAlerta(alertaSalida, 'info', data.message);
                } else {
                    mostrarAlerta(alertaSalida, 'danger', data.message);
                }
            } catch (error) {
                console.error('Error en fetch buscarVehiculoSalida:', error);
                mostrarAlerta(alertaSalida, 'danger', 'Error de conexión o al procesar la respuesta: ' + error.message);
            } finally {
                toggleSpinner(false, spinnerSalida, iconSalida, btnBuscarSalida);
            }
        });

        txtMontoRecibido.addEventListener('input', () => {
            const recibido = parseFloat(txtMontoRecibido.value) || 0;
            const total = montoTotalCalculado;

            if (recibido > 0 && recibido >= total) {
                const vuelto = recibido - total;
                txtVuelto.value = vuelto.toFixed(2);
                btnRegistrarSalida.disabled = false;
            } else {
                txtVuelto.value = '---';
                btnRegistrarSalida.disabled = true;
            }
        });

        function resetFormularioSalida(limpiarBusqueda = true) {
            formSalida.style.display = 'none';
            alertaSalida.innerHTML = '';
            if (limpiarBusqueda) txtBusquedaSalida.value = '';
            montoTotalCalculado = 0;
            txtIdRegistroSalida.value = '';
            txtMontoTotalSalida.value = '';
            txtMontoTotalOculto.value = '';
            txtMontoRecibido.value = '';
            txtVuelto.value = '';
            btnRegistrarSalida.disabled = true;
        }

        function mostrarAlerta(elemento, tipo, mensaje) {
            elemento.innerHTML = `<div class="alert alert-${tipo} alert-dismissible fade show p-2" role="alert">${mensaje}<button type="button" class="btn-close p-2" data-bs-dismiss="alert" aria-label="Close"></button></div>`;
        }

        function toggleSpinner(show, spinner, icon = null, button = null) {
            if (show) {
                spinner.style.display = 'inline-block';
                if (icon) icon.style.display = 'none';
                if (button) button.disabled = true;
            } else {
                spinner.style.display = 'none';
                if (icon) icon.style.display = 'inline-block';
                if (button) button.disabled = false;
            }
        }
    </script>
</body>
</html>