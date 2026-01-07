package com.masterKey.kronos.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.masterKey.kronos.model.*;
import com.masterKey.kronos.service.ContingenciaService.ContingenciaService;
import com.masterKey.kronos.service.ParametroService.ParametroService;
import com.masterKey.kronos.service.SenderHelper;
import com.masterKey.kronos.service.TipoContingenciaService.TipoContingenciaService;
import com.masterKey.kronos.service.VentaService.VentaService;
import com.masterKey.kronos.repository.ContingenciaDetalleRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.stream.Collectors;
import java.util.*;

@Controller
@RequestMapping("/contingencias")
public class ContingenciaController extends BaseController{

    private final ContingenciaService contingenciaService;
    private final TipoContingenciaService tipoContingenciaService;
    private final VentaService ventaService;
    private final ParametroService parametroService;
    private final ContingenciaDetalleRepository contingenciaDetalleRepository;
    private final SenderHelper senderHelper;

    @Autowired
    public ContingenciaController(
            ContingenciaService contingenciaService,
            TipoContingenciaService tipoContingenciaService,
            VentaService ventaService,
            ParametroService parametroService,
            ContingenciaDetalleRepository contingenciaDetalleRepository,
            SenderHelper senderHelper) {
        this.contingenciaService = contingenciaService;
        this.tipoContingenciaService = tipoContingenciaService;
        this.ventaService = ventaService;
        this.parametroService = parametroService;
        this.contingenciaDetalleRepository = contingenciaDetalleRepository;
        this.senderHelper = senderHelper;
    }

    @PostMapping("/{id}/actualizar")
    public ResponseEntity<?> actualizarContingencia(
            @PathVariable("id") Long id,
            @RequestBody Map<String, Object> payload
    ){
        Map<String, Object> res = new HashMap<>();
        try {
            Optional<Contingencia> contOpt = contingenciaService.findAllOrderByIdDesc().stream()
                    .filter(c -> c.getId().equals(id)).findFirst();
            if (contOpt.isEmpty()) {
                res.put("ok", false);
                res.put("message", "Contingencia no encontrada");
                return ResponseEntity.badRequest().body(res);
            }
            Contingencia cont = contOpt.get();
            boolean procesada = cont.getSelloContingencia() != null && !cont.getSelloContingencia().isEmpty();
            if (procesada) {
                res.put("ok", false);
                res.put("message", "Contingencia ya procesada, no se puede editar");
                return ResponseEntity.badRequest().body(res);
            }

            Object tipoIdRaw = payload.get("tipoContingenciaId");
            Object fIniRaw = payload.get("fInicio");
            Object fFinRaw = payload.get("fFin");
            Object motivoRaw = payload.get("motivoContingencia");

            if (tipoIdRaw != null) {
                try { Long tid = Long.parseLong(String.valueOf(tipoIdRaw));
                    tipoContingenciaService.findById(tid).ifPresent(cont::setTipoContingencia);
                } catch (Exception ignored) {}
            }
            if (fIniRaw != null) cont.setfInicio(LocalDate.parse(String.valueOf(fIniRaw)));
            if (fFinRaw != null) cont.setfFin(LocalDate.parse(String.valueOf(fFinRaw)));
            if (motivoRaw != null) cont.setMotivoContingencia(String.valueOf(motivoRaw));

            contingenciaService.save(cont);
            res.put("ok", true);
            res.put("message", "Contingencia actualizada");
            return ResponseEntity.ok(res);
        } catch (Exception ex) {
            res.put("ok", false);
            res.put("message", "Error al actualizar: " + ex.getMessage());
            return ResponseEntity.internalServerError().body(res);
        }
    }

    @PostMapping("/{id}/procesarDte")
    @ResponseBody
    public ResponseEntity<?> procesarContingencia(
            @PathVariable("id") Long id,
            HttpSession session
    ){
        Map<String, Object> res = new HashMap<>();
        try {
            String respuesta = senderHelper.enviarContingencia(id);
            ObjectMapper mapper = new ObjectMapper();
            Map<String, Object> respuestaObj = mapper.readValue(respuesta, new TypeReference<>() {});
            res.put("ok", true);
            res.put("message", "Contingencia procesada exitosamente");
            res.put("respuestaMh", respuestaObj);

        }catch ( Exception ex ){
            res.put("ok", false);
            res.put("message", "Error al enviar la contingencia: " + ex.getMessage());
            return ResponseEntity.internalServerError().body(res);
        }
        return ResponseEntity.ok(res);
    }

    @RequestMapping
    public String verContingencias(
            Model model,
            HttpSession session
    ){
        model.addAttribute("title", "Contingencias");
        model.addAttribute("contingencias", contingenciaService.findAllOrderByIdDesc());

        return "contingencias/ver_contingencias";
    }

