/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modeloDAO;

import config.Conexion;
import interfaces.CRUDSede;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import modelo.Sede;

public class SedeDAO implements CRUDSede {

    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    @Override
    public List<Sede> listarTodas() {
        List<Sede> lista = new ArrayList<>();
        String sql = "SELECT * FROM tb_sede ORDER BY nombre";
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapearResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error en SedeDAO.listarTodas: " + e);
        } finally {
            cerrarRecursos();
        }
        return lista;
    }

    @Override
    public Sede buscarPorId(int idSede) {
        String sql = "SELECT * FROM tb_sede WHERE id_sede = ?";
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idSede);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapearResultSet(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error en SedeDAO.buscarPorId: " + e);
        } finally {
            cerrarRecursos();
        }
        return null;
    }

    @Override
    public int crear(Sede sede) {
        String sql = "INSERT INTO tb_sede (nombre, direccion, telefono, tarifa_base, estado) VALUES (?, ?, ?, ?, 'ACTIVA')";
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, sede.getNombre());
            ps.setString(2, sede.getDireccion());
            ps.setString(3, sede.getTelefono());
            ps.setDouble(4, sede.getTarifaBase());
            
            if (ps.executeUpdate() > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1); // Retorna el ID generado
                }
            }
        } catch (SQLException e) {
            System.err.println("Error en SedeDAO.crear: " + e);
        } finally {
            cerrarRecursos();
        }
        return 0; // Falla
    }

    @Override
    public boolean actualizar(Sede sede) {
        String sql = "UPDATE tb_sede SET nombre = ?, direccion = ?, telefono = ?, tarifa_base = ? WHERE id_sede = ?";
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            ps.setString(1, sede.getNombre());
            ps.setString(2, sede.getDireccion());
            ps.setString(3, sede.getTelefono());
            ps.setDouble(4, sede.getTarifaBase());
            ps.setInt(5, sede.getIdSede());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error en SedeDAO.actualizar: " + e);
        } finally {
            cerrarRecursos();
        }
        return false;
    }

    @Override
    public boolean cambiarEstado(int idSede, String nuevoEstado) {
        String sql = "UPDATE tb_sede SET estado = ? WHERE id_sede = ?";
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            ps.setString(1, nuevoEstado);
            ps.setInt(2, idSede);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error en SedeDAO.cambiarEstado: " + e);
        } finally {
            cerrarRecursos();
        }
        return false;
    }

    // --- Métodos de Ayuda (Helpers) ---

    private Sede mapearResultSet(ResultSet rs) throws SQLException {
        Sede sede = new Sede();
        sede.setIdSede(rs.getInt("id_sede"));
        sede.setNombre(rs.getString("nombre"));
        sede.setDireccion(rs.getString("direccion"));
        sede.setTelefono(rs.getString("telefono"));
        sede.setEstado(rs.getString("estado"));
        sede.setTarifaBase(rs.getDouble("tarifa_base"));
        sede.setFechaCreacion(rs.getTimestamp("fecha_creacion"));
        return sede;
    }
    
    @Override
    public List<Sede> listarSedesSinGerente() {
        List<Sede> lista = new ArrayList<>();
        String sql = "SELECT s.* FROM tb_sede s " +
                     "LEFT JOIN tb_empleados e ON s.id_sede = e.id_sede AND e.rol = 'GERENTE' " +
                     "WHERE s.estado = 'ACTIVA' AND e.id_empleado IS NULL " +
                     "ORDER BY s.nombre";
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapearResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error en SedeDAO.listarSedesSinGerente: " + e);
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
