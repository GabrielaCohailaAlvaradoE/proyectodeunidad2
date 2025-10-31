<%-- 
    Document   : panelRecepcion
    Created on : 22 oct. 2025, 9:09:27 a. m.
    Author     : ASUS
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="modelo.Empleado" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>

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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Recepción - Sede <%= empleadoLogueado.getIdSede() %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        body { background-color: #f0f2f5; }
        .navbar { box-shadow: 0 2px 4px rgba(0,0,0,.1); }
        .navbar-brand { color: #004e92 !important; font-weight: 700; }
        .card { border: none; border-radius: 0.75rem; box-shadow: 0 4px 15px rgba(0,0,0,.08); }
        .nav-tabs .nav-link { color: #555; font-weight: 500; }
        .nav-tabs .nav-link.active { color: #004e92; border-bottom-width: 3px; }
        .form-control:read-only { background-color: #e9ecef; }
        #spinnerPlaca, #spinnerEspacios, #spinnerSalida { display: none; }
        .payment-details p { margin-bottom: 0.5rem; font-size: 1.1rem; }
        .payment-details p strong { color: #004e92; }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-light bg-white sticky-top">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">
                <i class="bi bi-shield-lock-fill"></i> Resguarda
            </a>
            <div class="d-flex align-items-center">
                <span class="navbar-text me-3">
                    <i class="bi bi-headset"></i>
                    Hola, <strong class="text-dark"><%= empleadoLogueado.getNombres() %></strong>
                    (Sede <%= empleadoLogueado.getIdSede() %>)
                </span>
                <a href="ControladorEmpleado?accion=logout" class="btn btn-outline-danger btn-sm">
                    <i class="bi bi-box-arrow-right me-1"></i> Cerrar Sesión
                </a>
            </div>
        </div>
    </nav>

    <div class="container my-4">
        
        <% if (exito != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i> <%= exito %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        <% if (error != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i> <%= error %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="card">
            <div class="card-header p-0">
                <ul class="nav nav-tabs nav-fill" id="pills-tab" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active p-3" id="pills-entrada-tab" data-bs-toggle="pill" data-bs-target="#pills-entrada" type="button" role="tab">
                            <i class="bi bi-box-arrow-in-right me-2 fs-5"></i> Registrar Entrada
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link p-3" id="pills-salida-tab" data-bs-toggle="pill" data-bs-target="#pills-salida" type="button" role="tab">
                            <i class="bi bi-box-arrow-left me-2 fs-5"></i> Registrar Salida
                        </button>
                    </li>
                </ul>
            </div>
            <div class="card-body p-4">
                <div class="tab-content" id="pills-tabContent">
                    
                    <div class="tab-pane fade show active" id="pills-entrada" role="tabpanel">
                        <h4 class="mb-3">Registro de Entrada de Vehículo</h4>
                        <form id="formEntrada" action="ControladorEstacionamiento" method="POST" class="row g-3">
                            <input type="hidden" name="accion" value="registrarEntrada">

                            <div class="col-md-7">
                                <div class="p-3 border rounded">
                                    <h5>1. Datos del Vehículo</h5>
                                    <label class="form-label">Placa</label>
                                    <div class="input-group">
                                        <input type="text" class="form-control" id="txtPlaca" name="txtPlaca" placeholder="ABC-123" required>
                                        <button class="btn btn-primary" type="button" id="btnBuscarPlaca">
                                            <span class="spinner-border spinner-border-sm" id="spinnerPlaca" role="status" aria-hidden="true"></span>
                                            <i class="bi bi-search" id="iconPlaca"></i> Buscar
                                        </button>
                                    </div>
                                    <div id="alertaPlaca" class="mt-2"></div>
                                    
                                    <div id="infoVehiculo" class="mt-3" style="display:none;">
                                        <div class="row">
                                            <div class="col-md-6 mb-2">
                                                <label class="form-label">Marca</label>
                                                <input type="text" class="form-control" id="infoMarca" readOnly>
                                            </div>
                                            <div class="col-md-6 mb-2">
                                                <label class="form-label">Modelo</label>
                                                <input type="text" class="form-control" id="infoModelo" readOnly>
                                            </div>
                                        </div>
                                    </div>

                                    <hr class="my-4">
                                    <h5>2. Datos del Conductor</h5>
                                    
                                    <div class="form-check mb-2">
                                        <input class="form-check-input" type="checkbox" id="checkEsPropietario">
                                        <label class="form-check-label" for="checkEsPropietario">
                                            El conductor es el propietario registrado
                                        </label>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label">DNI del Conductor</label>
                                        <input type="text" class="form-control" id="txtDniConductor" name="txtDniConductor" pattern="[0-9]{8}" maxlength="8" required>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Email del Conductor (Para QR/PIN)</label>
                                        <input type="email" class="form-control" id="txtEmailConductor" name="txtEmailConductor" required>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-md-5">
                                <div class="p-3 border rounded bg-light h-100">
                                    <h5>3. Asignar Espacio</h5>
                                    <label class="form-label">Espacios Disponibles</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="bi bi-p-circle"></i></span>
                                        <select class="form-select" id="selectEspacio" name="selectEspacio" required>
                                            <option value="">Cargando espacios...</option>
                                        </select>
                                        <span class="spinner-border spinner-border-sm m-2" id="spinnerEspacios" role="status"></span>
                                    </div>
                                    <div id="alertaEspacio" class="mt-2"></div>
                                    
                                    <div class="d-grid mt-5">
                                        <button type="submit" class="btn btn-success btn-lg">
                                            <i class="bi bi-check-circle-fill me-2"></i> Registrar Ingreso
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>

                    <div class="tab-pane fade" id="pills-salida" role="tabpanel">
                        <h4 class="mb-3">Registro de Salida de Vehículo</h4>
                        
                        <div class="row justify-content-center">
                            <div class="col-md-8 col-lg-6">
                                <label class="form-label">Buscar por PIN Temporal o Placa</label>
                                <div class="input-group mb-3">
                                    <input type="text" class="form-control form-control-lg" id="txtBusquedaSalida" placeholder="Ingrese PIN o Placa" required>
                                    <button class="btn btn-primary btn-lg" type="button" id="btnBuscarSalida">
                                        <span class="spinner-border spinner-border-sm" id="spinnerSalida" role="status" aria-hidden="true"></span>
                                        <i class="bi bi-search" id="iconSalida"></i> Buscar
                                    </button>
                                </div>
                                <div id="alertaSalida" class="mt-2"></div>
                            </div>
                        </div>

                        <form id="formSalida" action="ControladorEstacionamiento" method="POST" class="row g-4 mt-3" style="display:none;">
                            <input type="hidden" name="accion" value="registrarSalida">
                            <input type="hidden" id="txtIdRegistroSalida" name="txtIdRegistroSalida">
                            
                            <div class="col-md-7">
                                <div class="p-3 border rounded h-100 payment-details">
                                    <h5 class="mb-3">Detalles del Registro</h5>
                                    <p>Placa: <strong id="salidaPlaca">---</strong></p>
                                    <p>Vehículo: <strong id="salidaVehiculo">---</strong></p>
                                    <p>Espacio: <strong id="salidaEspacio">---</strong></p>
                                    <hr>
                                    <p>Hora Entrada: <strong id="salidaHoraEntrada">---</strong></p>
                                    <p>Tiempo Transcurrido: <strong id="salidaTiempo">---</strong></p>
                                    <p>Tarifa por Hora: <strong id="salidaTarifa">---</strong></p>
                                </div>
                            </div>
                            
                            <div class="col-md-5">
                                <div class="p-3 border rounded bg-light h-100">
                                    <h5 class="mb-3">Simulación de Pago</h5>
                                    <div class="mb-3">
                                        <label class="form-label">Monto Total a Pagar (S/)</label>
                                        <input type="text" id="salidaMontoTotal" name="txtMontoTotalSalida" class="form-control form-control-lg" readOnly>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Monto Recibido (S/)</label>
                                        <input type="number" step="0.10" id="txtMontoRecibido" name="txtMontoRecibido" class="form-control form-control-lg" required>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Vuelto (S/)</label>
                                        <input type="text" id="txtVuelto" class="form-control form-control-lg" readOnly>
                                    </div>
                                    <div class="d-grid">
                                        <button type="submit" id="btnRegistrarSalida" class="btn btn-success btn-lg" disabled>
                                            <i class="bi bi-cash-coin me-2"></i> Registrar Pago y Salida
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
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
            if(limpiarBusqueda) txtBusquedaSalida.value = '';
            montoTotalCalculado = 0;
            txtIdRegistroSalida.value = '';
            txtMontoTotalSalida.value = '';
            txtMontoTotalOculto.value = '';
            txtMontoRecibido.value = '';
            txtVuelto.value = '';
            btnRegistrarSalida.disabled = true;
        }

        function mostrarAlerta(elemento, tipo, mensaje) {
            elemento.innerHTML = `<div class="alert alert-${tipo} alert-dismissible fade show p-2" role="alert">
                                    ${mensaje}
                                    <button type="button" class="btn-close p-2" data-bs-dismiss="alert" aria-label="Close"></button>
                                  </div>`;
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