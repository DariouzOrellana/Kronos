package com.masterKey.kronos.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.masterKey.kronos.model.*;
import com.masterKey.kronos.service.ContingenciaService.ContingenciaService;
import com.masterKey.kronos.service.InvalidacionService.InvalidacionService;
import com.masterKey.kronos.service.ParametroService.ParametroService;
import com.masterKey.kronos.service.RespuestaDteMhService.RespuestaDteMhService;
import com.masterKey.kronos.service.VentaService.VentaService;
import org.apache.catalina.mapper.Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.tags.Param;

import java.time.LocalDateTime;

@Service
public class SenderHelper {

    private final JsonHelper jsonHelper;
    private final DteHelper dteHelper;
    private final ParametroService  parametros;
    private final VentaService ventaService;
    private final InvalidacionService invalidacionService;
    private final ContingenciaService contingenciaService;
    private final RespuestaDteMhService respuestaDteMhService;
    private final EmailService emailService;

    @Autowired
    public SenderHelper(JsonHelper jsonHelper,
                        DteHelper dteHelper,
                        ParametroService parametros,
                        VentaService ventaService,
                        InvalidacionService invalidacionService,
                        RespuestaDteMhService respuestaDteMhService,
                        ContingenciaService contingenciaService,
                        EmailService emailService) {
        this.jsonHelper = jsonHelper;
        this.dteHelper = dteHelper;
        this.parametros = parametros;
        this.ventaService = ventaService;
        this.invalidacionService = invalidacionService;
        this.respuestaDteMhService = respuestaDteMhService;
        this.contingenciaService = contingenciaService;
        this.emailService = emailService;
    }

    public String enviarContingencia(Long idContingencia) throws JsonProcessingException {

        Contingencia contingencia = contingenciaService.findById(idContingencia);

        String json = jsonHelper.generarContingenciaJson(idContingencia);

        System.out.println("JSON GENERADO");
        System.out.println("==========================================================");
        System.out.println(json);
        String jsonFimado = dteHelper.firmarJson(json);
        System.out.println("JSON FIRMADO");
        System.out.println(jsonFimado);


        String respuesta = dteHelper.enviarContingenciaMH(jsonFimado);
        System.out.println("==========================================================");
        System.out.println("RESPUESTA MH");
        System.out.println(respuesta);
        System.out.println("==========================================================");

        ObjectMapper mapper = new ObjectMapper();
        JsonNode respuestaMH = mapper.readTree(respuesta);

        if(respuestaMH.get("estado").asText().equals("RECIBIDO")){
            contingencia.setSelloContingencia(respuestaMH.get("selloRecibido").asText());
        }
        contingenciaService.save(contingencia);

        return respuesta;
    }

    public String enviarAnulacion(Long idVenta) throws JsonProcessingException {
        Invalidacion invalidacion = invalidacionService.findByVentaId(idVenta);

        String json = jsonHelper.generarInvalidacion_Json(idVenta);

        System.out.println("JSON GENERADO");
        System.out.println("==========================================================");
        System.out.println(json);
        String jsonFimado = dteHelper.firmarJson(json);
        System.out.println("JSON FIRMADO");
        System.out.println(jsonFimado);


        String respuesta = dteHelper.enviarInvalidacionMH(jsonFimado);
        System.out.println("==========================================================");
        System.out.println("RESPUESTA MH");
        System.out.println(respuesta);
        System.out.println("==========================================================");

        ObjectMapper mapper = new ObjectMapper();
        JsonNode respuestaMH = mapper.readTree(respuesta);

        if(respuestaMH.get("estado").asText().equals("PROCESADO")){
            invalidacion.setSelloInvalidacion(respuestaMH.get("selloRecibido").asText());
            invalidacionService.save(invalidacion);
            Venta venta = ventaService.findById(idVenta);
            venta.setCodigoGeneracionAnulacion(invalidacion.getCodigoGeneracion());
            venta.setEstado(0);
            ventaService.save(venta);
        }


        return respuesta;
    }

    public String enviarDte(Long idVenta) throws Exception {
        dteHelper.setearCodigoGeneracion(idVenta);
        dteHelper.setearNumeroControl(idVenta);

        String idFactura = parametros.findById("ID_FACTURA").map(Parametro::getValor).orElse("01");
        String idCff = parametros.findById("ID_CCF").map(Parametro::getValor).orElse("03");
        String idNc = parametros.findById("ID_NC").map(Parametro::getValor).orElse("05");

        Venta venta = ventaService.findById(idVenta);

        String json = "";

        if(venta.getTipoDocumento().getId().equals(idFactura)){
            json = jsonHelper.generarJsonFac(idVenta);
        }
        if(venta.getTipoDocumento().getId().equals(idCff)){
            json = jsonHelper.generarJsonCff(idVenta);
        }
        if(venta.getTipoDocumento().getId().equals(idNc)){
            json = jsonHelper.generarJsonNc(idVenta);
        }
        System.out.println("JSON GENERADO");
        System.out.println("==========================================================");
        System.out.println(json);
        String jsonFimado = dteHelper.firmarJson(json);
        System.out.println("JSON FIRMADO");
        System.out.println(jsonFimado);


        String respuesta = dteHelper.enviarDocumentoMH(jsonFimado, idVenta);
        System.out.println("==========================================================");
        System.out.println("RESPUESTA MH");
        System.out.println(respuesta);
        System.out.println("==========================================================");

        ObjectMapper mapper = new ObjectMapper();
        JsonNode respuestaMH = mapper.readTree(respuesta);

        //Lo primero que se hace es guardar la respuesta de la venta
        RespuestaDteMh respuestaDte = new RespuestaDteMh();
        respuestaDte.setIdVenta(idVenta);
        respuestaDte.setEstado(respuestaMH.get("estado").asText());
        respuestaDte.setRespuesta(respuesta);
        respuestaDte.setJsonEnviado(json);
        respuestaDte.setFirma(jsonFimado);
        respuestaDte.setSelloMh(respuestaMH.get("estado").asText() == "PROCESADO" ? respuestaMH.get("selloRecibido").asText() : null);
        respuestaDte.setFecha(LocalDateTime.now());
        respuestaDteMhService.save(respuestaDte);

        if(respuestaMH.get("estado").asText().equals("RECHAZADO")){
            venta.setIntentos(venta.getIntentos()+1);
        }else if(respuestaMH.get("estado").asText().equals("PROCESADO")){
            ObjectMapper mapperJson = new ObjectMapper();
            JsonNode jsonNode = mapperJson.readTree(json);

            if(!jsonNode.get("receptor").get("correo").asText().isEmpty()){
                emailService.enviarCorreo(idVenta, jsonNode.get("receptor").get("correo").asText());
            }

            venta.setSelloMh(respuestaMH.get("selloRecibido").asText());
            //venta.setContingencia(0);
            //venta.setCodigoGeneracionAnulacion(null);
            //venta.setCodigoGeneracionContingencia(null);
            venta.setEstado(1);
            venta.setContingencia(null);
        }
        ventaService.save(venta);

        return respuesta;
    }

}
