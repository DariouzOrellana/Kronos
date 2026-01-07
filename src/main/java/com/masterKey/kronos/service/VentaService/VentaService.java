package com.masterKey.kronos.service.VentaService;

import com.masterKey.kronos.model.Venta;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;
import java.util.Optional;

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
    public Optional<Venta> findByCodigoGeneracionAndFecha(String codigoGeneracion, LocalDate fecha);
    public java.math.BigDecimal sumTotalByFechaBetween(java.time.LocalDateTime desde, java.time.LocalDateTime hasta);
    public java.util.List<Object[]> sumTotalGroupByTipoBetween(java.time.LocalDateTime desde, java.time.LocalDateTime hasta);
    public Long countByFechaBetween(java.time.LocalDateTime desde, java.time.LocalDateTime hasta);
    public Long countByFechaBetweenAndSelloMhIsNull(java.time.LocalDateTime desde, java.time.LocalDateTime hasta);
    public java.util.List<Object[]> ventasPorClienteBetween(java.time.LocalDateTime desde, java.time.LocalDateTime hasta);
    public Long countByFechaBetweenAndContingencia(java.time.LocalDateTime desde, java.time.LocalDateTime hasta);
    public java.util.List<Object[]> countGroupByTipoBetween(java.time.LocalDateTime desde, java.time.LocalDateTime hasta);
    public java.util.List<com.masterKey.kronos.model.Venta> findByUsuario_IdAndFechaBetween(Long usuarioId, java.time.LocalDateTime desde, java.time.LocalDateTime hasta);
    public java.util.List<Object[]> sumTotalGroupByUsuarioBetween(java.time.LocalDateTime desde, java.time.LocalDateTime hasta);
    public java.util.List<Object[]> countGroupByUsuarioBetween(java.time.LocalDateTime desde, java.time.LocalDateTime hasta);

}
