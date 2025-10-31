/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modeloDAO;

import config.Conexion;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import modelo.Espacio; // Necesario para anidar
import modelo.HistorialEntry;
import modelo.RegistroEntrada;
import modelo.RegistroEstacionamiento; // Modelo que crearemos ahora
import modelo.Vehiculo; // Necesario para anidar

public class EstacionamientoDAO {
    
    PreparedStatement ps;
    Conexion cn = new Conexion();
    Connection con;
    CallableStatement cst;
    ResultSet rs; 

    /**
     * Llama al SP sp_registrar_entrada_vehiculo.
     */
    public String registrarEntrada(RegistroEntrada entrada) {
        String sql = "{CALL sp_registrar_entrada_vehiculo(?, ?, ?, ?, ?, ?, ?)}";
        String mensaje = "Error desconocido.";

        try {
            con = cn.conectar();
            cst = con.prepareCall(sql);
            cst.setString(1, entrada.getPlaca());
            cst.setString(2, entrada.getDniConductor());
            cst.setInt(3, entrada.getIdRecepcionista());
            cst.setInt(4, entrada.getIdEspacio());
            cst.setString(5, entrada.getEmailConductor());

            cst.registerOutParameter(6, java.sql.Types.VARCHAR); // p_pin_generado
            cst.registerOutParameter(7, java.sql.Types.VARCHAR); // p_mensaje

            cst.execute();

            String pin = cst.getString(6);
            mensaje = cst.getString(7);

            if (pin != null && !pin.isEmpty()) {
                mensaje += " | PIN de Retiro: " + pin;
            }

        } catch (SQLException e) {
            mensaje = "Error SQL: " + e.getMessage();
            System.err.println("Error en EstacionamientoDAO.registrarEntrada (SP): " + e);
        } finally {
            cerrarRecursos(); // Usamos un método helper para cerrar
        }
        return mensaje;
    }

    /**
     * Llama al SP sp_buscar_registro_activo por PIN o Placa.
     * Retorna un objeto RegistroEstacionamiento con los datos necesarios
     * para calcular el pago y mostrar la info, o null si no se encuentra.
     */
    public RegistroEstacionamiento buscarRegistroActivo(String placaOPin) {
    RegistroEstacionamiento reg = null;
    String sql = "{CALL sp_buscar_registro_activo(?)}";

    if (placaOPin == null || placaOPin.trim().isEmpty()) {
        System.err.println("⚠️ Error: placaOPin es nulo o vacío en buscarRegistroActivo()");
        return null;
    }

    try {
        con = cn.conectar();
        cst = con.prepareCall(sql);
        cst.setString(1, placaOPin.trim().toUpperCase());
        rs = cst.executeQuery(); // Este SP devuelve filas

        if (rs.next()) {
            reg = new RegistroEstacionamiento();
            reg.setIdRegistro(rs.getInt("id_registro"));
            reg.setHoraEntrada(rs.getTimestamp("hora_entrada"));
            reg.setPinTemp(rs.getString("pin_temp"));
            reg.setTarifaBaseSede(rs.getDouble("tarifa_base"));
            reg.setMinutosTranscurridos(rs.getLong("minutos_transcurridos"));
            reg.setDniConductor(rs.getString("dni_conductor"));
            reg.setEmailConductor(rs.getString("email_conductor"));

            Vehiculo v = new Vehiculo();
            v.setPlaca(rs.getString("placa"));
            v.setMarca(rs.getString("marca"));
            v.setModelo(rs.getString("modelo"));
            reg.setVehiculo(v);

            Espacio e = new Espacio();
            e.setNumeroEspacio(rs.getString("numero_espacio"));
            e.setNombrePiso(rs.getString("nombre_piso"));
            reg.setEspacio(e);
        }

    } catch (SQLException e) {
        System.err.println("❌ Error SQL en EstacionamientoDAO.buscarRegistroActivo: " + e.getMessage());
    } catch (Exception e) {
        System.err.println("❌ Error general en EstacionamientoDAO.buscarRegistroActivo: " + e);
        e.printStackTrace();
    } finally {
        cerrarRecursos();
    }

    return reg;
}
    
