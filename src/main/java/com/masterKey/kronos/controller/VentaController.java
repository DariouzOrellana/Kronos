package com.masterKey.kronos.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.masterKey.kronos.model.*;
import com.masterKey.kronos.service.*;
import com.masterKey.kronos.service.ParametroService.ParametroService;
import com.masterKey.kronos.service.ProductoService.ProductoService;
import com.masterKey.kronos.service.VentaService.VentaService;
import com.masterKey.kronos.service.VentaDetalleService.VentaDetalleService;
import com.masterKey.kronos.service.ClienteService.ClienteService;
import com.masterKey.kronos.service.TipoDocumentoService.TipoDocumentoService;
import com.masterKey.kronos.service.UsuarioService.UsuarioService;
import com.masterKey.kronos.service.TipoInvalidacionService.TipoInvalidacionService;
import jakarta.servlet.http.HttpSession;
import jakarta.transaction.Transactional;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.InputStreamResource;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.*;

@Controller
@RequestMapping("/ventas")
public class VentaController extends BaseController{

    private final VentaService ventaService;
    private final ClienteService clienteService;
    private final TipoDocumentoService tipoDocumentoService;
    private final UsuarioService usuarioService;
    private final ProductoService productoService;
    private final VentaDetalleService ventaDetalleService;
    private final ParametroService parametroService;
    private final TipoInvalidacionService tipoInvalidacionService;
    private final JsonHelper jsonHelper;
    private final SenderHelper senderHelper;
    private final JasperReportService jasperReportService;
    private final EmailService emailService;

    @Autowired
    public VentaController(VentaService ventaService,
                           ClienteService clienteService,
                           TipoDocumentoService tipoDocumentoService,
                           UsuarioService usuarioService,
                           ProductoService productoService,
                           VentaDetalleService ventaDetalleService,
                           ParametroService parametroService,
                           TipoInvalidacionService tipoInvalidacionService,
                           JsonHelper jsonHelper,
                           SenderHelper senderHelper,
                           JasperReportService jasperReportService,
                           EmailService emailService) {
        this.ventaService = ventaService;
        this.clienteService = clienteService;
        this.tipoDocumentoService = tipoDocumentoService;
        this.usuarioService = usuarioService;
        this.productoService = productoService;
        this.ventaDetalleService = ventaDetalleService;
        this.parametroService = parametroService;
        this.tipoInvalidacionService = tipoInvalidacionService;
        this.jsonHelper = jsonHelper;
        this.senderHelper = senderHelper;
        this.jasperReportService = jasperReportService;
        this.emailService = emailService;
    }

    @GetMapping
    public String verVentas(
            Model model,
            HttpSession session,
            @RequestParam(value = "fecha", required = false)
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fecha
    ) {
        LocalDate target = (fecha != null) ? fecha : LocalDate.now();
        LocalDateTime desde = target.atStartOfDay();
        LocalDateTime hasta = target.atTime(LocalTime.MAX);
        model.addAttribute("title", "Ventas");
        model.addAttribute("selectedDate", target);
        model.addAttribute("ventas", ventaService.findAllByFechaBetween(desde, hasta));
        model.addAttribute("tipoInvalidacion", tipoInvalidacionService.findAll());
        return "ventas/ver_ventas";
    }

