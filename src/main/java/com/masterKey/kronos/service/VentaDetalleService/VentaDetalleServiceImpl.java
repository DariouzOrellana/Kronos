package com.masterKey.kronos.service.VentaDetalleService;

import com.masterKey.kronos.model.VentaDetalle;
import com.masterKey.kronos.repository.VentaDetalleRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class VentaDetalleServiceImpl implements VentaDetalleService {

    private final VentaDetalleRepository ventaDetalleRepository;

    public VentaDetalleServiceImpl(VentaDetalleRepository ventaDetalleRepository) {
        this.ventaDetalleRepository = ventaDetalleRepository;
    }

    @Override
    public List<VentaDetalle> saveAll(List<VentaDetalle> detalles) {
        return ventaDetalleRepository.saveAll(detalles);
    }
}
