package com.masterKey.kronos.repository;

import com.masterKey.kronos.model.Venta;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.math.BigDecimal;
import java.util.Map;
import java.util.Date;
import java.util.List;
import java.util.Optional;

public interface VentaRepository extends JpaRepository<Venta, Long> {
    List<Venta> findAllByFechaBetween(LocalDateTime desde, LocalDateTime hasta);
        List<Venta> findByUsuario_IdAndFechaBetween(Long usuarioId, LocalDateTime desde, LocalDateTime hasta);

    @Query(value = """
            SELECT * FROM VENTA
            WHERE CONTINGENCIA = :contingencia 
            AND CODIGO_GENERACION_CONTINGENCIA IS NULL
            ORDER BY ID DESC
                        """, nativeQuery = true)
    List<Venta> traerContingencias(@Param("contingencia") Integer contingencia);
    List<Venta> findByIdIn(List<Long> ids);
    List<Venta> findByVentaIdNcIsNullOrderByFechaDesc();
    List<Venta> findByVentaIdNcIsNullAndCliente_IdOrderByFechaDesc(Long clienteId);

    @Query(value = "SELECT * FROM VENTA\n" +
            "WHERE TIPO_DOCUMENTO_ID = :tipoDocumentoId\n" +
            "AND SELLO_MH IS NOT NULL\n" +
            "AND ID NOT IN (\n" +
            "SELECT VENTA_ID_NC FROM VENTA WHERE VENTA_ID_NC IS NOT NULL\n" +
            ") ORDER BY ID DESC", nativeQuery = true)
    List<Venta> traerCcfParaNc(String tipoDocumentoId);

    @Query(value = "SELECT * FROM VENTA WHERE CODIGO_GENERACION = :codigoGeneracion\n" +
            "AND date_trunc('day',FECHA) = :fecha", nativeQuery = true)
    Optional<Venta> findByCodigoGeneracionAndFecha(@Param("codigoGeneracion") String codigoGeneracion,
                                                   @Param("fecha") LocalDate fecha);

    List<Venta> findByVentaIdNcIsNullAndTipoDocumento_IdAndSelloMhIsNotNullAndCliente_IdOrderByFechaDesc(String tipoDocumentoId, Long clienteId);

        @Query(value = "SELECT COALESCE(SUM(total),0) FROM VENTA WHERE fecha BETWEEN :desde AND :hasta", nativeQuery = true)
        BigDecimal sumTotalByFechaBetween(@Param("desde") LocalDateTime desde, @Param("hasta") LocalDateTime hasta);

        @Query(value = "SELECT td.NOMBRE as tipo, COALESCE(SUM(v.total),0) as total FROM VENTA v JOIN TIPO_DOCUMENTO td ON v.TIPO_DOCUMENTO_ID = td.ID WHERE v.fecha BETWEEN :desde AND :hasta GROUP BY td.NOMBRE ORDER BY total DESC", nativeQuery = true)
        List<Object[]> sumTotalGroupByTipoBetween(@Param("desde") LocalDateTime desde, @Param("hasta") LocalDateTime hasta);

        @Query(value = "SELECT c.NOMBRE_CLIENTE as cliente, COUNT(*) as cantidad, COALESCE(SUM(v.total),0) as total FROM VENTA v JOIN CLIENTE c ON v.CLIENTE_ID = c.ID WHERE v.fecha BETWEEN :desde AND :hasta GROUP BY c.NOMBRE_CLIENTE ORDER BY total DESC", nativeQuery = true)
        List<Object[]> ventasPorClienteBetween(@Param("desde") LocalDateTime desde, @Param("hasta") LocalDateTime hasta);

        @Query(value = "SELECT COUNT(*) FROM VENTA WHERE fecha BETWEEN :desde AND :hasta AND CONTINGENCIA IS NOT NULL AND CONTINGENCIA <> 0", nativeQuery = true)
        Long countByFechaBetweenAndContingencia(@Param("desde") LocalDateTime desde, @Param("hasta") LocalDateTime hasta);

        @Query(value = "SELECT td.NOMBRE as tipo, COUNT(*) as cantidad FROM VENTA v JOIN TIPO_DOCUMENTO td ON v.TIPO_DOCUMENTO_ID = td.ID WHERE v.fecha BETWEEN :desde AND :hasta GROUP BY td.NOMBRE ORDER BY cantidad DESC", nativeQuery = true)
        List<Object[]> countGroupByTipoBetween(@Param("desde") LocalDateTime desde, @Param("hasta") LocalDateTime hasta);

        @Query(value = "SELECT COUNT(*) FROM VENTA WHERE fecha BETWEEN :desde AND :hasta", nativeQuery = true)
        Long countByFechaBetween(@Param("desde") LocalDateTime desde, @Param("hasta") LocalDateTime hasta);

        @Query(value = "SELECT COUNT(*) FROM VENTA WHERE fecha BETWEEN :desde AND :hasta AND SELLO_MH IS NULL", nativeQuery = true)
        Long countByFechaBetweenAndSelloMhIsNull(@Param("desde") LocalDateTime desde, @Param("hasta") LocalDateTime hasta);

        @Query(value = "SELECT u.USERNAME as usuario, COALESCE(SUM(v.total),0) as total FROM VENTA v JOIN USUARIO u ON v.USUARIO_ID = u.ID WHERE v.fecha BETWEEN :desde AND :hasta GROUP BY u.USERNAME ORDER BY total DESC", nativeQuery = true)
        List<Object[]> sumTotalGroupByUsuarioBetween(@Param("desde") LocalDateTime desde, @Param("hasta") LocalDateTime hasta);
        @Query(value = "SELECT u.USERNAME as usuario, COUNT(*) as cantidad FROM VENTA v JOIN USUARIO u ON v.USUARIO_ID = u.ID WHERE v.fecha BETWEEN :desde AND :hasta GROUP BY u.USERNAME ORDER BY cantidad DESC", nativeQuery = true)
        List<Object[]> countGroupByUsuarioBetween(@Param("desde") LocalDateTime desde, @Param("hasta") LocalDateTime hasta);
}
