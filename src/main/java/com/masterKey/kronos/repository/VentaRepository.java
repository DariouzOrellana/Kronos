package com.masterKey.kronos.repository;

import com.masterKey.kronos.model.Venta;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

public interface VentaRepository extends JpaRepository<Venta, Long> {
    List<Venta> findAllByFechaBetween(LocalDateTime desde, LocalDateTime hasta);
    List<Venta> findByContingenciaOrderByFechaDesc(Integer contingencia);
    List<Venta> findByIdIn(List<Long> ids);
    List<Venta> findByVentaIdNcIsNullOrderByFechaDesc();
    List<Venta> findByVentaIdNcIsNullAndCliente_IdOrderByFechaDesc(Long clienteId);
    List<Venta> findByVentaIdNcIsNullAndTipoDocumento_IdAndSelloMhIsNotNullOrderByFechaDesc(String tipoDocumentoId);
    List<Venta> findByVentaIdNcIsNullAndTipoDocumento_IdAndSelloMhIsNotNullAndCliente_IdOrderByFechaDesc(String tipoDocumentoId, Long clienteId);
}