    @PostMapping("/enviar-correo")
    public ResponseEntity<?> enviarCorreoVenta(
            @RequestParam("idVenta") Long idVenta,
            @RequestParam("correoDestinatario") String correoDestinatario
    ) {
        try{

            emailService.enviarCorreo(idVenta, correoDestinatario);
            return ResponseEntity.ok(
                    "Correo en proceso de envío para " + correoDestinatario
            );
        }catch (Exception ex){
            ex.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @GetMapping(value = "/pruebitas/{id}", produces = MediaType.APPLICATION_PDF_VALUE)
    @ResponseBody
    public ResponseEntity<byte[]> verPruebitas(@PathVariable Long id) throws Exception {
        //dteHelper.setearCodigoGeneracion(13L);
        //dteHelper.setearNumeroControl(13L);
        //String uid = UUID.randomUUID().toString().toUpperCase();
        //String json = jsonHelper.generarJsonCff(43L);

        byte[] pdf = jasperReportService.generarReporteDte(id);
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=prueba.pdf")
                .body(pdf);

        //return json;
    }

    @GetMapping("/generar_pdf")
    public ResponseEntity<?> generarReporte(
            @RequestParam("codigoGeneracion") String codigoGeneracion,
            @RequestParam("fecEmi")
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
            LocalDate fecEmi
    ) throws Exception {

        Optional<Venta> opt = ventaService
                .findByCodigoGeneracionAndFecha(codigoGeneracion, fecEmi);

        if (opt.isEmpty()) {
            Map<String, String> error = new HashMap<>();
            error.put("error", "No se pudo generar el archivo PDF");
            error.put("detalle", "El documento solicitado no se encontró");

            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(error);
        }

        Venta venta = opt.get();
        byte[] pdf = jasperReportService.generarReporteDte(venta.getId());

        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_PDF)
                .header(
                        HttpHeaders.CONTENT_DISPOSITION,
                        "inline; filename=" + venta.getCodigoGeneracion() + ".pdf"
                )
                .body(pdf);
    }


    @GetMapping("/generar_json")
    public ResponseEntity<?> generarJson(
            @RequestParam("codigoGeneracion") String codigoGeneracion,
            @RequestParam("fecEmi") String fecEmi
    ){
        try {

            LocalDate fecha = null;
            try{
                fecha = LocalDate.parse(fecEmi);

            }catch (Exception e){
                Map<String, String> errorResponse = new HashMap<>();
                errorResponse.put("error", "No se pudo generar el archivo PDF");
                errorResponse.put("detalle", "La fecha es inválida");

                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .contentType(MediaType.APPLICATION_JSON)
                        .body(new ObjectMapper().writeValueAsString(errorResponse));
            }

            Optional<Venta> opt = ventaService.findByCodigoGeneracionAndFecha(codigoGeneracion, fecha);
            Venta venta = null;

            if(!opt.isPresent()){
                Map<String, String> errorResponse = new HashMap<>();
                errorResponse.put("error", "No se pudo generar el archivo PDF");
                errorResponse.put("detalle", "El documento solicitado no se encontró");

                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .contentType(MediaType.APPLICATION_JSON)
                        .body(new ObjectMapper().writeValueAsString(errorResponse));
            }else{
                venta = opt.get();
            }

            byte[] jsonContent = jsonHelper.identificarJson(venta.getId()).getBytes(StandardCharsets.UTF_8);
            HttpHeaders headers = new HttpHeaders();

            String nombreArchivo = venta.getCodigoGeneracion() + ".json";
            headers.set(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=" + nombreArchivo);
            headers.setContentType(org.springframework.http.MediaType.APPLICATION_JSON);

            return new ResponseEntity<>(jsonContent, headers, HttpStatus.OK);


        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @GetMapping("/crear")
    public String crearVentaForm(Model model, HttpSession session) {
        String valorIva = parametroService.findById("IVA")
                        .map(Parametro::getValor)
                        .orElse("0.13");
        String valorRetencion = parametroService.findById("RETENCION")
                .map(Parametro::getValor)
                .orElse("0.01");
        String montoRetencion = parametroService.findById("MONTO_RETENCION")
                .map(Parametro::getValor)
                .orElse("100");
        String empresaTipoContribuyente = parametroService.findById("CONTRIBUYENTE")
                .map(Parametro::getValor)
                .orElse("1");
        String tipoContribuyente = parametroService.findById("CONTRIBUYENTE")
                .map(Parametro::getValor)
                .orElse("1");

        model.addAttribute("valorIva", valorIva);
        model.addAttribute("valorRetencion", valorRetencion);
        model.addAttribute("montoRetencion", montoRetencion);
        model.addAttribute("empresaTipoContribuyente", empresaTipoContribuyente);
        model.addAttribute("tipoContribuyente", tipoContribuyente);


        model.addAttribute("clientes", clienteService.findAllByEstado(1));

        model.addAttribute("tiposDocumento", tipoDocumentoService.findAll());
        model.addAttribute("usuarios", usuarioService.findAll());
        model.addAttribute("productos", productoService.findAll());

        model.addAttribute("title", "Crear Venta");
        model.addAttribute("defaultNombreFactura", "CONSUMIDOR FINAL");
        return "ventas/crear_venta";
    }

    @PostMapping("/guardar")
    @Transactional
    public ResponseEntity<?> ventaSave(@RequestBody Map<String, Object> payload, HttpSession session){
        try {
            Map<String, Object> res = new HashMap<>();

            String tipoFactura = parametroService.findById("ID_FACTURA")
                    .map(Parametro::getValor)
                    .orElse("01");
            String valorIva = parametroService.findById("IVA")
                    .map(Parametro::getValor)
                    .orElse("0.13");

            // Campos principales desde payload
            String clienteIdStr = asString(payload.get("clienteId"));
            String tipoDocumentoId = asString(payload.get("tipoDocumentoId"));
            String nombreFactura = asString(payload.get("nombre_factura"));
            String tipoDocFactura = asString(payload.get("tipo_doc_factura"));
            String docFactura = asString(payload.get("doc_factura"));
            String correo = asString(payload.get("correo"));
            // Para nota de crédito: venta referenciada
            String ventaIdNcStr = asString(payload.get("ventaIdNc"));

            // Montos
            @SuppressWarnings("unchecked")
            Map<String, Object> montos = (Map<String, Object>) payload.get("montos");
            BigDecimal subtotal = getBig(montos, "subtotal");
            BigDecimal iva = getBig(montos, "iva");
            BigDecimal descuento = getBig(montos, "descuento");
            BigDecimal retencion = getBig(montos, "retencion");
            BigDecimal percepcion = getBig(montos, "percepcion");
            BigDecimal total = getBig(montos, "total");

            Optional<TipoDocumento> tipoDocOpt = tipoDocumentoService.findById(tipoDocumentoId);
            if (tipoDocOpt.isEmpty()) {
                res.put("ok", false);
                res.put("message", "Tipo de documento no válido");
                return ResponseEntity.badRequest().body(res);
            }

            // Usuario autenticado desde sesión
            Object usrObj = session.getAttribute("userAuth");
            if (usrObj == null) {
                res.put("ok", false);
                res.put("message", "Sesión inválida: usuario no autenticado");
                return ResponseEntity.status(401).body(res);
            }

            Cliente cliente = new Cliente();

            if(tipoFactura.equals(tipoDocumentoId)){

                if(clienteIdStr == null || clienteIdStr.isEmpty()){
                    //Consumidor final
                    cliente = clienteService.findById(1L).get();
                }else{
                    cliente = clienteService.findById(parseLongSafe(clienteIdStr)).get();
                }

            }else{
                cliente = clienteService.findById(parseLongSafe(clienteIdStr)).get();
            }

            // Construir Venta
            Venta venta = new Venta();
            venta.setCliente(cliente);
            venta.setTipoDocumento(tipoDocOpt.get());
            venta.setUsuario((Usuario) usrObj);
            venta.setNombreFactura(nombreFactura.isEmpty() ? "CONSUMIDOR FINAL" : nombreFactura);
            venta.setTipoDocFactura(tipoDocFactura.isEmpty() ? null: tipoDocFactura);
            venta.setDocFactura(docFactura.isEmpty() ? null: docFactura );
            venta.setCorreo(correo.isEmpty() ? null: correo);
            venta.setSubtotal(subtotal);
            venta.setIva(iva);
            venta.setDescuento(descuento);
            venta.setRetencion(retencion);
            venta.setPercepcion(percepcion);
            venta.setTotal(total);

            // Si viene ventaIdNc en payload, setearlo
            Long ventaIdNcLong = parseLongSafe(ventaIdNcStr);
            if (ventaIdNcLong != null) {
                venta.setVentaIdNc(BigDecimal.valueOf(ventaIdNcLong));

            }



            // Items (lista de maps) -> persistir detalles
            List<VentaDetalle> detalles = new ArrayList<>();
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> items = (List<Map<String, Object>>) payload.getOrDefault("items", List.of());
            for (Map<String, Object> it : items) {
                String itemId = asString(it.get("id"));
                BigDecimal cantidad = getBig(it, "cantidad");
                BigDecimal precioUnitario = getBig(it, "precioUnitario");
                BigDecimal itemTotal = getBig(it, "total");

                Long productoId = parseLongSafe(itemId);
                if (productoId == null) {
                    continue; // ignorar líneas inválidas
                }

                Optional<Producto> prodOpt = productoService.findById(productoId);
                if (prodOpt.isEmpty()) {
                    continue; // ignorar si no existe
                }
                BigDecimal ivaDet = new BigDecimal(valorIva).add(BigDecimal.ONE);
                BigDecimal subtotalDet = itemTotal.divide(ivaDet, 2, BigDecimal.ROUND_HALF_UP);
                VentaDetalle det = new VentaDetalle();
                det.setVenta(venta);
                det.setProducto(prodOpt.get());
                det.setCantidad(cantidad);
                det.setPrecioUnitario(precioUnitario);
                det.setDescuento(BigDecimal.ZERO);
                det.setSubTotal(subtotalDet);
                det.setIva(subtotalDet.multiply(new BigDecimal(valorIva)));
                det.setTotalLinea(itemTotal);
                detalles.add(det);
            }


            if (!detalles.isEmpty()) {
                venta.setDetalles(detalles);
                //ventaDetalleService.saveAll(detalles);
                // Persistir Venta primero (para obtener ID)
                venta = ventaService.save(venta);
            }

            String respuestaMh = senderHelper.enviarDte(venta.getId());
            ObjectMapper mapper = new ObjectMapper();

            Map<String, Object> respuestaMhObj =
                    mapper.readValue(respuestaMh, new TypeReference<>() {});
            res.put("ok", true);
            res.put("message", "Venta guardada exitosamente");
            res.put("ventaId", venta.getId());
            res.put("respuestaMh", respuestaMhObj);
            return ResponseEntity.ok(res);
        }catch (Exception ex){
            ex.printStackTrace();
            Map<String, Object> res = new HashMap<>();
            res.put("ok", false);
            res.put("message", "Hubo un error al guardar la venta: " + ex.getStackTrace()[0].getMethodName() + " [" + ex.getMessage() + "");
            res.put("ventaId", 0);
            res.put("respuestaMh", "");
            return ResponseEntity.ok(res);
        }
    }

    @PostMapping("/{id}/procesarDte")
    @ResponseBody
    public ResponseEntity<?> procesarVenta(
            @PathVariable("id") Long id,
            HttpSession session
    ){
        Map<String, Object> res = new HashMap<>();
        try {
            String respuesta = senderHelper.enviarDte(id);
            ObjectMapper mapper = new ObjectMapper();
            Map<String, Object> respuestaObj = mapper.readValue(respuesta, new TypeReference<>() {});
            res.put("ok", true);
            res.put("message", "Venta procesada exitosamente");
            res.put("respuestaMh", respuestaObj);

        }catch ( Exception ex ){
            res.put("ok", false);
            res.put("message", "Error al enviar la Venta: " + ex.getMessage());
            return ResponseEntity.internalServerError().body(res);
        }
        return ResponseEntity.ok(res);
    }

    @GetMapping("/elegibles-nota-credito")
    @ResponseBody
    public ResponseEntity<?> ventasElegiblesNotaCredito(@RequestParam(value = "clienteId", required = false) Long clienteId) {
        List<Venta> ventas = (clienteId != null)
                ? ventaService.findElegiblesNotaCreditoDteByCliente(clienteId)
                : ventaService.findElegiblesNotaCreditoDte();

        List<Map<String, Object>> out = new ArrayList<>();
        for (Venta v : ventas) {
            Map<String, Object> m = new HashMap<>();
            m.put("id", v.getId());
            m.put("fecha", v.getFecha());
            m.put("total", v.getTotal());
            m.put("clienteNombre", v.getCliente() != null ? v.getCliente().getNombreCliente() : null);
            m.put("tipoDocumento", v.getTipoDocumento() != null ? v.getTipoDocumento().getNombre() : null);
            out.add(m);
        }
        return ResponseEntity.ok(out);
    }

    @GetMapping("/{id}")
    @ResponseBody
    public ResponseEntity<?> obtenerVenta(@PathVariable("id") Long id) {
        Venta v = ventaService.findById(id);
        if (v == null) {
            return ResponseEntity.notFound().build();
        }
        Map<String, Object> out = new HashMap<>();
        out.put("id", v.getId());
        out.put("fecha", v.getFecha());
        out.put("total", v.getTotal());
        out.put("subtotal", v.getSubtotal());
        out.put("iva", v.getIva());
        out.put("retencion", v.getRetencion());
        out.put("percepcion", v.getPercepcion());
        out.put("nombreFactura", v.getNombreFactura());
        out.put("tipoDocFactura", v.getTipoDocFactura());
        out.put("docFactura", v.getDocFactura());
        out.put("correo", v.getCorreo());
        Map<String, Object> cliente = new HashMap<>();
        if (v.getCliente() != null) {
            cliente.put("id", v.getCliente().getId());
            cliente.put("nombre", v.getCliente().getNombreCliente());
        }
        out.put("cliente", cliente);
        List<Map<String, Object>> detalles = new ArrayList<>();
        if (v.getDetalles() != null) {
            for (VentaDetalle d : v.getDetalles()) {
                Map<String, Object> md = new HashMap<>();
                md.put("productoId", d.getProducto() != null ? d.getProducto().getId() : null);
                md.put("descripcion", d.getProducto() != null ? d.getProducto().getDescripcion() : "");
                md.put("cantidad", d.getCantidad());
                md.put("precioUnitario", d.getPrecioUnitario());
                md.put("total", d.getTotalLinea());
                detalles.add(md);
            }
        }
        out.put("detalles", detalles);
        return ResponseEntity.ok(out);
    }

    // Helpers de conversión y parsing
    private static String asString(Object v) {
        return v == null ? null : String.valueOf(v);
    }

    private static Long parseLongSafe(String s) {
        try { return (s == null || s.isEmpty()) ? null : Long.valueOf(s); } catch (Exception e) { return null; }
    }

    private static BigDecimal getBig(Map<String, Object> map, String key) {
        if (map == null) return BigDecimal.ZERO;
        Object v = map.get(key);
        if (v == null) return BigDecimal.ZERO;
        if (v instanceof BigDecimal bd) return bd;
        if (v instanceof Number n) return BigDecimal.valueOf(n.doubleValue());
        try { return new BigDecimal(v.toString()); } catch (Exception e) { return BigDecimal.ZERO; }
    }
}