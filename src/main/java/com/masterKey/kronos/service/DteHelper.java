package com.masterKey.kronos.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.masterKey.kronos.model.ContadorDte.ContadorDte;
import com.masterKey.kronos.model.ContadorDte.ContadorDteId;
import com.masterKey.kronos.model.Parametro;
import com.masterKey.kronos.model.Venta;
import com.masterKey.kronos.service.ContadorDteService.ContadorDteService;
import com.masterKey.kronos.service.ParametroService.ParametroService;
import com.masterKey.kronos.service.VentaService.VentaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class DteHelper {

    private final JsonHelper jsonHelper;
    private final VentaService ventaService;
    private final ContadorDteService contadorDteService;
    private final ParametroService parametros;


    @Autowired
    public DteHelper(JsonHelper jsonHelper,
                     VentaService ventaService,
                     ContadorDteService contadorDteService,
                     ParametroService parametros) {
        this.jsonHelper = jsonHelper;
        this.ventaService = ventaService;
        this.contadorDteService = contadorDteService;
        this.parametros = parametros;
    }

    //Envia el json firmado a hacienda
    public String enviarInvalidacionMH(String jsonFirmado){
        String respuestaHacienda = "";

        ObjectMapper mapper = new ObjectMapper();
        ObjectNode jsonApi = mapper.createObjectNode();

        jsonApi.put("ambiente", parametros.findById("MH_AMBIENTE").map(Parametro::getValor).orElse("00"));
        jsonApi.put("idEnvio", 1);
        jsonApi.put("version", Integer.parseInt(parametros.findById("MH_VERSION_INVALIDACION").map(Parametro::getValor).orElse("1")));
        jsonApi.put("documento", jsonFirmado);

        System.out.println("JSON ::: " + jsonApi.toPrettyString());

        try {
            URL url = new URL(parametros.findById("MH_URL_INVALIDACION").map(Parametro::getValor).orElse("00"));
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();

            connection.setRequestMethod("POST");
            connection.setRequestProperty("Content-Type", "application/json; utf-8");
            connection.setRequestProperty("Accept", "application/json");
            connection.setRequestProperty("Authorization", parametros.findById("MH_TOKEN").map(Parametro::getValor).orElse(""));
            connection.setDoOutput(true);

            // Enviar el cuerpo de la solicitud
            String jsonInputString = jsonApi.toPrettyString();
            try (OutputStream os = connection.getOutputStream()) {
                byte[] input = jsonInputString.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            // Procesar la respuesta
            int responseCode = connection.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {
                try (BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream(), StandardCharsets.UTF_8))) {
                    StringBuilder response = new StringBuilder();
                    String inputLine;
                    while ((inputLine = in.readLine()) != null) {
                        response.append(inputLine);
                    }
                    JsonNode jsonResponse = mapper.readTree(response.toString());
                    respuestaHacienda = jsonResponse.toPrettyString();
                    //System.out.println("RESPUESTA:::" + respuestaHacienda);
                }
            } else if (responseCode == HttpURLConnection.HTTP_UNAUTHORIZED) {

                // 401 → token inválido
                String errorBody = "";

                InputStream es = connection.getErrorStream();
                if (es != null) {
                    try (BufferedReader br = new BufferedReader(
                            new InputStreamReader(es, StandardCharsets.UTF_8))) {
                        String line;
                        while ((line = br.readLine()) != null) {
                            errorBody += line;
                        }
                    }
                }

                ObjectNode error = mapper.createObjectNode();
                error.put("estado", "RECHAZADO");
                error.put("descripcionMsg", "Token inválido o expirado");
                respuestaHacienda = error.toPrettyString();

            }else{
                // Manejar errores
                StringBuilder errorResponse = new StringBuilder();
                try (BufferedReader errorStream = new BufferedReader(new InputStreamReader(connection.getErrorStream(), StandardCharsets.UTF_8))) {
                    String inputLine;
                    while ((inputLine = errorStream.readLine()) != null) {
                        errorResponse.append(inputLine);
                    }
                }

                //System.err.println("enviarLoteMH || Error en la solicitud: Código " + responseCode);
                //System.err.println("enviarLoteMH || Detalle del error: " + errorResponse);

                respuestaHacienda = errorResponse.toString();
            }

            connection.disconnect();

        } catch (Exception e) {
            e.printStackTrace();
            respuestaHacienda = "ERROR";
        }

        return respuestaHacienda;

    }
    //**************************************************************************
    //Envia el json firmado a hacienda
    public String enviarContingenciaMH(String jsonFirmado) {

        ObjectMapper mapper = new ObjectMapper();
        ObjectNode jsonApi = mapper.createObjectNode();

        jsonApi.put("nit", parametros.findById("MH_USER").map(Parametro::getValor).orElse("USER"));
        jsonApi.put("documento", jsonFirmado);

        try {
            URL url = new URL(
                    parametros.findById("MH_URL_CONTINGENCIA")
                            .map(Parametro::getValor)
                            .orElseThrow(() -> new RuntimeException("URL MH no configurada"))
            );

            HttpURLConnection connection = (HttpURLConnection) url.openConnection();

            connection.setRequestMethod("POST");
            connection.setRequestProperty("Content-Type", "application/json; utf-8");
            connection.setRequestProperty("Accept", "application/json");
            connection.setRequestProperty(
                    "Authorization",
                    parametros.findById("MH_TOKEN").map(Parametro::getValor).orElse("")
            );
            connection.setDoOutput(true);

            // Enviar cuerpo
            try (OutputStream os = connection.getOutputStream()) {
                os.write(jsonApi.toString().getBytes(StandardCharsets.UTF_8));
            }

            int responseCode = connection.getResponseCode();

            // =======================
            // ✅ RESPUESTA OK
            // =======================
            if (responseCode == HttpURLConnection.HTTP_OK) {
                try (BufferedReader in = new BufferedReader(
                        new InputStreamReader(connection.getInputStream(), StandardCharsets.UTF_8))) {

                    String response = in.lines().collect(Collectors.joining());
                    return mapper.readTree(response).toPrettyString();
                }
            }

            // =======================
            // 🔐 ERROR 401
            // =======================
            if (responseCode == HttpURLConnection.HTTP_UNAUTHORIZED) {
                ObjectNode error401 = mapper.createObjectNode();
                error401.put("estado", "RECHAZADO");
                error401.put("codigo", 401);
                error401.put("mensaje", "Token MH inválido o expirado");
                return error401.toPrettyString();
            }

            // =======================
            // ⚠️ OTROS ERRORES
            // =======================
            try (BufferedReader errorStream = new BufferedReader(
                    new InputStreamReader(connection.getErrorStream(), StandardCharsets.UTF_8))) {

                String errorResponse = errorStream.lines().collect(Collectors.joining());
                return mapper.readTree(errorResponse).toPrettyString();
            }

        } catch (Exception e) {
            ObjectNode error = mapper.createObjectNode();
            error.put("estado", "RECHAZADO");
            error.put("mensaje", e.getMessage());
            return error.toPrettyString();
        }
    }

    //**************************************************************************
    //Enviando a hacienda el Json Firmado y devolviendo la respuesta para ser tratada
    public String enviarDocumentoMH(String jsonFirmado, Long codigoVenta) {

        Venta venta = ventaService.findById(codigoVenta);

        ObjectMapper mapper = new ObjectMapper();
        ObjectNode jsonApi = mapper.createObjectNode();

        jsonApi.put("ambiente", parametros.findById("MH_AMBIENTE").map(Parametro::getValor).orElse("00"));
        jsonApi.put("idEnvio", 1);
        jsonApi.put("version", venta.getTipoDocumento().getVersionDte());
        jsonApi.put("tipoDte", venta.getTipoDocumento().getId());
        jsonApi.put("documento", jsonFirmado);

        try {
            URL url = new URL(
                    parametros.findById("MH_URL_ENVIO_DTE")
                            .map(Parametro::getValor)
                            .orElseThrow(() -> new RuntimeException("URL MH no configurada"))
            );

            HttpURLConnection connection = (HttpURLConnection) url.openConnection();

            connection.setRequestMethod("POST");
            connection.setRequestProperty("Content-Type", "application/json; utf-8");
            connection.setRequestProperty("Accept", "application/json");
            connection.setRequestProperty(
                    "Authorization",
                    parametros.findById("MH_TOKEN").map(Parametro::getValor).orElse("")
            );
            connection.setDoOutput(true);

            // Enviar cuerpo
            try (OutputStream os = connection.getOutputStream()) {
                os.write(jsonApi.toString().getBytes(StandardCharsets.UTF_8));
            }

            int responseCode = connection.getResponseCode();

            // =======================
            // ✅ RESPUESTA OK
            // =======================
            if (responseCode == HttpURLConnection.HTTP_OK) {
                try (BufferedReader in = new BufferedReader(
                        new InputStreamReader(connection.getInputStream(), StandardCharsets.UTF_8))) {

                    String response = in.lines().collect(Collectors.joining());
                    return mapper.readTree(response).toPrettyString();
                }
            }

            // =======================
            // 🔐 ERROR 401
            // =======================
            if (responseCode == HttpURLConnection.HTTP_UNAUTHORIZED) {
                ObjectNode error401 = mapper.createObjectNode();
                error401.put("estado", "RECHAZADO");
                error401.put("codigo", 401);
                error401.put("descripcionMsg", "Token MH inválido o expirado");
                error401.put("venta", codigoVenta);
                return error401.toPrettyString();
            }

            // =======================
            // ⚠️ OTROS ERRORES
            // =======================
            try (BufferedReader errorStream = new BufferedReader(
                    new InputStreamReader(connection.getErrorStream(), StandardCharsets.UTF_8))) {

                String errorResponse = errorStream.lines().collect(Collectors.joining());
                return mapper.readTree(errorResponse).toPrettyString();
            }

        } catch (Exception e) {
            ObjectNode error = mapper.createObjectNode();
            error.put("estado", "RECHAZADO");
            error.put("descripcionMsg", "Error al enviar DTE: " + e.getMessage());
            error.put("venta", codigoVenta);
            return error.toPrettyString();
        }
    }

    //**************************************************************************
    //Obteniendo el token MH
    public String obtenerTokenMH() {
        String tokenMH = "";
        String user = parametros.findById("MH_USER")
                .map(Parametro::getValor)
                .orElse("<USER>") ;
        String pwd = parametros.findById("MH_PASS")
                .map(Parametro::getValor)
                .orElse("<PASSWORD>");


        ObjectMapper mapper = new ObjectMapper();

        try {
            // URL para la solicitud HTTP
            String urlStr = parametros.findById("MH_URL_TOKEN")
                    .map(Parametro::getValor)
                    .orElse("https://apitest.dtes.mh.gob.sv/seguridad/auth");

            URL url = new URL(urlStr);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();

            // Configuración de la conexión HTTP
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded; utf-8");
            connection.setRequestProperty("Accept", "application/json");
            connection.setDoOutput(true);

            // Parámetros de la solicitud
            String urlParameters = "user=" + URLEncoder.encode(user, "UTF-8") +
                    "&pwd=" + URLEncoder.encode(pwd, "UTF-8");

            // Enviar la solicitud
            try (OutputStream os = connection.getOutputStream()) {
                byte[] input = urlParameters.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            // Procesar la respuesta
            int responseCode = connection.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {
                BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream(), StandardCharsets.UTF_8));
                StringBuilder response = new StringBuilder();
                String inputLine;
                while ((inputLine = in.readLine()) != null) {
                    response.append(inputLine);
                }
                in.close();

                // Parsear la respuesta JSON
                JsonNode jsonResponse = mapper.readTree(response.toString());
                tokenMH = jsonResponse.path("body").path("token").asText();

            } else {
                System.out.println("Error en la solicitud: " + responseCode);
                tokenMH = "ERROR";
            }

            connection.disconnect();

        } catch (Exception e) {
            tokenMH = "ERROR";
            e.printStackTrace();
        }

        return tokenMH;
    }
    //**************************************************************************
    //Firmando el JSON generado
    public String firmarJson(String jsonVenta) throws JsonProcessingException {

        //System.out.println(jsonVenta);
        String jsonFirmado = "";
        ObjectMapper mapper = new ObjectMapper();

        // Crear el objeto JSON a enviar
        ObjectNode jsonApi = mapper.createObjectNode();
        jsonApi.put("nit", parametros.findById("MH_USER").map(Parametro::getValor).orElse("USER"));
        jsonApi.put("activo", true);
        jsonApi.put("passwordPri", parametros.findById("MH_PASS_PRIV").map(Parametro::getValor).orElse("PASS"));
        // Agregar el JSON de la venta
        JsonNode objetoJsonVenta = mapper.readTree(jsonVenta);
        jsonApi.set("dteJson", objetoJsonVenta);

        try {
            // Preparar la conexión HTTP
            String urlFirmador = parametros.findById("MH_URL_FIRMADOR").map(Parametro::getValor).orElse("FIRMADOR");
            System.out.println("urlFirmador: " + urlFirmador);
            URL url = new URL(urlFirmador);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();

            connection.setRequestMethod("POST");
            connection.setRequestProperty("Content-Type", "application/json; utf-8");
            connection.setRequestProperty("Accept", "application/json");
            connection.setDoOutput(true);

            // Enviar el JSON al firmador
            try (OutputStream os = connection.getOutputStream()) {
                byte[] input = jsonApi.toString().getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            // Leer la respuesta del firmador
            int responseCode = connection.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {
                try (BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream(), StandardCharsets.UTF_8))) {
                    StringBuilder response = new StringBuilder();
                    String inputLine;
                    while ((inputLine = in.readLine()) != null) {
                        response.append(inputLine);
                    }

                    // Procesar la respuesta JSON
                    JsonNode jsonResponse = mapper.readTree(response.toString());
                    jsonFirmado = jsonResponse.path("body").asText();

                    if (jsonFirmado.isEmpty()) {
                        System.out.println("Error en HelperDte/firmarJson(): El campo 'body' está vacío.");
                        jsonFirmado = "ERROR";
                    }
                }
            } else {
                System.out.println("Error en la solicitud al firmador: Código " + responseCode);
                jsonFirmado = "ERROR";
            }

            connection.disconnect();
        } catch (Exception e) {
            e.printStackTrace();
            jsonFirmado = "ERROR";
        }

        return jsonFirmado;
    }
    //**************************************************************************
    //Seteando el numero control sino tiene la venta
    public void setearNumeroControl(Long idVenta){
        Venta venta = ventaService.findById(idVenta);
        System.out.println("Verificando si tiene numero de control...");
        if(venta.getNumeroControl() == null){
            System.out.println("NO TIENE NUMERO DE CONTROL, se va  a generar uno nuevo...");

            ContadorDteId contadorDteId = new ContadorDteId(
                    venta.getTipoDocumento().getId().toString(),
                    venta.getFecha().getYear(),
                    venta.getUsuario().getCaja().getSucursal().getId().intValue());

            Optional<ContadorDte> opt = contadorDteService.findById(contadorDteId);
            ContadorDte contadorDte = new ContadorDte();

            if(opt.isEmpty()){
                ContadorDte contadorDteNuevo = new ContadorDte();
                contadorDteNuevo.setTipoDocumentoId(venta.getTipoDocumento().getId());
                contadorDteNuevo.setContador(1);
                contadorDteNuevo.setAnio(venta.getFecha().getYear());
                contadorDteNuevo.setSucursalId(venta.getUsuario().getCaja().getSucursal().getId().intValue());
                contadorDteService.save(contadorDteNuevo);
                contadorDte = contadorDteNuevo;
            }else{
                contadorDte = opt.get();
                contadorDte.setContador(contadorDte.getContador() + 1);
                contadorDteService.save(contadorDte);
            }

            String tipoDocDte = venta.getTipoDocumento().getId();
            String estableMh = venta.getUsuario().getCaja().getSucursal().getEstablecimientoMh();
            String puntoMh = venta.getUsuario().getCaja().getPuntoVentaMh();
            String numero = String.format("%015d", contadorDte.getContador());

            String numeroControl = "DTE-"+tipoDocDte+"-"+estableMh+puntoMh+"-"+numero;

            venta.setNumeroControl(numeroControl);
            ventaService.save(venta);
            System.out.println("Numero de control generado: " + venta.getNumeroControl());
        }else{
            System.out.println("TIENE NUMERO DE CONTROL, NO HACE NADA");
        }
    }
    //**************************************************************************
    //Seteando el codigo generacion sino tiene la venta
    public void setearCodigoGeneracion(Long idVenta){
        Venta venta = ventaService.findById(idVenta);
        System.out.println("Verificando si tiene codigo generacion...");
        if(venta.getCodigoGeneracion() == null){
            System.out.println("NO TIENE CODIGO GENERACIO0N, se va  a generar uno nuevo...");
            UUID uuid = UUID.randomUUID();
            venta.setCodigoGeneracion(uuid.toString().toUpperCase());
            ventaService.save(venta);
            System.out.println("Codigo generacion generado: " + venta.getCodigoGeneracion());
        }else{
            System.out.println("TIENE CODIGO GENERACION, NO HACE NADA");
        }

    }

}
