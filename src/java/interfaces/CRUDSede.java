/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package interfaces;

import java.util.List;
import modelo.Sede;

public interface CRUDSede {
    
    /**
     * Lista todas las sedes registradas en la base de datos.
     */
    public List<Sede> listarTodas();
    
    /**
     * Busca una sede específica por su ID.
     */
    public Sede buscarPorId(int idSede);
    
    /**
     * Registra una nueva sede en la base de datos.
     * Retorna el ID de la sede creada o 0 si falla.
     */
    public int crear(Sede sede);
    
    /**
     * Actualiza los datos de una sede existente.
     */
    public boolean actualizar(Sede sede);
    
    /**
     * Cambia el estado de una sede (ACTIVA o INACTIVA).
     */
    public boolean cambiarEstado(int idSede, String nuevoEstado);
    
    public List<Sede> listarSedesSinGerente();
    
}