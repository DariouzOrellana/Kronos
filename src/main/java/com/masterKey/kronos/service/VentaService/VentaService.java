package com.masterKey.kronos.service.VentaService;

import com.masterKey.kronos.model.Venta;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

public interface VentaService {
    public List<Venta> findAllByFechaBetween(LocalDateTime desde, LocalDateTime hasta);
    public Venta save(Venta venta);
    public List<Venta> findByContingencia(Integer contingencia);
    public List<Venta> findByIdIn(List<Long> ids);
    public Venta findById(Long id);
    public List<Venta> findElegiblesNotaCredito();
    public List<Venta> findElegiblesNotaCreditoByCliente(Long clienteId);
    public List<Venta> findElegiblesNotaCreditoDte();
    public List<Venta> findElegiblesNotaCreditoDteByCliente(Long clienteId);

}
