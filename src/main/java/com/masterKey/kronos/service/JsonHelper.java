package com.masterKey.kronos.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.masterKey.kronos.model.*;
import com.masterKey.kronos.service.ContingenciaService.ContingenciaService;
import com.masterKey.kronos.service.InvalidacionService.InvalidacionService;
import com.masterKey.kronos.service.ParametroService.ParametroService;
import com.masterKey.kronos.service.TipoDocumentoService.TipoDocumentoService;
import com.masterKey.kronos.service.VentaService.VentaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class JsonHelper {

    private final ParametroService parametroService;
    private final VentaService ventaService;
    private final TipoDocumentoService tipoDocumentoService;
    private final ContingenciaService contingenciaService;
    private final NumeroALetrasHelper numeroALetrasHelper;
    private final InvalidacionService invalidacionService;

    @Autowired
    public JsonHelper(ParametroService parametroService,
                      VentaService ventaService,
                      TipoDocumentoService tipoDocumentoService,
                      NumeroALetrasHelper numeroALetrasHelper,
                      ContingenciaService contingenciaService,
                      InvalidacionService invalidacionService) {
        this.parametroService = parametroService;
        this.ventaService = ventaService;
        this.tipoDocumentoService = tipoDocumentoService;
        this.contingenciaService = contingenciaService;
        this.numeroALetrasHelper = numeroALetrasHelper;
        this.invalidacionService = invalidacionService;
    }

    public String identificarJson(Long idVenta) throws JsonProcessingException {
        Venta venta = ventaService.findById(idVenta);
        String idFac = parametroService.findById("ID_FACTURA").map(Parametro::getValor).orElse("01");
        String idCff = parametroService.findById("ID_CCF").map(Parametro::getValor).orElse("03");
        String idNc = parametroService.findById("ID_NC").map(Parametro::getValor).orElse("05");
        String jsonGenerado = "";


        if(idFac.equals(venta.getTipoDocumento().getId())){
            jsonGenerado = generarJsonFac(idVenta);
        }
        if(idCff.equals(venta.getTipoDocumento().getId())){
            jsonGenerado = generarJsonCff(idVenta);
        }
        if(idNc.equals(venta.getTipoDocumento().getId())){
            jsonGenerado = generarJsonNc(idVenta);
        }

        if(jsonGenerado.equals("")){
            jsonGenerado = "ERROR:::Metodo [identificarJson]";
        }

        return jsonGenerado;
    }
    public String generarInvalidacion_Json(Long idVenta){
        try {
            String jsonGenerado = "";

            Invalidacion invalidacion = invalidacionService.findByVentaId(idVenta);

            String fechaActual = LocalDate.now().toString();
            String horaActual = LocalTime.now().withNano(0).toString();

            ObjectMapper mapper = new ObjectMapper();
            ObjectNode jsonApi = mapper.createObjectNode();

            // Identificación
            ObjectNode identificacion = mapper.createObjectNode();
            identificacion.put("version", Integer.parseInt(parametroService.findById("MH_VERSION_INVALIDACION").map(Parametro::getValor).orElse("INVALIDACION")));
            identificacion.put("ambiente", parametroService.findById("MH_AMBIENTE").map(Parametro::getValor).orElse("00"));
            identificacion.put("codigoGeneracion", invalidacion.getCodigoGeneracion());
            identificacion.put("fecAnula", fechaActual);
            identificacion.put("horAnula", horaActual);

            jsonApi.set("identificacion", identificacion);

            ObjectNode emisor = mapper.createObjectNode();
            emisor.put("nit", invalidacion.getVenta().getUsuario().getCaja().getSucursal().getEmpresa().getNit().replace("-", ""));
            emisor.put("nombre", invalidacion.getVenta().getUsuario().getCaja().getSucursal().getEmpresa().getRepresentanteLegal());
            emisor.put("tipoEstablecimiento", parametroService.findById("MH_ESTABLECIMIENTO").map(Parametro::getValor).orElse("01"));
            emisor.put("nomEstablecimiento", invalidacion.getVenta().getUsuario().getCaja().getSucursal().getNombreSucursal());
            emisor.put("codEstableMH", invalidacion.getVenta().getUsuario().getCaja().getSucursal().getEstablecimientoMh());
            emisor.put("codEstable", invalidacion.getVenta().getUsuario().getCaja().getPuntoVentaMh());
            emisor.put("codPuntoVentaMH", invalidacion.getVenta().getUsuario().getCaja().getSucursal().getEstablecimientoMh());
            emisor.put("codPuntoVenta", invalidacion.getVenta().getUsuario().getCaja().getPuntoVentaMh());
            emisor.put("telefono", invalidacion.getVenta().getUsuario().getCaja().getSucursal().getTelefono().replace("-", ""));
            emisor.put("correo", invalidacion.getVenta().getUsuario().getCaja().getSucursal().getCorreo());

            jsonApi.set("emisor", emisor);

            ObjectNode documento = mapper.createObjectNode();
            documento.put("tipoDte", invalidacion.getVenta().getTipoDocumento().getId());
            documento.put("codigoGeneracion", invalidacion.getVenta().getCodigoGeneracion());
            documento.put("selloRecibido", invalidacion.getVenta().getSelloMh());
            documento.put("numeroControl", invalidacion.getVenta().getNumeroControl());
            documento.put("fecEmi", invalidacion.getVenta().getFecha().toLocalDate().toString());
            documento.put("montoIva", invalidacion.getVenta().getIva());
            documento.putNull("codigoGeneracionR");

            String idFac = parametroService.findById("ID_FACTURA").map(Parametro::getValor).orElse("01");
            String idCff = parametroService.findById("ID_CFF").map(Parametro::getValor).orElse("03");
            String idNc = parametroService.findById("ID_NC").map(Parametro::getValor).orElse("05");

            if(invalidacion.getVenta().getTipoDocumento().getId().equals(idFac)){

                if (invalidacion.getVenta().getDocFactura() == null || invalidacion.getVenta().getDocFactura().isEmpty()) {
                    documento.putNull("tipoDocumento");
                    documento.putNull("numDocumento");
                } else {

                    switch (invalidacion.getVenta().getTipoDocFactura()) {
                        case "DUI":
                            documento.put("tipoDocumento", "13");
                            documento.put("numDocumento", invalidacion.getVenta().getDocFactura());
                            break;
                        case "NIT":
                            documento.put("tipoDocumento", "36");
                            documento.put("numDocumento", invalidacion.getVenta().getDocFactura());
                            break;
                        case "NRC":
                            documento.put("tipoDocumento", "37");
                            documento.put("numDocumento", invalidacion.getVenta().getDocFactura());
                        default:
                            return "ERROR";
                    }

                }

                if (invalidacion.getVenta().getCorreo() == null) {
                    documento.putNull("correo");
                }else{
                    documento.put("correo", invalidacion.getVenta().getCorreo());
                }

                documento.put("nombre", invalidacion.getVenta().getNombreFactura());
                documento.putNull("telefono");

            }else{
                documento.put("tipoDocumento", "36");
                documento.put("numDocumento", invalidacion.getVenta().getCliente().getNit().replace("-", ""));
                documento.put("nombre", invalidacion.getVenta().getCliente().getNombreCliente());
                documento.put("telefono", invalidacion.getVenta().getCliente().getTelefono().replace("-", ""));
                documento.put("correo", invalidacion.getVenta().getCliente().getCorreo());
            }



            jsonApi.set("documento", documento);
            ObjectNode motivo = mapper.createObjectNode();


            motivo.put("tipoAnulacion", invalidacion.getTipoAnulacion().getId());
            motivo.put("motivoAnulacion", invalidacion.getMotivoAnulacion());
            motivo.put("nombreResponsable", invalidacion.getVenta().getUsuario().getCaja().getSucursal().getEmpresa().getRepresentanteLegal());
            motivo.put("tipDocResponsable", "36");
            motivo.put("numDocResponsable", invalidacion.getVenta().getUsuario().getCaja().getSucursal().getEmpresa().getNit().replace("-", ""));
            motivo.put("nombreSolicita", invalidacion.getNombreSolicita());
            motivo.put("tipDocSolicita", invalidacion.getTipDocSolicita());
            motivo.put("numDocSolicita", invalidacion.getNumDocSolicita());

            jsonApi.set("motivo", motivo);

            jsonGenerado = jsonApi.toPrettyString();
            //System.out.println(jsonApi.toPrettyString());
            return jsonGenerado;
        } catch (Exception e) {
            e.printStackTrace();
            return "ERROR";
        }
    }
    public String generarContingenciaJson(Long idContingencia){
        try {
            Contingencia contingencia = contingenciaService.findById(idContingencia);
            List<ContingenciaDetalle> contingenciaDetalles = contingencia.getDetalles();

            String jsonGenerado = "";

            String fechaActual = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            String horaActual = LocalTime.now().format(DateTimeFormatter.ofPattern("HH:mm:ss"));

            ObjectMapper mapper = new ObjectMapper();
            ObjectNode jsonApi = mapper.createObjectNode();



            // Identificación
            ObjectNode identificacion = mapper.createObjectNode();
            identificacion.put("version", Integer.parseInt(parametroService.findById("MH_VERSION_CONTINGENCIA").map(Parametro::getValor).orElse("3")));
            identificacion.put("ambiente", parametroService.findById("MH_AMBIENTE").map(Parametro::getValor).orElse("00"));
            identificacion.put("codigoGeneracion", contingencia.getCodigoGeneracion());
            identificacion.put("fTransmision", fechaActual);
            identificacion.put("hTransmision", horaActual);

            jsonApi.set("identificacion", identificacion);

            if (contingenciaDetalles.size() == 0) {
                System.out.println("Faltan los detalles para recorrer contingencia.");
                return "ERROR";
            }else{
                int noItem = 0;
                String nit_emisor = "";
                String nombre_emisor = "";
                String telefono_emisor = "";
                String correo_emisor = "";
                ArrayNode detalleDTE = jsonApi.putArray("detalleDTE");
                //**************************************************************
                //Recorriendo las ventas dadas por parametro
                for (ContingenciaDetalle det : contingenciaDetalles) {
                    noItem++;

                    nit_emisor = det.getVenta().getUsuario().getCaja().getSucursal().getEmpresa().getNit().replace("-", "");
                    nombre_emisor = det.getVenta().getUsuario().getCaja().getSucursal().getEmpresa().getRepresentanteLegal();
                    telefono_emisor = det.getVenta().getUsuario().getCaja().getSucursal().getEmpresa().getTelefono().replace("-", "");
                    correo_emisor = det.getVenta().getUsuario().getCaja().getSucursal().getEmpresa().getCorreo();

                    ObjectNode item = mapper.createObjectNode();
                    item.put("noItem", noItem);
                    item.put("codigoGeneracion", det.getVenta().getCodigoGeneracion());
                    item.put("tipoDoc", det.getVenta().getTipoDocumento().getId());

                    detalleDTE.add(item);
                }

                // Identificación
                ObjectNode emisor = mapper.createObjectNode();
                emisor.put("nit", nit_emisor);
                emisor.put("nombre", nombre_emisor);
                emisor.put("nombreResponsable", nombre_emisor);
                emisor.put("tipoDocResponsable", "36");
                emisor.put("numeroDocResponsable", nit_emisor);
                emisor.put("tipoEstablecimiento", parametroService.findById("MH_ESTABLECIMIENTO").map(Parametro::getValor).orElse("01"));
                emisor.put("telefono", telefono_emisor);
                emisor.put("correo", correo_emisor);
                emisor.put("codEstableMH", parametroService.findById("MH_ESTABLE_DEFAULT").map(Parametro::getValor).orElse("M001"));
                emisor.put("codPuntoVenta", parametroService.findById("MH_PUNTO_DEFAULT").map(Parametro::getValor).orElse("P001"));

                jsonApi.set("emisor", emisor);


                ObjectNode motivo = mapper.createObjectNode();
                motivo.put("fInicio", contingencia.getfInicio().toString());
                motivo.put("fFin", contingencia.getfFin().toString());
                motivo.put("hInicio", "00:00:00");
                motivo.put("hFin", "00:00:00");
                motivo.put("tipoContingencia", contingencia.getTipoContingencia().getId());
                motivo.put("motivoContingencia", contingencia.getMotivoContingencia());
                jsonApi.set("motivo", motivo);

                jsonGenerado = jsonApi.toPrettyString();
                return jsonGenerado;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "ERROR";
        }
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
            Contingencia contingencia = contingenciaService.findByCodigoGeneracion(venta.getCodigoGeneracionContingencia());

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

        String tipoDocumentoReceptor = "";
        switch (venta.getTipoDocFactura() == null ? "" : venta.getTipoDocFactura()){
            case "DUI":
                tipoDocumentoReceptor = "13";
                break;
            case "NIT":
                tipoDocumentoReceptor = "36";
                break;
            case "NRC":
                tipoDocumentoReceptor = "37";
                break;
            default:
                tipoDocumentoReceptor = "";
                break;
        }

        receptor.putNull("nrc");

        if(venta.getTipoDocFactura() == null){
            receptor.putNull("tipoDocumento");
            receptor.putNull("numDocumento");
        }else if(venta.getTipoDocFactura().equals("NRC")){
            receptor.put("tipoDocumento", "36");
            receptor.put("numDocumento", venta.getCliente().getNit().replace("-", ""));
        }else{
            receptor.put("tipoDocumento", tipoDocumentoReceptor.isEmpty() ? null : tipoDocumentoReceptor);
            receptor.put("numDocumento", venta.getDocFactura() == null ? null : venta.getDocFactura());
        }

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
            item.put("descripcion", vt.getDescripcion());
            item.put("cantidad", vt.getCantidad());

            //Unidad de medida 59, (Unidad)
            item.put("uniMedida", 59);
            if(vt.getPrecioIncluyeIva() == 1){
                item.put("precioUni", vt.getPrecioUnitario().add(vt.getIva()));
                item.put("ventaGravada", vt.getTotalLinea());

            }else{
                item.put("precioUni", vt.getPrecioUnitario());
                item.put("ventaGravada", vt.getTotalLinea());
            }
            item.put("montoDescu", vt.getDescuento());
            item.put("ventaNoSuj", 0.0);
            item.put("ventaExenta", 0.0);
            item.putNull("tributos");
            item.put("ivaItem", vt.getIva());
            item.put("psv", 0.0);
            item.put("noGravado", 0.0);
        }


        // ========== RESUMEN ==========
        ObjectNode resumen = root.putObject("resumen");
        resumen.put("totalNoSuj", 0.0);
        resumen.put("totalExenta", 0.0);
        resumen.put("totalGravada", venta.getTotal());
        resumen.put("subTotalVentas", venta.getTotal());
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

        resumen.put("subTotal", venta.getTotal());
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
        String json = root.toString();

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
            item.put("descripcion", vt.getDescripcion());
            item.put("cantidad", vt.getCantidad());

            //Unidad de medida 59, (Unidad)
            item.put("uniMedida", 59);
            item.put("montoDescu", vt.getDescuento());

            if(vt.getPrecioIncluyeIva() == 0){
                item.put("precioUni", vt.getPrecioUnitario().subtract(vt.getIva()));
                item.put("ventaGravada", vt.getSubTotal());

            }else{
                item.put("precioUni", vt.getPrecioUnitario());
                item.put("ventaGravada", vt.getSubTotal());
            }

            item.put("ventaNoSuj", 0.0);
            item.put("ventaExenta", 0.0);
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
            item.put("descripcion", vt.getDescripcion());
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
