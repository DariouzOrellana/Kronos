package com.masterKey.kronos.controller;


import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.masterKey.kronos.model.*;
import com.masterKey.kronos.service.HelperService.HelperService;
import com.masterKey.kronos.service.InvalidacionService.InvalidacionService;
import com.masterKey.kronos.service.SenderHelper;
import com.masterKey.kronos.service.TipoInvalidacionService.TipoInvalidacionService;
import com.masterKey.kronos.service.VentaService.VentaService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Controller
@RequestMapping("/anulacion")
public class AnulacionController extends BaseController{

    private final HelperService helperService;
    private final VentaService ventaService;
    private final TipoInvalidacionService tipoInvalidacionService;
    private final InvalidacionService invalidacionService;
    private final SenderHelper senderHelper;

    @Autowired
    public AnulacionController(
            HelperService helperService,
            VentaService ventaService,
            TipoInvalidacionService tipoInvalidacionService,
            InvalidacionService invalidacionService,
            SenderHelper senderHelper) {
        this.helperService = helperService;
        this.ventaService = ventaService;
        this.tipoInvalidacionService = tipoInvalidacionService;
        this.invalidacionService = invalidacionService;
        this.senderHelper = senderHelper;
    }

    @GetMapping()
    public String verAnulaciones(Model model, HttpSession session){

        List<Invalidacion> invalidaciones = invalidacionService.findAll();

        model.addAttribute("title", "Anulaciones");
        model.addAttribute("invalidaciones", invalidaciones);


        return "invalidaciones/ver_invalidaciones";
    }

    @PostMapping("/{id}/procesarDte")
    @ResponseBody
    public ResponseEntity<?> procesarAnulacion(
            @PathVariable("id") Long id,
            HttpSession session
    ){
        Map<String, Object> res = new HashMap<>();
        try {
            String respuesta = senderHelper.enviarAnulacion(id);
            ObjectMapper mapper = new ObjectMapper();
            Map<String, Object> respuestaObj = mapper.readValue(respuesta, new TypeReference<>() {});
            res.put("ok", true);
            res.put("message", "Anulación procesada exitosamente");
            res.put("respuestaMh", respuestaObj);

        }catch ( Exception ex ){
            res.put("ok", false);
            res.put("message", "Error al enviar la Anulación: " + ex.getMessage());
            return ResponseEntity.internalServerError().body(res);
        }
        return ResponseEntity.ok(res);
    }

    @PostMapping("/guardar")
    public ResponseEntity<?> guardarAnulacion(
            @RequestBody Map<String, Object> payload,
            HttpSession session
    ){
        Usuario userAuth = (Usuario) session.getAttribute("userAuth");

        Map<String, Object> res = new HashMap<>();
        try {
            if(payload.isEmpty()){
                res.put("ok", false);
                res.put("message", "El payload esta vacio");
                return ResponseEntity.badRequest().body(res);
            }

            if(payload.get("venta_id").toString().isEmpty()){
                res.put("ok", false);
                res.put("message", "El ID de la venta a anular está vacio");
                return ResponseEntity.badRequest().body(res);
            }

            Long ventaId = Long.parseLong(payload.get("venta_id").toString());

            Venta venta = ventaService.findById(ventaId);

            if(venta == null){
                res.put("ok", false);
                res.put("message", "La venta con el ID " + ventaId + " no existe");
                return ResponseEntity.badRequest().body(res);
            }

            Long tipoInvalidacionId = Long.parseLong(payload.get("tipo_anulacion_id").toString());

            TipoInvalidacion tipoInvalidacion = tipoInvalidacionService.findById(tipoInvalidacionId).get();

            if (tipoInvalidacion == null) {
                res.put("ok", false);
                res.put("message", "El tip anulacion con el ID " + tipoInvalidacionId + " no existe");
                return ResponseEntity.badRequest().body(res);
            }

            Invalidacion invalidacion = invalidacionService.findByVentaId(ventaId);

            if(invalidacion == null){
                invalidacion = new Invalidacion();
                invalidacion.setCodigoGeneracion(helperService.getUID());
                invalidacion.setVenta(venta);
            }

            invalidacion.setTipoAnulacion(tipoInvalidacion);
            invalidacion.setMotivoAnulacion(payload.get("motivo_anulacion").toString());
            invalidacion.setNombreResponsable(userAuth.getCaja().getSucursal().getEmpresa().getRepresentanteLegal());
            invalidacion.setTipDocResponsable("36");
            invalidacion.setNumDocResponsable(userAuth.getCaja().getSucursal().getEmpresa().getNit());
            invalidacion.setNombreSolicita(payload.get("nombre_solicita").toString());

            String tipoDocSolicita = "13";

            switch (payload.get("tipo_doc_solicita").toString()){
                case "DUI":
                    tipoDocSolicita = "13";
                    break;
                case "NIT":
                        tipoDocSolicita = "36";
                    break;
                default:
                    tipoDocSolicita = "13";
                    break;
            }

            invalidacion.setTipDocSolicita(tipoDocSolicita);
            invalidacion.setNumDocSolicita(payload.get("num_doc_solicita").toString());
            invalidacion.setFecAnula(LocalDate.now());
            Invalidacion inv = invalidacionService.save(invalidacion);

            String respuestaMh = senderHelper.enviarAnulacion(ventaId);

            ObjectMapper mapper = new ObjectMapper();
            Map<String, Object> respuestaMhObj =
                    mapper.readValue(respuestaMh, new TypeReference<>() {});

            res.put("ok", true);
            res.put("message", "Anulacion guardada exitosamente");
            res.put("respuestaMh", respuestaMhObj);

            return ResponseEntity.ok(res);
        } catch (Exception ex) {
            res.put("ok", false);
            res.put("message", "Error al guardar la anulación: " + ex.getMessage());
            ex.printStackTrace();
            return ResponseEntity.internalServerError().body(res);
        }
    }
}
