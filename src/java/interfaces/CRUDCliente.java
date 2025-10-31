/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package interfaces;

import java.util.List;
import modelo.Cliente;


public interface CRUDCliente {
      
    public boolean registrar(Cliente cliente);
    
    public Cliente validar(String dni, String password);
    
    public boolean verificarExistencia(String dni, String email);
    
}