    @RequestMapping("/crear")
    public String crearContingencia(
            Model model,
            HttpSession session
    ){
        model.addAttribute("title", "Crear contingencia");
        model.addAttribute("tiposContingencia", tipoContingenciaService.findAll());
        model.addAttribute("ventasContingencias", ventaService.findByContingencia(1));

        return "contingencias/crear_contingencia";
    }

    @RequestMapping("/{id}")
    public String editarContingencia(
            @PathVariable("id") Long id,
            Model model,
            HttpSession session
    ){
        Optional<Contingencia> contOpt = Optional.ofNullable(id)
                .flatMap(cid -> contingenciaService.findAllOrderByIdDesc().stream().filter(c -> c.getId().equals(cid)).findFirst());
        // Nota: idealmente un findById en el service; por ahora filtramos la lista
        Contingencia cont = contOpt.orElse(null);
        model.addAttribute("title", "Editar contingencia");
        model.addAttribute("contingencia", cont);
        model.addAttribute("tiposContingencia", tipoContingenciaService.findAll());
        return "contingencias/editar_contingencia";
    }

    @PostMapping("/guardar")
    public ResponseEntity<?> contingenciaSave(
            @RequestBody Map<String, Object> payload,
            HttpSession session){
        Map<String, Object> res = new HashMap<>();

        try {
            // Validaciones básicas
            Object tipoIdRaw = payload.get("tipoContingenciaId");
            Object fIniRaw = payload.get("fInicio");
            Object fFinRaw = payload.get("fFin");
            Object motivoRaw = payload.get("motivoContingencia");
            Object ventasRaw = payload.get("ventas");

            if (tipoIdRaw == null || fIniRaw == null || fFinRaw == null || motivoRaw == null || ventasRaw == null) {
                res.put("ok", false);
                res.put("message", "Datos incompletos para guardar la contingencia");
                return ResponseEntity.badRequest().body(res);
            }

            Long tipoId = null;
            try { tipoId = Long.parseLong(String.valueOf(tipoIdRaw)); } catch (Exception ignore) {}
            if (tipoId == null) {
                res.put("ok", false);
                res.put("message", "Tipo de contingencia inválido");
                return ResponseEntity.badRequest().body(res);
            }

            LocalDate fInicio = LocalDate.parse(String.valueOf(fIniRaw));
            LocalDate fFin = LocalDate.parse(String.valueOf(fFinRaw));
            if (fInicio.isAfter(fFin)) {
                res.put("ok", false);
                res.put("message", "La fecha inicio no puede ser mayor que la fecha fin");
                return ResponseEntity.badRequest().body(res);
            }

            @SuppressWarnings("unchecked")
            List<Object> ventasListRaw = (List<Object>) ventasRaw;
            List<Long> ventaIds = ventasListRaw.stream()
                    .map(v -> {
                        try { return Long.parseLong(String.valueOf(v)); } catch (Exception e) { return null; }
                    })
                    .filter(Objects::nonNull)
                    .collect(Collectors.toList());
            if (ventaIds.isEmpty()) {
                res.put("ok", false);
                res.put("message", "Debe seleccionar al menos una venta");
                return ResponseEntity.badRequest().body(res);
            }

            // Construir entidad Contingencia
            String uid = UUID.randomUUID().toString().toUpperCase();
            Contingencia cont = new Contingencia();
            cont.setfInicio(fInicio);
            cont.setfFin(fFin);
            cont.setMotivoContingencia(String.valueOf(motivoRaw));
            cont.setCodigoGeneracion(uid);
            tipoContingenciaService.findById(tipoId).ifPresent(cont::setTipoContingencia);

            // Guardar encabezado
            Contingencia guardada = contingenciaService.save(cont);

            // Traer ventas y crear detalles
            List<Venta> ventas = ventaService.findByIdIn(ventaIds);
            List<ContingenciaDetalle> detalles = new ArrayList<>();
            for (Venta v : ventas) {
                ContingenciaDetalle d = new ContingenciaDetalle();
                d.setContingencia(guardada);
                d.setVenta(v);
                detalles.add(d);

                v.setContingencia(1);
                v.setCodigoGeneracionContingencia(uid);
                ventaService.save(v);
                // Opcional: marcar venta en contingencia
                // if (v.getContingencia() == null || v.getContingencia() == 0) { v.setContingencia(1); ventaService.save(v); }
            }
            if (!detalles.isEmpty()) contingenciaDetalleRepository.saveAll(detalles);

            res.put("ok", true);
            res.put("message", "Contingencia guardada exitosamente");
            res.put("contingenciaId", guardada.getId());
            res.put("detalles", detalles.size());
            return ResponseEntity.ok(res);
        } catch (Exception ex) {
            res.put("ok", false);
            res.put("message", "Error al guardar la contingencia: " + ex.getMessage());
            return ResponseEntity.internalServerError().body(res);
        }
    }

}
