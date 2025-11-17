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
import java.util.List;

@Service
public class JsonHelper {

    private final ParametroService parametroService;
    private final VentaService ventaService;
    private final TipoDocumentoService tipoDocumentoService;
    private final ContingenciaService contingenciaService;
    private final NumeroALetrasHelper numeroALetrasHelper;

    public JsonHelper(ParametroService parametroService,
                      VentaService ventaService,
                      TipoDocumentoService tipoDocumentoService,
                      ContingenciaService contingenciaService,
                      NumeroALetrasHelper numeroALetrasHelper) {
        this.parametroService = parametroService;
        this.ventaService = ventaService;
        this.tipoDocumentoService = tipoDocumentoService;
        this.contingenciaService = contingenciaService;
        this.numeroALetrasHelper = numeroALetrasHelper;
    }

    public String generarJsonFac(Long id) throws JsonProcessingException {
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
        identificacion.put("version",  Integer.parseInt(tipoDocumento.getVersionDte()));
        identificacion.put("ambiente", parametroService.findById("MH_AMBIENTE").map(Parametro::getValor).orElse("00"));
        identificacion.put("tipoDte", tipoDocumento.getId());
        identificacion.put("numeroControl", venta.getNumeroControl());
        identificacion.put("codigoGeneracion", venta.getCodigoGeneracion());

        if(venta.getContingencia() != null){
            Contingencia contingencia = contingenciaService.findById(Long.valueOf(venta.getContingencia()));

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

        LocalDateTime fechaHora= venta.getFecha();

        String fecEmi = fechaHora.toLocalDate().toString();
        String horEmi = fechaHora.toLocalTime().withNano(0).toString();

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
        dirEmisor.put("departamento", venta.getUsuario().getCaja().getSucursal().getEmpresa().getDepartamento().getId());
        dirEmisor.put("municipio", venta.getUsuario().getCaja().getSucursal().getEmpresa().getMunicipio().getMunicipioId());
        dirEmisor.put("complemento", venta.getUsuario().getCaja().getSucursal().getEmpresa().getDireccion());

        emisor.put("telefono", venta.getUsuario().getCaja().getSucursal().getEmpresa().getTelefono().replace("-", ""));
        emisor.put("correo", venta.getUsuario().getCaja().getSucursal().getEmpresa().getCorreo());
        emisor.put("codEstableMH", venta.getUsuario().getCaja().getSucursal().getEstablecimientoMh());
        emisor.put("codEstable", venta.getUsuario().getCaja().getPuntoVentaMh());
        emisor.put("codPuntoVentaMH", venta.getUsuario().getCaja().getPuntoVentaMh());
        emisor.put("codPuntoVenta", venta.getUsuario().getCaja().getPuntoVentaMh());

        // ========== RECEPTOR ==========
        ObjectNode receptor = root.putObject("receptor");
        receptor.putNull("nrc");

        String tipoDocumentoReceptor = "";
        switch (venta.getTipoDocFactura() == null ? "" : venta.getTipoDocFactura()){
            case "DUI":
                tipoDocumentoReceptor = "13";
                break;
            case "NIT":
                tipoDocumentoReceptor = "36";
                break;
            case "OTRO":
                tipoDocumentoReceptor = "37";
                break;
            default:
                tipoDocumentoReceptor = "";
                break;
        }

        receptor.put("tipoDocumento", tipoDocumentoReceptor.isEmpty() ? null : tipoDocumentoReceptor);
        receptor.put("numDocumento", venta.getDocFactura() == null ? null : venta.getDocFactura().replace("-", ""));
        receptor.put("nombre", venta.getNombreFactura() == null ? "CONSUMIDOR FINAL" : venta.getNombreFactura());
        receptor.put("correo", venta.getCorreo() == null ? null : venta.getCorreo());

        receptor.putNull("codActividad");
        receptor.putNull("descActividad");
        receptor.putNull("direccion");
        receptor.putNull("telefono");


        // Otros nulos
        root.putNull("documentoRelacionado");
        root.putNull("otrosDocumentos");
        root.putNull("ventaTercero");
        root.putNull("extension");

        // ========== CUERPO DOCUMENTO ==========
        ArrayNode cuerpo = root.putArray("cuerpoDocumento");

        Integer contador = 0;

        for(VentaDetalle vt : venta.getDetalles()){
            contador++;

            ObjectNode item = cuerpo.addObject();
            item.put("numItem", contador);

            Integer tipoItem = 1;

            if(vt.getProducto().getTipo().equals("SERVICIO")){
                tipoItem = 2;
            }else{
                //Bien
                tipoItem = 1;
            }

            item.put("tipoItem", tipoItem);
            item.putNull("numeroDocumento");
            item.put("codigo", vt.getProducto().getId().toString());
            item.putNull("codTributo");
            item.put("descripcion", vt.getProducto().getDescripcion());
            item.put("cantidad", vt.getCantidad());

            //Unidad de medida 59, (Unidad)
            item.put("uniMedida", 59);
            item.put("precioUni", vt.getPrecioUnitario());
            item.put("montoDescu", vt.getDescuento());
            item.put("ventaNoSuj", 0.0);
            item.put("ventaExenta", 0.0);
            item.put("ventaGravada", vt.getSubTotal());
            item.putNull("tributos");
            item.put("ivaItem", vt.getIva());
            item.put("psv", 0.0);
            item.put("noGravado", 0.0);
        }


        // ========== RESUMEN ==========
        ObjectNode resumen = root.putObject("resumen");
        resumen.put("totalNoSuj", 0.0);
        resumen.put("totalExenta", 0.0);
        resumen.put("totalGravada", venta.getSubtotal());
        resumen.put("subTotalVentas", venta.getSubtotal());
        resumen.put("descuNoSuj", 0.0);
        resumen.put("descuExenta", 0.0);
        resumen.put("descuGravada", venta.getDescuento());
        resumen.put("porcentajeDescuento", 0.0);
        resumen.put("totalDescu", venta.getDescuento());
        resumen.put("ivaRete1", venta.getRetencion());
        resumen.put("reteRenta", 0);
        resumen.put("totalNoGravado", 0);
        resumen.put("saldoFavor", 0);
        resumen.putNull("tributos");

        resumen.put("subTotal", venta.getSubtotal());
        resumen.put("totalIva", venta.getIva());
        resumen.put("montoTotalOperacion", venta.getTotal());
        resumen.put("totalPagar", venta.getTotal());
        resumen.put("totalLetras", numeroALetrasHelper.convertir(venta.getTotal().doubleValue()));

        //Condicion contado
        resumen.put("condicionOperacion", 1);

        ArrayNode pagos = resumen.putArray("pagos");
        ObjectNode pago = pagos.addObject();
        pago.put("codigo", "01");
        pago.put("montoPago", venta.getTotal());
        pago.putNull("referencia");
        pago.putNull("plazo");
        pago.putNull("periodo");
        resumen.putNull("numPagoElectronico");

        // ========== APENDICE ==========
        ArrayNode apendice = root.putArray("apendice");
        ObjectNode ap1 = apendice.addObject();
        ap1.put("campo", "COD");
        ap1.put("etiqueta", "CODIGO VENTA");
        ap1.put("valor", venta.getId().toString());

        if(venta.getSelloMh() != null){
            root.put("selloMh", venta.getSelloMh());
        }

        // ========== Salida JSON bonita ==========
        String json = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(root);

        return json;
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
        identificacion.put("version",  Integer.parseInt(tipoDocumento.getVersionDte()));
        identificacion.put("ambiente", parametroService.findById("MH_AMBIENTE").map(Parametro::getValor).orElse("00"));
        identificacion.put("tipoDte", tipoDocumento.getId());
        identificacion.put("numeroControl", venta.getNumeroControl());
        identificacion.put("codigoGeneracion", venta.getCodigoGeneracion());

        if(venta.getContingencia() != null){
            Contingencia contingencia = contingenciaService.findById(Long.valueOf(venta.getContingencia()));

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

        LocalDateTime fechaHora= venta.getFecha();

        String fecEmi = fechaHora.toLocalDate().toString();
        String horEmi = fechaHora.toLocalTime().withNano(0).toString();

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
        dirEmisor.put("departamento", venta.getUsuario().getCaja().getSucursal().getEmpresa().getDepartamento().getId());
        dirEmisor.put("municipio", venta.getUsuario().getCaja().getSucursal().getEmpresa().getMunicipio().getMunicipioId());
        dirEmisor.put("complemento", venta.getUsuario().getCaja().getSucursal().getEmpresa().getDireccion());

        emisor.put("telefono", venta.getUsuario().getCaja().getSucursal().getEmpresa().getTelefono().replace("-", ""));
        emisor.put("correo", venta.getUsuario().getCaja().getSucursal().getEmpresa().getCorreo());
        emisor.put("codEstableMH", venta.getUsuario().getCaja().getSucursal().getEstablecimientoMh());
        emisor.put("codEstable", venta.getUsuario().getCaja().getPuntoVentaMh());
        emisor.put("codPuntoVentaMH", venta.getUsuario().getCaja().getPuntoVentaMh());
        emisor.put("codPuntoVenta", venta.getUsuario().getCaja().getPuntoVentaMh());

        // ========== RECEPTOR ==========
        ObjectNode receptor = root.putObject("receptor");
        receptor.put("nit", venta.getCliente().getNit().replace("-", ""));
        receptor.put("nrc", venta.getCliente().getNoRegistro().replace("-", ""));
        receptor.put("nombre", venta.getCliente().getNombreCliente());
        receptor.put("codActividad", venta.getCliente().getActividadEconomica().getId());
        receptor.put("descActividad", venta.getCliente().getActividadEconomica().getNombreActividadEconomica());
        receptor.put("nombreComercial", venta.getCliente().getNombreCliente());

        ObjectNode dirReceptor = receptor.putObject("direccion");
        dirReceptor.put("departamento", venta.getCliente().getDepartamento().getId());
        dirReceptor.put("municipio", venta.getCliente().getMunicipio().getMunicipioId());
        dirReceptor.put("complemento", venta.getCliente().getDireccion());

        receptor.put("telefono", venta.getCliente().getTelefono().replace("-", ""));
        receptor.put("correo", venta.getCliente().getCorreo());

        // Otros nulos
        root.putNull("documentoRelacionado");
        root.putNull("otrosDocumentos");
        root.putNull("ventaTercero");
        root.putNull("extension");

        // ========== CUERPO DOCUMENTO ==========
        ArrayNode cuerpo = root.putArray("cuerpoDocumento");

        Integer contador = 0;

        for(VentaDetalle vt : venta.getDetalles()){
            contador++;

            ObjectNode item = cuerpo.addObject();
            item.put("numItem", contador);

            Integer tipoItem = 1;

            if(vt.getProducto().getTipo().equals("SERVICIO")){
                tipoItem = 2;
            }else{
                //Bien
                tipoItem = 1;
            }

            item.put("tipoItem", tipoItem);
            item.putNull("numeroDocumento");
            item.put("codigo", vt.getProducto().getId().toString());
            item.putNull("codTributo");
            item.put("descripcion", vt.getProducto().getDescripcion());
            item.put("cantidad", vt.getCantidad());

            //Unidad de medida 59, (Unidad)
            item.put("uniMedida", 59);
            item.put("precioUni", vt.getPrecioUnitario());
            item.put("montoDescu", vt.getDescuento());
            item.put("ventaNoSuj", 0.0);
            item.put("ventaExenta", 0.0);
            item.put("ventaGravada", vt.getSubTotal());
            ArrayNode tributosItem = item.putArray("tributos");
            tributosItem.add("20");
            item.put("psv", 0.0);
            item.put("noGravado", 0.0);
        }


        // ========== RESUMEN ==========
        ObjectNode resumen = root.putObject("resumen");
        resumen.put("totalNoSuj", 0.0);
        resumen.put("totalExenta", 0.0);
        resumen.put("totalGravada", venta.getSubtotal());
        resumen.put("subTotalVentas", venta.getSubtotal());
        resumen.put("descuNoSuj", 0.0);
        resumen.put("descuExenta", 0.0);
        resumen.put("descuGravada", venta.getDescuento());
        resumen.put("porcentajeDescuento", 0.0);
        resumen.put("totalDescu", venta.getDescuento());
        resumen.put("ivaPerci1", venta.getPercepcion());
        resumen.put("ivaRete1", venta.getRetencion());
        resumen.put("reteRenta", 0);
        resumen.put("totalNoGravado", 0);
        resumen.put("saldoFavor", 0);

        ArrayNode tributos = resumen.putArray("tributos");
        ObjectNode iva = tributos.addObject();
        iva.put("codigo", "20");
        iva.put("descripcion", "Impuesto al Valor Agregado 13%");
        iva.put("valor", venta.getIva());

        resumen.put("subTotal", venta.getSubtotal());
        resumen.put("montoTotalOperacion", venta.getTotal());
        resumen.put("totalPagar", venta.getTotal());
        resumen.put("totalLetras", numeroALetrasHelper.convertir(venta.getTotal().doubleValue()));

        //Condicion contado
        resumen.put("condicionOperacion", 1);

        ArrayNode pagos = resumen.putArray("pagos");
        ObjectNode pago = pagos.addObject();
        pago.put("codigo", "01");
        pago.put("montoPago", venta.getTotal());
        pago.putNull("referencia");
        pago.putNull("plazo");
        pago.putNull("periodo");
        resumen.putNull("numPagoElectronico");

        // ========== APENDICE ==========
        ArrayNode apendice = root.putArray("apendice");
        ObjectNode ap1 = apendice.addObject();
        ap1.put("campo", "COD");
        ap1.put("etiqueta", "CODIGO VENTA");
        ap1.put("valor", venta.getId().toString());

        if(venta.getSelloMh() != null){
            root.put("selloMh", venta.getSelloMh());
        }

        // ========== Salida JSON bonita ==========
        String json = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(root);

        return json;
    }
    public String generarJsonNc(Long id) throws JsonProcessingException {
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
        identificacion.put("version",  Integer.parseInt(tipoDocumento.getVersionDte()));
        identificacion.put("ambiente", parametroService.findById("MH_AMBIENTE").map(Parametro::getValor).orElse("00"));
        identificacion.put("tipoDte", tipoDocumento.getId());
        identificacion.put("numeroControl", venta.getNumeroControl());
        identificacion.put("codigoGeneracion", venta.getCodigoGeneracion());

        if(venta.getContingencia() != null){
            Contingencia contingencia = contingenciaService.findById(Long.valueOf(venta.getContingencia()));

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

        LocalDateTime fechaHora= venta.getFecha();

        String fecEmi = fechaHora.toLocalDate().toString();
        String horEmi = fechaHora.toLocalTime().withNano(0).toString();

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
        dirEmisor.put("departamento", venta.getUsuario().getCaja().getSucursal().getEmpresa().getDepartamento().getId());
        dirEmisor.put("municipio", venta.getUsuario().getCaja().getSucursal().getEmpresa().getMunicipio().getMunicipioId());
        dirEmisor.put("complemento", venta.getUsuario().getCaja().getSucursal().getEmpresa().getDireccion());

        emisor.put("telefono", venta.getUsuario().getCaja().getSucursal().getEmpresa().getTelefono().replace("-", ""));
        emisor.put("correo", venta.getUsuario().getCaja().getSucursal().getEmpresa().getCorreo());

        // ========== RECEPTOR ==========
        ObjectNode receptor = root.putObject("receptor");
        receptor.put("nit", venta.getCliente().getNit().replace("-", ""));
        receptor.put("nrc", venta.getCliente().getNoRegistro().replace("-", ""));
        receptor.put("nombre", venta.getCliente().getNombreCliente());
        receptor.put("codActividad", venta.getCliente().getActividadEconomica().getId());
        receptor.put("descActividad", venta.getCliente().getActividadEconomica().getNombreActividadEconomica());
        receptor.put("nombreComercial", venta.getCliente().getNombreCliente());

        ObjectNode dirReceptor = receptor.putObject("direccion");
        dirReceptor.put("departamento", venta.getCliente().getDepartamento().getId());
        dirReceptor.put("municipio", venta.getCliente().getMunicipio().getMunicipioId());
        dirReceptor.put("complemento", venta.getCliente().getDireccion());

        receptor.put("telefono", venta.getCliente().getTelefono().replace("-", ""));
        receptor.put("correo", venta.getCliente().getCorreo());

        Venta ventaNc = ventaService.findById(venta.getVentaIdNc().longValue());

        if(ventaNc == null){
            return "ERROR: La venta relacionada para realizar la NC no existe";
        }

        ArrayNode documentoRelacionado = root.putArray("documentoRelacionado");

        ObjectNode doc = documentoRelacionado.addObject();
        doc.put("tipoDocumento", ventaNc.getTipoDocumento().getId());
        //TIPO GENERACION DE DOC; 1 FISICO;2 ELECTRONICO
        doc.put("tipoGeneracion", 2);
        doc.put("numeroDocumento", ventaNc.getCodigoGeneracion());
        doc.put("fechaEmision", ventaNc.getFecha().toLocalDate().toString());

        // Otros nulos
        root.putNull("ventaTercero");
        root.putNull("extension");

        // ========== CUERPO DOCUMENTO ==========
        ArrayNode cuerpo = root.putArray("cuerpoDocumento");

        Integer contador = 0;

        for(VentaDetalle vt : venta.getDetalles()){
            contador++;

            ObjectNode item = cuerpo.addObject();
            item.put("numItem", contador);

            Integer tipoItem = 1;

            if(vt.getProducto().getTipo().equals("SERVICIO")){
                tipoItem = 2;
            }else{
                //Bien
                tipoItem = 1;
            }

            item.put("tipoItem", tipoItem);
            item.put("numeroDocumento", ventaNc.getCodigoGeneracion());
            item.put("codigo", vt.getProducto().getId().toString());
            item.putNull("codTributo");
            item.put("descripcion", vt.getProducto().getDescripcion());
            item.put("cantidad", vt.getCantidad());

            //Unidad de medida 59, (Unidad)
            item.put("uniMedida", 59);
            item.put("precioUni", vt.getPrecioUnitario());
            item.put("montoDescu", vt.getDescuento());
            item.put("ventaNoSuj", 0.0);
            item.put("ventaExenta", 0.0);
            item.put("ventaGravada", vt.getSubTotal());
            ArrayNode tributosItem = item.putArray("tributos");
            tributosItem.add("20");
        }


        // ========== RESUMEN ==========
        ObjectNode resumen = root.putObject("resumen");
        resumen.put("totalNoSuj", 0.0);
        resumen.put("totalExenta", 0.0);
        resumen.put("totalGravada", venta.getSubtotal());
        resumen.put("subTotalVentas", venta.getSubtotal());
        resumen.put("descuNoSuj", 0.0);
        resumen.put("descuExenta", 0.0);
        resumen.put("descuGravada", venta.getDescuento());
        resumen.put("totalDescu", venta.getDescuento());
        resumen.put("ivaPerci1", venta.getPercepcion());
        resumen.put("ivaRete1", venta.getRetencion());
        resumen.put("reteRenta", 0);

        ArrayNode tributos = resumen.putArray("tributos");
        ObjectNode iva = tributos.addObject();
        iva.put("codigo", "20");
        iva.put("descripcion", "Impuesto al Valor Agregado 13%");
        iva.put("valor", venta.getIva());

        resumen.put("subTotal", venta.getSubtotal());
        resumen.put("montoTotalOperacion", venta.getTotal());
        resumen.put("totalLetras", numeroALetrasHelper.convertir(venta.getTotal().doubleValue()));

        //Condicion contado
        resumen.put("condicionOperacion", 1);

        // ========== APENDICE ==========
        ArrayNode apendice = root.putArray("apendice");
        ObjectNode ap1 = apendice.addObject();
        ap1.put("campo", "COD");
        ap1.put("etiqueta", "CODIGO VENTA");
        ap1.put("valor", venta.getId().toString());

        if(venta.getSelloMh() != null){
            root.put("selloMh", venta.getSelloMh());
        }

        // ========== Salida JSON bonita ==========
        String json = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(root);

        return json;
    }
}
