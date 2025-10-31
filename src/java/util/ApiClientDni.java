/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import com.google.gson.Gson;
import com.google.gson.annotations.SerializedName; // <-- ¡Importante!
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import modelo.Cliente;

public class ApiClientDni {

    // RECUERDA: Este token debe ser el tuyo, uno válido.
    private static final String TOKEN = "sk_10666.6qrKjQbhjgKZpMH9rjMDfL6h6pOY84mt";

    public Cliente consultarDni(String dni) {
        
        Cliente clienteRespuesta = null;

        try {
            String url = "https://api.decolecta.com/v1/reniec/dni?numero=" + dni;

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(url))
                    .header("Accept", "application/json")
                    .header("Authorization", "Bearer " + TOKEN)
                    .GET()
                    .build();

            HttpClient client = HttpClient.newHttpClient();
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

            // Ya no necesitamos la línea de depuración, la podemos quitar.
            // System.out.println("Respuesta JSON de la API: " + response.body());

            if (response.statusCode() == 200) {
                Gson gson = new Gson();
                // Gson ahora usará las anotaciones @SerializedName para mapear correctamente
                ApiResponseReniec apiResponse = gson.fromJson(response.body(), ApiResponseReniec.class);

                clienteRespuesta = new Cliente();
                // Usamos los nuevos getters para asignar los datos
                clienteRespuesta.setNombres(apiResponse.getFirstName());
                clienteRespuesta.setApellidos(apiResponse.getFirstLastName() + " " + apiResponse.getSecondLastName());
                clienteRespuesta.setDni(apiResponse.getDocumentNumber());
            } else {
                System.err.println("La API externa devolvió un error: " + response.statusCode());
                System.err.println("Cuerpo del error: " + response.body());
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return clienteRespuesta;
    }

    // ======================================================================
    // ==== CLASE INTERNA ACTUALIZADA PARA COINCIDIR CON EL JSON REAL =====
    // ======================================================================
    private static class ApiResponseReniec {
        
        @SerializedName("first_name")
        private String firstName;
        
        @SerializedName("first_last_name")
        private String firstLastName;
        
        @SerializedName("second_last_name")
        private String secondLastName;
        
        @SerializedName("document_number")
        private String documentNumber;

        // Getters actualizados a los nuevos nombres de variables
        public String getFirstName() { return firstName; }
        public String getFirstLastName() { return firstLastName; }
        public String getSecondLastName() { return secondLastName; }
        public String getDocumentNumber() { return documentNumber; }
    }
}