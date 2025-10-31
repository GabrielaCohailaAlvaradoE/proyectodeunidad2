/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {
    Connection con;
    
    String url = "jdbc:mysql://34.134.69.177:3306/resguardabd?useSSL=false&serverTimezone=UTC";

    String user = "roberto";
    String pass = "Upt2025@";

    public Connection conectar() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);
            System.out.println("¡Conexión a Cloud SQL exitosa!"); 
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("Error en la conexión: " + e.getMessage());
        }
        return con;
    }   
}