    /**
     * Llama al SP sp_registrar_pago_y_salida.
     * Retorna el mensaje de éxito (con el vuelto) o de error del SP.
     */
    public String registrarPagoYSalida(int idRegistro, int idEmpleadoSalida, double montoTotal, double montoRecibido) {
        String sql = "{CALL sp_registrar_pago_y_salida(?, ?, ?, ?, ?, ?)}";
        String mensaje = "Error desconocido.";
        String metodoPago = "EFECTIVO"; // Por ahora fijo

        try {
            con = cn.conectar();
            cst = con.prepareCall(sql);
            cst.setInt(1, idRegistro);
            cst.setInt(2, idEmpleadoSalida);
            cst.setDouble(3, montoTotal);
            cst.setDouble(4, montoRecibido);
            cst.setString(5, metodoPago);

            cst.registerOutParameter(6, java.sql.Types.VARCHAR); // p_mensaje

            cst.execute();
            mensaje = cst.getString(6);

        } catch (SQLException e) {
            mensaje = "Error SQL: " + e.getMessage();
            System.err.println("Error en EstacionamientoDAO.registrarPagoYSalida (SP): " + e);
        } finally {
            cerrarRecursos();
        }
        return mensaje;
    }
    
    public List<HistorialEntry> obtenerHistorialCliente(int idCliente) {
        List<HistorialEntry> historial = new ArrayList<>();
        // Unimos registro, vehículo, propietario y pago
        String sql = "SELECT r.id_registro, v.placa, v.marca, v.modelo, r.hora_entrada, r.hora_salida, p.monto_total, p.fecha_pago " +
                     "FROM tb_registro_estacionamiento r " +
                     "JOIN tb_vehiculo v ON r.id_vehiculo = v.id_vehiculo " +
                     "JOIN tb_usuarios_web u ON v.id_propietario = u.id_usuario " +
                     "LEFT JOIN tb_pagos p ON r.id_registro = p.id_registro " + // LEFT JOIN por si no hay pago (raro)
                     "WHERE u.id_usuario = ? AND r.estado = 'FINALIZADO' " +
                     "ORDER BY r.hora_salida DESC"; // Más recientes primero

        try {
            con = cn.conectar();
            ps = con.prepareStatement(sql); // Usamos PreparedStatement para esta consulta
            ps.setInt(1, idCliente);
            rs = ps.executeQuery();

            while (rs.next()) {
                HistorialEntry entry = new HistorialEntry();
                entry.setIdRegistro(rs.getInt("id_registro"));
                entry.setPlacaVehiculo(rs.getString("placa"));
                entry.setMarcaModeloVehiculo(rs.getString("marca") + " " + rs.getString("modelo"));
                entry.setHoraEntrada(rs.getTimestamp("hora_entrada"));
                entry.setHoraSalida(rs.getTimestamp("hora_salida"));
                entry.setMontoPagado(rs.getDouble("monto_total"));
                entry.setFechaPago(rs.getTimestamp("fecha_pago"));
                historial.add(entry);
            }
        } catch (SQLException e) {
            System.err.println("Error en EstacionamientoDAO.obtenerHistorialCliente: " + e);
        } finally {
            cerrarRecursos(); // Asegúrate que cerrarRecursos() cierre también 'ps'
        }
        return historial;
    }

    // Método helper para cerrar recursos
    private void cerrarRecursos() {
        try {
            if (rs != null) rs.close();
            if (cst != null) cst.close();
            if (con != null) con.close();
            if (ps != null) ps.close();
        } catch (SQLException e) {
            System.err.println("Error al cerrar recursos: " + e);
        }
    }
}