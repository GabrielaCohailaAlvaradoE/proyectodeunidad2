/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modeloDAO;

import config.Conexion;
import interfaces.CRUDVehiculo;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import modelo.Cliente;
import modelo.Vehiculo;

public class VehiculoDAO implements CRUDVehiculo {

    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    @Override
    public Vehiculo buscarPorPlaca(String placa) {
        Vehiculo vehiculo = null;
        String sql = "SELECT v.*, u.id_usuario, u.dni, u.nombres, u.apellidos, u.email " +
                     "FROM tb_vehiculo v " +
                     "JOIN tb_usuarios_web u ON v.id_propietario = u.id_usuario " +
                     "WHERE v.placa = ?";
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            ps.setString(1, placa.trim().toUpperCase());
            rs = ps.executeQuery();
            if (rs.next()) {
                vehiculo = mapearResultSetConPropietario(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error en VehiculoDAO.buscarPorPlaca: " + e);
        } finally {
            cerrarRecursos();
        }
        return vehiculo;
    }

    @Override
    public List<Vehiculo> listarPorPropietario(int idPropietario) {
        List<Vehiculo> lista = new ArrayList<>();
        String sql = "SELECT * FROM tb_vehiculo WHERE id_propietario = ? ORDER BY placa";
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idPropietario);
            rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapearResultSetSimple(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error en VehiculoDAO.listarPorPropietario: " + e);
        } finally {
            cerrarRecursos();
        }
        return lista;
    }

    @Override
    public boolean crear(Vehiculo vehiculo) {
        String sql = "INSERT INTO tb_vehiculo (placa, marca, modelo, anio_fabricacion, " +
                     "color, vin, estado_soat, id_propietario) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, vehiculo.getPlaca().toUpperCase());
            ps.setString(2, vehiculo.getMarca());
            ps.setString(3, vehiculo.getModelo());
            if (vehiculo.getAnioFabricacion() > 0) {
                 ps.setInt(4, vehiculo.getAnioFabricacion());
            } else {
                 ps.setNull(4, java.sql.Types.INTEGER);
            }
            ps.setString(5, vehiculo.getColor());
            ps.setString(6, vehiculo.getVin());
            ps.setString(7, vehiculo.getEstadoSoat());
            ps.setInt(8, vehiculo.getIdPropietario());

            int filasAfectadas = ps.executeUpdate();
            if (filasAfectadas > 0) {
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Error en VehiculoDAO.crear: " + e);
        } finally {
            cerrarRecursos();
        }
        return false;
    }

    private Vehiculo mapearResultSetConPropietario(ResultSet rs) throws SQLException {
        Vehiculo vehiculo = mapearResultSetSimple(rs);
        Cliente propietario = new Cliente();
        propietario.setIdUsuario(rs.getInt("id_usuario"));
        propietario.setDni(rs.getString("dni"));
        propietario.setNombres(rs.getString("nombres"));
        propietario.setApellidos(rs.getString("apellidos"));
        propietario.setEmail(rs.getString("email"));
        vehiculo.setPropietario(propietario);
        return vehiculo;
    }

    private Vehiculo mapearResultSetSimple(ResultSet rs) throws SQLException {
        Vehiculo vehiculo = new Vehiculo();
        vehiculo.setIdVehiculo(rs.getInt("id_vehiculo"));
        vehiculo.setPlaca(rs.getString("placa"));
        vehiculo.setMarca(rs.getString("marca"));
        vehiculo.setModelo(rs.getString("modelo"));
        vehiculo.setColor(rs.getString("color"));
        vehiculo.setAnioFabricacion(rs.getInt("anio_fabricacion"));
        vehiculo.setEstadoSoat(rs.getString("estado_soat"));
        vehiculo.setIdPropietario(rs.getInt("id_propietario"));
        vehiculo.setVin(rs.getString("vin"));
        return vehiculo;
    }

    private void cerrarRecursos() {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            System.err.println("Error al cerrar recursos: " + e);
        }
    }
}