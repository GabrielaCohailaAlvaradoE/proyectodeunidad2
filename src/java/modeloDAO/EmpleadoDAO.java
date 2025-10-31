/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modeloDAO;

import config.Conexion;
import interfaces.CRUDEmpleado;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import modelo.Empleado;

public class EmpleadoDAO implements CRUDEmpleado {

    Conexion cn = new Conexion();
    Connection con;
    CallableStatement cst;
    PreparedStatement ps;
    ResultSet rs;

    /**
     * Valida las credenciales de un empleado usando el SP sp_login_empleado.
     */
    @Override
    public Empleado validar(String usuario, String password) {
        Empleado empleadoLogin = null;
        String sql = "{CALL sp_login_empleado(?, ?, ?, ?, ?, ?, ?, ?)}";

        try {
            con = cn.conectar();
            cst = con.prepareCall(sql);

            cst.setString(1, usuario);
            cst.setString(2, password);

            cst.registerOutParameter(3, java.sql.Types.INTEGER);    // p_id_empleado
            cst.registerOutParameter(4, java.sql.Types.VARCHAR);   // p_nombres
            cst.registerOutParameter(5, java.sql.Types.VARCHAR);   // p_apellidos
            cst.registerOutParameter(6, java.sql.Types.VARCHAR);   // p_rol
            cst.registerOutParameter(7, java.sql.Types.INTEGER);    // p_id_sede
            cst.registerOutParameter(8, java.sql.Types.VARCHAR);   // p_mensaje

            cst.execute();

            String mensaje = cst.getString(8);
            System.out.println("Mensaje del SP (Login Empleado): " + mensaje);

            if ("Login exitoso".equals(mensaje)) {
                empleadoLogin = new Empleado();
                empleadoLogin.setIdEmpleado(cst.getInt(3));
                empleadoLogin.setUsuario(usuario);
                empleadoLogin.setNombres(cst.getString(4));
                empleadoLogin.setApellidos(cst.getString(5));
                empleadoLogin.setRol(cst.getString(6));
                empleadoLogin.setIdSede(cst.getInt(7));
                empleadoLogin.setEstado("ACTIVO");
            }

        } catch (SQLException e) {
            System.err.println("Error al validar empleado (SP): " + e);
        } finally {
            cerrarRecursos();
        }
        return empleadoLogin;
    }

    /**
     * Registra un nuevo empleado (Recepcionista o Guardia) usando el SP sp_crear_empleado.
     */
    @Override
    public String registrarEmpleado(Empleado empleado, int idGerente) {
        String sql = "{CALL sp_crear_empleado(?, ?, ?, ?, ?, ?, ?, ?, ?)}";
        String mensaje = "Error desconocido.";
        
        try {
            con = cn.conectar();
            cst = con.prepareCall(sql);
            
            cst.setInt(1, idGerente);
            cst.setString(2, empleado.getDni());
            cst.setString(3, empleado.getNombres());
            cst.setString(4, empleado.getApellidos());
            cst.setString(5, empleado.getEmail());
            cst.setString(6, empleado.getRol()); // 'RECEPCIONISTA' o 'GUARDIA'
            cst.setString(7, empleado.getUsuario());
            cst.setString(8, empleado.getPassword());
            
            cst.registerOutParameter(9, java.sql.Types.VARCHAR); // p_mensaje
            
            cst.execute();
            mensaje = cst.getString(9);

        } catch (SQLException e) {
            mensaje = "Error SQL: " + e.getMessage();
            System.err.println("Error en registrarEmpleado (SP): " + e);
        } finally {
            cerrarRecursos();
        }
        return mensaje;
    }

    /**
     * Registra un nuevo Gerente usando el SP sp_crear_gerente.
     */
    @Override
    public String registrarGerente(Empleado empleado, int idAdministrador) {
        String sql = "{CALL sp_crear_gerente(?, ?, ?, ?, ?, ?, ?, ?, ?)}";
        String mensaje = "Error desconocido.";
        
        try {
            con = cn.conectar();
            cst = con.prepareCall(sql);
            
            cst.setInt(1, idAdministrador);
            cst.setInt(2, empleado.getIdSede());
            cst.setString(3, empleado.getDni());
            cst.setString(4, empleado.getNombres());
            cst.setString(5, empleado.getApellidos());
            cst.setString(6, empleado.getEmail());
            cst.setString(7, empleado.getUsuario());
            cst.setString(8, empleado.getPassword());
            
            cst.registerOutParameter(9, java.sql.Types.VARCHAR); // p_mensaje
            
            cst.execute();
            mensaje = cst.getString(9);

        } catch (SQLException e) {
            mensaje = "Error SQL: " + e.getMessage();
            System.err.println("Error en registrarGerente (SP): " + e);
        } finally {
            cerrarRecursos();
        }
        return mensaje;
    }

