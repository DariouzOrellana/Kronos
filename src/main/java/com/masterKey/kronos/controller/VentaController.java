package com.masterKey.kronos.controller;

import com.masterKey.kronos.model.*;
import com.masterKey.kronos.service.ParametroService.ParametroService;
import com.masterKey.kronos.service.ProductoService.ProductoService;
import com.masterKey.kronos.service.VentaService.VentaService;
import com.masterKey.kronos.service.VentaDetalleService.VentaDetalleService;
import com.masterKey.kronos.service.ClienteService.ClienteService;
import com.masterKey.kronos.service.TipoDocumentoService.TipoDocumentoService;
import com.masterKey.kronos.service.UsuarioService.UsuarioService;
import com.masterKey.kronos.service.TipoInvalidacionService.TipoInvalidacionService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
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

    @Autowired
    public VentaController(VentaService ventaService,
                           ClienteService clienteService,
                           TipoDocumentoService tipoDocumentoService,
                           UsuarioService usuarioService,
                           ProductoService productoService,
                           VentaDetalleService ventaDetalleService,
                           ParametroService parametroService,
                           TipoInvalidacionService tipoInvalidacionService) {
        this.ventaService = ventaService;
        this.clienteService = clienteService;
        this.tipoDocumentoService = tipoDocumentoService;
        this.usuarioService = usuarioService;
        this.productoService = productoService;
        this.ventaDetalleService = ventaDetalleService;
        this.parametroService = parametroService;
        this.tipoInvalidacionService = tipoInvalidacionService;
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
    public ResponseEntity<?> ventaSave(@RequestBody Map<String, Object> payload, HttpSession session){
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
        venta.setNombreFactura(nombreFactura);
        venta.setTipoDocFactura(tipoDocFactura);
        venta.setDocFactura(docFactura);
        venta.setCorreo(correo);
        venta.setSubtotal(subtotal);
        venta.setIva(iva);
        venta.setDescuento(descuento);
        venta.setRetencion(retencion);
        venta.setPercepcion(percepcion);
        venta.setTotal(total);

        // Persistir Venta primero (para obtener ID)
        venta = ventaService.save(venta);

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
            ventaDetalleService.saveAll(detalles);
        }

        res.put("ok", true);
        res.put("message", "Venta guardada exitosamente");
        res.put("ventaId", venta.getId());
        return ResponseEntity.ok(res);
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