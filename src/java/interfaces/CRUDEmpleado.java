/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package interfaces;

import java.util.List;
import modelo.Empleado;

public interface CRUDEmpleado {

    /**
     * Valida las credenciales de un empleado usando el SP sp_login_empleado.
     */
    public Empleado validar(String usuario, String password);

    /**
     * Registra un nuevo empleado (Recepcionista o Guardia) usando el SP sp_crear_empleado.
     */
    public String registrarEmpleado(Empleado empleado, int idGerente);
    
    /**
     * Registra un nuevo Gerente usando el SP sp_crear_gerente.
     */
    public String registrarGerente(Empleado empleado, int idAdministrador);

    /**
     * Lista todos los empleados que pertenecen a una sede específica.
     */
    public List<Empleado> listarPorSede(int idSede);

    /**
     * Busca un empleado por su DNI.
     */
    public Empleado buscarPorDni(String dni);

    /**
     * Actualiza la información básica de un empleado (email, nombres, apellidos).
     * No actualiza DNI, rol, ni contraseña.
     */
    public String actualizar(Empleado empleado);

    /**
     * Cambia el estado de un empleado (de 'ACTIVO' a 'INACTIVO' o viceversa).
     */
    public String cambiarEstado(int idEmpleado, String nuevoEstado);
    
    public List<Empleado> listarPorRol(String rol);
    
    public Empleado buscarPorId(int idEmpleado);
    
}