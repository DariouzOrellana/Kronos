package com.masterKey.kronos.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.masterKey.kronos.model.*;
import com.masterKey.kronos.service.ContingenciaService.ContingenciaService;
import com.masterKey.kronos.service.ParametroService.ParametroService;
import com.masterKey.kronos.service.TipoDocumentoService.TipoDocumentoService;
import com.masterKey.kronos.service.VentaService.VentaService;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Service
public class JsonHelper {

    private final ParametroService parametroService;
    private final VentaService ventaService;
    private final TipoDocumentoService tipoDocumentoService;
    private final ContingenciaService contingenciaService;

    public JsonHelper(ParametroService parametroService,
                      VentaService ventaService,
                      TipoDocumentoService tipoDocumentoService,
                      ContingenciaService contingenciaService) {
        this.parametroService = parametroService;
        this.ventaService = ventaService;
        this.tipoDocumentoService = tipoDocumentoService;
        this.contingenciaService = contingenciaService;
    }

    public String generarJsonCff(Long id) throws JsonProcessingException {
        ObjectMapper mapper = new ObjectMapper();
        Venta venta = ventaService.findById(id);

        if(venta == null){
            return "ERROR: Venta no encontrada";
        }

        TipoDocumento tipoDocumento = tipoDocumentoService.findById(venta.getTipoDocumento().getId()).get();

        if(tipoDocumento == null){
            return "ERROR: Tipo documento no encontrado";
        }

        // Objeto raíz
        ObjectNode root = mapper.createObjectNode();

        // ========== IDENTIFICACION ==========
        ObjectNode identificacion = root.putObject("identificacion");
        identificacion.put("version", tipoDocumento.getVersionDte());
        identificacion.put("ambiente", parametroService.findById("MH_AMBIENTE").map(Parametro::getValor).orElse("00"));
        identificacion.put("tipoDte", tipoDocumento.getId());
        identificacion.put("numeroControl", venta.getNumeroControl());
        identificacion.put("codigoGeneracion", venta.getCodigoGeneracion());

        if(venta.getContingencia() != null){
            Contingencia contingencia = contingenciaService.findById(new Long(venta.getContingencia()));

            identificacion.put("tipoModelo", 2);
            identificacion.put("tipoOperacion", 2);
            identificacion.put("tipoContingencia", contingencia.getTipoContingencia().getId());
            identificacion.put("motivoContin", contingencia.getMotivoContingencia());
        }else {
            identificacion.put("tipoModelo", 1);
            identificacion.put("tipoOperacion", 1);
            identificacion.putNull("tipoContingencia");
            identificacion.putNull("motivoContin");
        }

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSSSSS");
        LocalDateTime fechaHora= LocalDateTime.parse(venta.getFecha().toString(), formatter);

        String fecEmi = fechaHora.toLocalDate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        String horEmi = fechaHora.toLocalTime().format(DateTimeFormatter.ofPattern("HH:mm:ss"));

        identificacion.put("fecEmi", fecEmi);
        identificacion.put("horEmi", horEmi);
        identificacion.put("tipoMoneda", "USD");

        // ========== EMISOR ==========
        ObjectNode emisor = root.putObject("emisor");
        emisor.put("nit", venta.getUsuario().getCaja().getSucursal().getEmpresa().getNit().replace("-", ""));
        emisor.put("nrc", venta.getUsuario().getCaja().getSucursal().getEmpresa().getNoRegistro().replace("-", ""));
        emisor.put("nombre", venta.getUsuario().getCaja().getSucursal().getEmpresa().getRepresentanteLegal());
        emisor.put("codActividad", venta.getUsuario().getCaja().getSucursal().getEmpresa().getActividadEconomica().getId());
        emisor.put("descActividad", venta.getUsuario().getCaja().getSucursal().getEmpresa().getActividadEconomica().getNombreActividadEconomica());
        emisor.put("nombreComercial", venta.getUsuario().getCaja().getSucursal().getEmpresa().getNombreComercial());

        String tipoEstablecimiento = "";

        if(venta.getUsuario().getCaja().getSucursal().getEstablecimientoMh().startsWith("S")){
            tipoEstablecimiento = "02";
        }else{
            tipoEstablecimiento = "01";
        }
        emisor.put("tipoEstablecimiento", tipoEstablecimiento);

        ObjectNode dirEmisor = emisor.putObject("direccion");
        dirEmisor.put("departamento", "06");
        dirEmisor.put("municipio", "14");
        dirEmisor.put("complemento", "Km26 Carretera Panamericana hacia Santa Ana, San Juan Opico, La Libertad");

        emisor.put("telefono", "25228849");
        emisor.put("correo", "soporte.dte@gruporvq.com");
        emisor.put("codEstableMH", "M001");
        emisor.put("codEstable", "M001");
        emisor.put("codPuntoVentaMH", "P001");
        emisor.put("codPuntoVenta", "P001");

        // ========== RECEPTOR ==========
        ObjectNode receptor = root.putObject("receptor");
        receptor.put("nit", "059088445");
        receptor.put("nrc", "3567659");
        receptor.put("nombre", "OSMARO ALFONSOBONILLA MESTIZO");
        receptor.put("codActividad", "62090");
        receptor.put("descActividad", "Otras actividades de tecnología de información y servicios de computadora");
        receptor.put("nombreComercial", "OSMARO ALFONSOBONILLA MESTIZO");

        ObjectNode dirReceptor = receptor.putObject("direccion");
        dirReceptor.put("departamento", "06");
        dirReceptor.put("municipio", "23");
        dirReceptor.put("complemento", "PSJ. RAMOS,RES. LA GLORIA, LOTIF,2A, RES LA GLORIA PSJE REMOSLOT2 A, DISTRITO DE MEJICANOS, MUNICIPIO DE SAN SALVADOR CENTRO, DEPARTAMENTO DE SAN SALVADOR");

        receptor.put("telefono", "68313638");
        receptor.put("correo", "obonilla@apolosolution.com");

        // Otros nulos
        root.putNull("documentoRelacionado");
        root.putNull("otrosDocumentos");
        root.putNull("ventaTercero");
        root.putNull("extension");

        // ========== CUERPO DOCUMENTO ==========
        ArrayNode cuerpo = root.putArray("cuerpoDocumento");
        ObjectNode item = cuerpo.addObject();
        item.put("numItem", 1);
        item.put("tipoItem", 1);
        item.putNull("numeroDocumento");
        item.put("codigo", "1");
        item.putNull("codTributo");
        item.put("descripcion", "SUPER-3");
        item.put("cantidad", 5.26316);
        item.put("uniMedida", 22);
        item.put("precioUni", 3.097345);
        item.put("montoDescu", 0.0);
        item.put("ventaNoSuj", 0.0);
        item.put("ventaExenta", 0.0);
        item.put("ventaGravada", 16.301823);
        ArrayNode tributosItem = item.putArray("tributos");
        tributosItem.add("20");
        tributosItem.add("D1");
        tributosItem.add("C8");
        item.put("psv", 0.0);
        item.put("noGravado", 0.0);

        // ========== RESUMEN ==========
        ObjectNode resumen = root.putObject("resumen");
        resumen.put("totalNoSuj", 0.0);
        resumen.put("totalExenta", 0.0);
        resumen.put("totalGravada", 16.3);
        resumen.put("subTotalVentas", 16.3);
        resumen.put("descuNoSuj", 0.0);
        resumen.put("descuExenta", 0.0);
        resumen.put("descuGravada", 0.0);
        resumen.put("porcentajeDescuento", 0.0);
        resumen.put("totalDescu", 0.0);

        ArrayNode tributos = resumen.putArray("tributos");
        ObjectNode iva = tributos.addObject();
        iva.put("codigo", "20");
        iva.put("descripcion", "Impuesto al Valor Agregado 13%");
        iva.put("valor", 2.12);

        ObjectNode cotrans = tributos.addObject();
        cotrans.put("codigo", "C8");
        cotrans.put("descripcion", "COTRANS ($0.10 Ctvs. por galón)");
        cotrans.put("valor", 0.53);

        ObjectNode fovial = tributos.addObject();
        fovial.put("codigo", "D1");
        fovial.put("descripcion", "FOVIAL ($0.20 Ctvs. por galón)");
        fovial.put("valor", 1.05);

        resumen.put("subTotal", 16.3);
        resumen.put("montoTotalOperacion", 20.0);
        resumen.put("totalPagar", 20.0);
        resumen.put("totalLetras", "veinte 00/100 dolares");
        resumen.put("condicionOperacion", 1);

        ArrayNode pagos = resumen.putArray("pagos");
        ObjectNode pago = pagos.addObject();
        pago.put("codigo", "02");
        pago.put("montoPago", 20.0);
        pago.putNull("referencia");
        pago.putNull("plazo");
        pago.put("periodo", 1);
        resumen.putNull("numPagoElectronico");

        // ========== APENDICE ==========
        ArrayNode apendice = root.putArray("apendice");
        ObjectNode ap1 = apendice.addObject();
        ap1.put("campo", "EMP");
        ap1.put("etiqueta", "EMPLEADO");
        ap1.put("valor", "104");

        ObjectNode ap2 = apendice.addObject();
        ap2.put("campo", "NO_UNICO");
        ap2.put("etiqueta", "NO_UNICO");
        ap2.put("valor", "22322");

        ObjectNode ap3 = apendice.addObject();
        ap3.put("campo", "OBSERVACION");
        ap3.put("etiqueta", "OBSERVACION");
        ap3.put("valor", "-");

        ObjectNode ap4 = apendice.addObject();
        ap4.put("campo", "SUCURSAL");
        ap4.put("etiqueta", "SUCURSAL");
        ap4.put("valor", "TEXACO CARIBE");

        // ❌ No incluir respuestaHacienda, firmaElectronica ni selloRecibido (si no hay valor)

        // ========== Salida JSON bonita ==========
        String json = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(root);

        return json;
    }
}
