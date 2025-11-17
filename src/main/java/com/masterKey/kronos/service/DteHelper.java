package com.masterKey.kronos.service;

import com.masterKey.kronos.model.ContadorDte.ContadorDte;
import com.masterKey.kronos.model.ContadorDte.ContadorDteId;
import com.masterKey.kronos.model.Venta;
import com.masterKey.kronos.service.ContadorDteService.ContadorDteService;
import com.masterKey.kronos.service.VentaService.VentaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
public class DteHelper {

    private JsonHelper jsonHelper;
    private VentaService ventaService;
    private ContadorDteService contadorDteService;


    @Autowired
    public DteHelper(JsonHelper jsonHelper,
                     VentaService ventaService,
                     ContadorDteService contadorDteService) {
        this.jsonHelper = jsonHelper;
        this.ventaService = ventaService;
        this.contadorDteService = contadorDteService;
    }

    public void setearNumeroControl(Long idVenta){
        Venta venta = ventaService.findById(idVenta);
        System.out.println("Verificando si tiene numero de control...");
        if(venta.getNumeroControl() == null){
            System.out.println("NO TIENE NUMERO DE CONTROL, se va  a generar uno nuevo...");

            ContadorDteId contadorDteId = new ContadorDteId(
                    venta.getTipoDocumento().getId().toString(),
                    venta.getFecha().getYear(),
                    venta.getUsuario().getCaja().getSucursal().getId().intValue());

            ContadorDte contadorDte = contadorDteService.findById(contadorDteId);

            if(contadorDte == null){
                ContadorDte contadorDteNuevo = new ContadorDte();
                contadorDteNuevo.setTipoDocumentoId(venta.getTipoDocumento().getId());
                contadorDteNuevo.setContador(1);
                contadorDteNuevo.setAnio(venta.getFecha().getYear());
                contadorDteNuevo.setSucursalId(venta.getUsuario().getCaja().getSucursal().getId().intValue());
                contadorDteService.save(contadorDteNuevo);
                contadorDte = contadorDteNuevo;
            }else{
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
