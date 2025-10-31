/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modeloDAO;

import config.Conexion;
import interfaces.CRUDCliente;
import java.sql.Connection;
import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import modelo.Cliente;

public class ClienteDAO implements CRUDCliente {

    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;
    CallableStatement cst;
    Cliente cliente = new Cliente();

    @Override
    public boolean registrar(Cliente cliente) {
        String sql = "{CALL sp_registrar_cliente_web(?, ?, ?, ?, ?, ?, ?)}";
        String mensajeRespuesta = "";

        try {
            con = cn.conectar();
            cst = con.prepareCall(sql);

            cst.setString(1, cliente.getDni());
            cst.setString(2, cliente.getNombres());
            cst.setString(3, cliente.getApellidos());
            cst.setDate(4, new java.sql.Date(cliente.getFechaNacimiento().getTime()));
            cst.setString(5, cliente.getEmail());
            cst.setString(6, cliente.getPassword());

            cst.registerOutParameter(7, java.sql.Types.VARCHAR);

            cst.execute();

            mensajeRespuesta = cst.getString(7);

            System.out.println("Mensaje del SP (Registro): " + mensajeRespuesta);

            return mensajeRespuesta.contains("exitosamente");

        } catch (SQLException e) {
            System.err.println("Error al registrar cliente (SP): " + e);
            return false;
        } finally {
            try {
                if (cst != null) cst.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                System.err.println("Error al cerrar conexión: " + e);
            }
        }
    }

    @Override
    public Cliente validar(String dni, String password) {
        Cliente clienteLogin = null;
        String sql = "{CALL sp_login_cliente_web(?, ?, ?, ?, ?, ?, ?)}";

        try {
            con = cn.conectar();
            cst = con.prepareCall(sql);

            cst.setString(1, dni);
            cst.setString(2, password);

            cst.registerOutParameter(3, java.sql.Types.INTEGER);
            cst.registerOutParameter(4, java.sql.Types.VARCHAR);
            cst.registerOutParameter(5, java.sql.Types.VARCHAR);
            cst.registerOutParameter(6, java.sql.Types.VARCHAR);
            cst.registerOutParameter(7, java.sql.Types.VARCHAR);

            cst.execute();

            String mensaje = cst.getString(7);
            System.out.println("Mensaje del SP (Login): " + mensaje);

            if ("Login exitoso".equals(mensaje)) {
                clienteLogin = new Cliente();
                clienteLogin.setIdUsuario(cst.getInt(3));
                clienteLogin.setDni(dni);
                clienteLogin.setNombres(cst.getString(4));
                clienteLogin.setApellidos(cst.getString(5));
                clienteLogin.setEmail(cst.getString(6));
                clienteLogin.setEstado("ACTIVO");
            }

        } catch (SQLException e) {
            System.err.println("Error al validar cliente (SP): " + e);
        } finally {
            try {
                if (cst != null) cst.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                System.err.println("Error al cerrar conexión: " + e);
            }
        }
        return clienteLogin;
    }

    @Override
    public boolean verificarExistencia(String dni, String email) {
        String sql = "SELECT dni FROM tb_usuarios_web WHERE dni = ? OR email = ?";
        
        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql);
            ps.setString(1, dni);
            ps.setString(2, email);
            rs = ps.executeQuery();

            return rs.next();

        } catch (SQLException e) {
            System.err.println("Error al verificar existencia: " + e);
            return true;
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                System.err.println("Error al cerrar conexión: " + e);
            }
        }
    }
}