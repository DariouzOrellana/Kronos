package com.masterKey.kronos.service.VentaDetalleService;

import com.masterKey.kronos.model.VentaDetalle;

import java.util.List;

public interface VentaDetalleService {
    List<VentaDetalle> saveAll(List<VentaDetalle> detalles);
}
