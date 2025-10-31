/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelo;

import java.util.Date;
import java.util.List; // Importante para anidar espacios

public class Piso {

    private int idPiso;
    private int idSede;
    private int numeroPiso;
    private String nombrePiso;
    private int capacidadTotal;
    private String estado; // ACTIVO, INACTIVO
    private int creadoPor; // id_empleado (Gerente)
    private Date fechaCreacion; // (Este campo no está en tu tabla, pero es útil)

    // Extra: Para anidar los espacios
    private List<Espacio> espacios;

    public Piso() {
    }

    // --- Getters y Setters ---

    public int getIdPiso() {
        return idPiso;
    }

    public void setIdPiso(int idPiso) {
        this.idPiso = idPiso;
    }

    public int getIdSede() {
        return idSede;
    }

    public void setIdSede(int idSede) {
        this.idSede = idSede;
    }

    public int getNumeroPiso() {
        return numeroPiso;
    }

    public void setNumeroPiso(int numeroPiso) {
        this.numeroPiso = numeroPiso;
    }

    public String getNombrePiso() {
        return nombrePiso;
    }

    public void setNombrePiso(String nombrePiso) {
        this.nombrePiso = nombrePiso;
    }

    public int getCapacidadTotal() {
        return capacidadTotal;
    }

    public void setCapacidadTotal(int capacidadTotal) {
        this.capacidadTotal = capacidadTotal;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public int getCreadoPor() {
        return creadoPor;
    }

    public void setCreadoPor(int creadoPor) {
        this.creadoPor = creadoPor;
    }

    public Date getFechaCreacion() {
        return fechaCreacion;
    }

    public void setFechaCreacion(Date fechaCreacion) {
        // Tu tabla no tiene fecha_creacion, así que omitimos el setter
    }

    public List<Espacio> getEspacios() {
        return espacios;
    }

    public void setEspacios(List<Espacio> espacios) {
        this.espacios = espacios;
    }
}