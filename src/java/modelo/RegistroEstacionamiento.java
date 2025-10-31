/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelo;

import java.util.Date;

/**
 * Este modelo representa un registro de estacionamiento ACTIVO.
 * Se usa para pasar datos desde el DAO (sp_buscar_registro_activo) 
 * hacia el Controlador y el JSP para la lógica de salida.
 */
public class RegistroEstacionamiento {

    // Campos del registro
    private int idRegistro;
    private Date horaEntrada;
    private String pinTemp;
    
    // Campos del conductor (obtenidos del COALESCE en el SP)
    private String dniConductor;
    private String emailConductor;
    
    // Campos anidados
    private Vehiculo vehiculo; // Contiene placa, marca, modelo
    private Espacio espacio;   // Contiene numeroEspacio, nombrePiso

    // Campos para el cálculo de pago
    private double tarifaBaseSede;
    private long minutosTranscurridos;
    private double montoCalculado; // Lo llenaremos en el controlador

    public RegistroEstacionamiento() {
    }

    // --- Getters y Setters ---

    public int getIdRegistro() {
        return idRegistro;
    }

    public void setIdRegistro(int idRegistro) {
        this.idRegistro = idRegistro;
    }

    public Date getHoraEntrada() {
        return horaEntrada;
    }

    public void setHoraEntrada(Date horaEntrada) {
        this.horaEntrada = horaEntrada;
    }

    public String getPinTemp() {
        return pinTemp;
    }

    public void setPinTemp(String pinTemp) {
        this.pinTemp = pinTemp;
    }

    public String getDniConductor() {
        return dniConductor;
    }

    public void setDniConductor(String dniConductor) {
        this.dniConductor = dniConductor;
    }

    public String getEmailConductor() {
        return emailConductor;
    }

    public void setEmailConductor(String emailConductor) {
        this.emailConductor = emailConductor;
    }

    public Vehiculo getVehiculo() {
        return vehiculo;
    }

    public void setVehiculo(Vehiculo vehiculo) {
        this.vehiculo = vehiculo;
    }

    public Espacio getEspacio() {
        return espacio;
    }

    public void setEspacio(Espacio espacio) {
        this.espacio = espacio;
    }

    public double getTarifaBaseSede() {
        return tarifaBaseSede;
    }

    public void setTarifaBaseSede(double tarifaBaseSede) {
        this.tarifaBaseSede = tarifaBaseSede;
    }

    public long getMinutosTranscurridos() {
        return minutosTranscurridos;
    }

    public void setMinutosTranscurridos(long minutosTranscurridos) {
        this.minutosTranscurridos = minutosTranscurridos;
    }

    public double getMontoCalculado() {
        return montoCalculado;
    }

    public void setMontoCalculado(double montoCalculado) {
        this.montoCalculado = montoCalculado;
    }
}