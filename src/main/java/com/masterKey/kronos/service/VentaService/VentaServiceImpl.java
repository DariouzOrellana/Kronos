package com.masterKey.kronos.service.VentaService;

import com.masterKey.kronos.model.Venta;
import com.masterKey.kronos.repository.VentaRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

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
        return ventaRepository.findById(id).orElse(null);
    }

    @Override
    public Venta save(Venta venta) {
        return ventaRepository.saveAndFlush(venta);
    }

    @Override
    public List<Venta> findByContingencia(Integer contingencia){
        return ventaRepository.traerContingencias(contingencia);
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
        return ventaRepository.traerCcfParaNc("03");
    }

    @Override
    public Optional<Venta> findByCodigoGeneracionAndFecha(String codigoGeneracion, LocalDate fecha){
        return ventaRepository.findByCodigoGeneracionAndFecha(codigoGeneracion, fecha);
    }

    @Override
    public java.math.BigDecimal sumTotalByFechaBetween(java.time.LocalDateTime desde, java.time.LocalDateTime hasta){
        return ventaRepository.sumTotalByFechaBetween(desde, hasta);
    }

    @Override
    public java.util.List<Object[]> sumTotalGroupByTipoBetween(java.time.LocalDateTime desde, java.time.LocalDateTime hasta){
        return ventaRepository.sumTotalGroupByTipoBetween(desde, hasta);
    }

    @Override
    public Long countByFechaBetween(java.time.LocalDateTime desde, java.time.LocalDateTime hasta){
        return ventaRepository.countByFechaBetween(desde, hasta);
    }

    @Override
    public Long countByFechaBetweenAndSelloMhIsNull(java.time.LocalDateTime desde, java.time.LocalDateTime hasta){
        return ventaRepository.countByFechaBetweenAndSelloMhIsNull(desde, hasta);
    }

    @Override
    public java.util.List<Object[]> ventasPorClienteBetween(java.time.LocalDateTime desde, java.time.LocalDateTime hasta){
        return ventaRepository.ventasPorClienteBetween(desde, hasta);
    }

    @Override
    public Long countByFechaBetweenAndContingencia(java.time.LocalDateTime desde, java.time.LocalDateTime hasta){
        return ventaRepository.countByFechaBetweenAndContingencia(desde, hasta);
    }

    @Override
    public java.util.List<Object[]> countGroupByTipoBetween(java.time.LocalDateTime desde, java.time.LocalDateTime hasta){
        return ventaRepository.countGroupByTipoBetween(desde, hasta);
    }

    @Override
    public java.util.List<com.masterKey.kronos.model.Venta> findByUsuario_IdAndFechaBetween(Long usuarioId, java.time.LocalDateTime desde, java.time.LocalDateTime hasta){
        return ventaRepository.findByUsuario_IdAndFechaBetween(usuarioId, desde, hasta);
    }

    @Override
    public java.util.List<Object[]> sumTotalGroupByUsuarioBetween(java.time.LocalDateTime desde, java.time.LocalDateTime hasta){
        return ventaRepository.sumTotalGroupByUsuarioBetween(desde, hasta);
    }

    @Override
    public java.util.List<Object[]> countGroupByUsuarioBetween(java.time.LocalDateTime desde, java.time.LocalDateTime hasta){
        return ventaRepository.countGroupByUsuarioBetween(desde, hasta);
    }


    @Override
    public List<Venta> findElegiblesNotaCreditoDteByCliente(Long clienteId) {
        return ventaRepository.findByVentaIdNcIsNullAndTipoDocumento_IdAndSelloMhIsNotNullAndCliente_IdOrderByFechaDesc("03", clienteId);
    }

}
