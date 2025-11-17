package com.masterKey.kronos.service.VentaService;

import com.masterKey.kronos.model.Venta;
import com.masterKey.kronos.repository.VentaRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class VentaServiceImpl implements VentaService{

    private final VentaRepository ventaRepository;

    public VentaServiceImpl(VentaRepository ventaRepository) {
        this.ventaRepository = ventaRepository;
    }

    public List<Venta> findAllByFechaBetween(LocalDateTime desde, LocalDateTime hasta){
        return ventaRepository.findAllByFechaBetween(desde, hasta);
    }

    @Override
    public Venta findById(Long id){
        return ventaRepository.findById(id).get();
    }

    @Override
    public Venta save(Venta venta) {
        return ventaRepository.save(venta);
    }

    @Override
    public List<Venta> findByContingencia(Integer contingencia){
        return ventaRepository.findByContingenciaOrderByFechaDesc(contingencia);
    }

    @Override
    public List<Venta> findByIdIn(List<Long> ids) {
        return ventaRepository.findByIdIn(ids);
    }

    @Override
    public List<Venta> findElegiblesNotaCredito() {
        return ventaRepository.findByVentaIdNcIsNullOrderByFechaDesc();
    }

    @Override
    public List<Venta> findElegiblesNotaCreditoByCliente(Long clienteId) {
        return ventaRepository.findByVentaIdNcIsNullAndCliente_IdOrderByFechaDesc(clienteId);
    }

    @Override
    public List<Venta> findElegiblesNotaCreditoDte() {
        return ventaRepository.findByVentaIdNcIsNullAndTipoDocumento_IdAndSelloMhIsNotNullOrderByFechaDesc("03");
    }

    @Override
    public List<Venta> findElegiblesNotaCreditoDteByCliente(Long clienteId) {
        return ventaRepository.findByVentaIdNcIsNullAndTipoDocumento_IdAndSelloMhIsNotNullAndCliente_IdOrderByFechaDesc("03", clienteId);
    }

}
