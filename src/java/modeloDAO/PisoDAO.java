/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modeloDAO;

import config.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import modelo.Piso;

public class PisoDAO {

    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    /**
     * Lista todos los pisos de una sede específica.
     */
    public List<Piso> listarPorSede(int idSede) {
        List<Piso> lista = new ArrayList<>();
        String sql = "SELECT * FROM tb_piso WHERE id_sede = ? ORDER BY numero_piso";
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idSede);
            rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapearResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error en PisoDAO.listarPorSede: " + e);
        } finally {
            cerrarRecursos();
        }
        return lista;
    }

    /**
     * Crea un nuevo piso en la base de datos.
     */
    public boolean crear(Piso piso) {
        String sql = "INSERT INTO tb_piso (id_sede, numero_piso, nombre_piso, capacidad_total, estado, creado_por) " +
                     "VALUES (?, ?, ?, ?, 'ACTIVO', ?)";
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            ps.setInt(1, piso.getIdSede());
            ps.setInt(2, piso.getNumeroPiso());
            ps.setString(3, piso.getNombrePiso());
            ps.setInt(4, piso.getCapacidadTotal());
            ps.setInt(5, piso.getCreadoPor());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error en PisoDAO.crear: " + e);
        } finally {
            cerrarRecursos();
        }
        return false;
    }
    
    /**
     * Cambia el estado de un piso (ACTIVO o INACTIVO).
     */
    public boolean cambiarEstado(int idPiso, String nuevoEstado) {
        String sql = "UPDATE tb_piso SET estado = ? WHERE id_piso = ?";
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            ps.setString(1, nuevoEstado);
            ps.setInt(2, idPiso);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error en PisoDAO.cambiarEstado: " + e);
        } finally {
            cerrarRecursos();
        }
        return false;
    }

    private Piso mapearResultSet(ResultSet rs) throws SQLException {
        Piso p = new Piso();
        p.setIdPiso(rs.getInt("id_piso"));
        p.setIdSede(rs.getInt("id_sede"));
        p.setNumeroPiso(rs.getInt("numero_piso"));
        p.setNombrePiso(rs.getString("nombre_piso"));
        p.setCapacidadTotal(rs.getInt("capacidad_total"));
        p.setEstado(rs.getString("estado"));
        p.setCreadoPor(rs.getInt("creado_por"));
        return p;
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