    /**
     * Lista todos los empleados que pertenecen a una sede específica.
     */
    @Override
    public List<Empleado> listarPorSede(int idSede) {
        List<Empleado> lista = new ArrayList<>();
        String sql = "SELECT * FROM tb_empleados WHERE id_sede = ?";
        
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idSede);
            rs = ps.executeQuery();
            
            while(rs.next()) {
                lista.add(mapearResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error en listarPorSede: " + e);
        } finally {
            cerrarRecursos();
        }
        return lista;
    }

    /**
     * Busca un empleado por su DNI.
     */
    @Override
    public Empleado buscarPorDni(String dni) {
        Empleado empleado = null;
        String sql = "SELECT * FROM tb_empleados WHERE dni = ?";
        
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            ps.setString(1, dni);
            rs = ps.executeQuery();
            
            if(rs.next()) {
                empleado = mapearResultSet(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error en buscarPorDni: " + e);
        } finally {
            cerrarRecursos();
        }
        return empleado;
    }

    /**
     * Actualiza la información básica de un empleado.
     */
    @Override
    public String actualizar(Empleado empleado) {
        String sql = "UPDATE tb_empleados SET nombres = ?, apellidos = ?, email = ? WHERE id_empleado = ?";
        String mensaje = "Error al actualizar.";
        
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            ps.setString(1, empleado.getNombres());
            ps.setString(2, empleado.getApellidos());
            ps.setString(3, empleado.getEmail());
            ps.setInt(4, empleado.getIdEmpleado());
            
            int filas = ps.executeUpdate();
            if(filas > 0) {
                mensaje = "Empleado actualizado exitosamente.";
            }
        } catch (SQLException e) {
            mensaje = "Error SQL: " + e.getMessage();
            System.err.println("Error en actualizar empleado: " + e);
        } finally {
            cerrarRecursos();
        }
        return mensaje;
    }
    
    public Empleado buscarPorId(int idEmpleado) {
        Empleado empleado = null;
        String sql = "SELECT * FROM tb_empleados WHERE id_empleado = ?";
        
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idEmpleado);
            rs = ps.executeQuery();
            
            if(rs.next()) {
                empleado = mapearResultSet(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error en buscarPorId: " + e);
        } finally {
            cerrarRecursos();
        }
        return empleado;
    }

    /**
     * Cambia el estado de un empleado ('ACTIVO' o 'INACTIVO').
     */
    @Override
    public String cambiarEstado(int idEmpleado, String nuevoEstado) {
        String sql = "UPDATE tb_empleados SET estado = ? WHERE id_empleado = ?";
        String mensaje = "Error al cambiar estado.";
        
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            ps.setString(1, nuevoEstado);
            ps.setInt(2, idEmpleado);
            
            int filas = ps.executeUpdate();
            if(filas > 0) {
                mensaje = "Estado del empleado actualizado a " + nuevoEstado;
            }
        } catch (SQLException e) {
            mensaje = "Error SQL: " + e.getMessage();
            System.err.println("Error en cambiarEstado: " + e);
        } finally {
            cerrarRecursos();
        }
        return mensaje;
    }
    
    // --- Métodos de Ayuda (Helpers) ---

    /**
     * Mapea una fila de un ResultSet a un objeto Empleado.
     */
    private Empleado mapearResultSet(ResultSet rs) throws SQLException {
        Empleado emp = new Empleado();
        emp.setIdEmpleado(rs.getInt("id_empleado"));
        emp.setIdSede(rs.getInt("id_sede"));
        emp.setDni(rs.getString("dni"));
        emp.setNombres(rs.getString("nombres"));
        emp.setApellidos(rs.getString("apellidos"));
        emp.setEmail(rs.getString("email"));
        emp.setRol(rs.getString("rol"));
        emp.setUsuario(rs.getString("usuario"));
        emp.setEstado(rs.getString("estado"));
        emp.setFechaCreacion(rs.getTimestamp("fecha_creacion"));
        // No mapeamos la contraseña por seguridad
        return emp;
    }
    
    @Override
    public List<Empleado> listarPorRol(String rol) {
        List<Empleado> lista = new ArrayList<>();
        String sql = "SELECT e.*, s.nombre as nombre_sede FROM tb_empleados e " +
                     "LEFT JOIN tb_sede s ON e.id_sede = s.id_sede " +
                     "WHERE e.rol = ?";
        
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            ps.setString(1, rol);
            rs = ps.executeQuery();
            
            while(rs.next()) {
                Empleado emp = mapearResultSet(rs);
                lista.add(emp);
            }
        } catch (SQLException e) {
            System.err.println("Error en listarPorRol: " + e);
        } finally {
            cerrarRecursos();
        }
        return lista;
    }
    
    /**
     * Cierra todas las conexiones (Connection, CallableStatement, PreparedStatement, ResultSet).
     */
    private void cerrarRecursos() {
        try {
            if (rs != null) rs.close();
            if (cst != null) cst.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            System.err.println("Error al cerrar recursos: " + e);
        }
    }
    
    
}