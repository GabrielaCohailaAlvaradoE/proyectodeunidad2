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
import java.util.ArrayList;
import java.util.List;
import modelo.Espacio;

public class EspacioDAO {
    
    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    /**
     * Lista todos los espacios de un piso específico.
     */
    public List<Espacio> listarPorPiso(int idPiso) {
        List<Espacio> lista = new ArrayList<>();
        String sql = "SELECT * FROM tb_espacio WHERE id_piso = ? ORDER BY numero_espacio";
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idPiso);
            rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapearResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error en EspacioDAO.listarPorPiso: " + e);
        } finally {
            cerrarRecursos();
        }
        return lista;
    }

    /**
     * Crea un nuevo espacio en la base de datos.
     */
    public boolean crear(Espacio espacio) {
        String sql = "INSERT INTO tb_espacio (id_piso, numero_espacio, estado, descripcion, creado_por) " +
                     "VALUES (?, ?, 'LIBRE', ?, ?)";
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            ps.setInt(1, espacio.getIdPiso());
            ps.setString(2, espacio.getNumeroEspacio());
            ps.setString(3, espacio.getDescripcion());
            ps.setInt(4, espacio.getCreadoPor());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error en EspacioDAO.crear: " + e);
        } finally {
            cerrarRecursos();
        }
        return false;
    }

    /**
     * Cambia el estado de un espacio (LIBRE, OCUPADO, MANTENIMIENTO).
     */
    public boolean cambiarEstado(int idEspacio, String nuevoEstado) {
        String sql = "UPDATE tb_espacio SET estado = ? WHERE id_espacio = ?";
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            ps.setString(1, nuevoEstado);
            ps.setInt(2, idEspacio);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error en EspacioDAO.cambiarEstado: " + e);
        } finally {
            cerrarRecursos();
        }
        return false;
    }

    private Espacio mapearResultSet(ResultSet rs) throws SQLException {
        Espacio e = new Espacio();
        e.setIdEspacio(rs.getInt("id_espacio"));
        e.setIdPiso(rs.getInt("id_piso"));
        e.setNumeroEspacio(rs.getString("numero_espacio"));
        e.setEstado(rs.getString("estado"));
        e.setDescripcion(rs.getString("descripcion"));
        e.setCreadoPor(rs.getInt("creado_por"));
        return e;
    }
    
    public List<Espacio> listarLibresPorSede(int idSede) {
        List<Espacio> lista = new ArrayList<>();
        // Hacemos JOIN con tb_piso para filtrar por sede
        String sql = "SELECT e.*, p.nombre_piso " +
                     "FROM tb_espacio e " +
                     "JOIN tb_piso p ON e.id_piso = p.id_piso " +
                     "WHERE p.id_sede = ? AND e.estado = 'LIBRE' " +
                     "ORDER BY p.numero_piso, e.numero_espacio";
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idSede);
            rs = ps.executeQuery();
            while (rs.next()) {
                Espacio e = mapearResultSet(rs);
                // (El mapeador no incluye 'nombre_piso', lo añadimos)
                e.setNombrePiso(rs.getString("nombre_piso"));
                lista.add(e);
            }
        } catch (SQLException e) {
            System.err.println("Error en EspacioDAO.listarLibresPorSede: " + e);
        } finally {
            cerrarRecursos();
        }
        return lista;
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