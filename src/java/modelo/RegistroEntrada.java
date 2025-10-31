/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelo;

// Modelo simple para pasar los datos del formulario al DAO
public class RegistroEntrada {
    
    private String placa;
    private String dniConductor;
    private int idRecepcionista;
    private int idEspacio;
    private String emailConductor;

    public RegistroEntrada() {
    }

    // Getters y Setters
    public String getPlaca() { return placa; }
    public void setPlaca(String placa) { this.placa = placa; }
    public String getDniConductor() { return dniConductor; }
    public void setDniConductor(String dniConductor) { this.dniConductor = dniConductor; }
    public int getIdRecepcionista() { return idRecepcionista; }
    public void setIdRecepcionista(int idRecepcionista) { this.idRecepcionista = idRecepcionista; }
    public int getIdEspacio() { return idEspacio; }
    public void setIdEspacio(int idEspacio) { this.idEspacio = idEspacio; }
    public String getEmailConductor() { return emailConductor; }
    public void setEmailConductor(String emailConductor) { this.emailConductor = emailConductor; }
}