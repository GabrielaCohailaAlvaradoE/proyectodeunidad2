/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package interfaces;

import java.util.List;
import modelo.Vehiculo;

public interface CRUDVehiculo {
    public Vehiculo buscarPorPlaca(String placa);
    public List<Vehiculo> listarPorPropietario(int idPropietario);
    public boolean crear(Vehiculo vehiculo);

}