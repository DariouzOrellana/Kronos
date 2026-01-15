package com.masterKey.kronos.repository;

import com.masterKey.kronos.model.Sucursal;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface SucursalRepository extends JpaRepository<Sucursal, Long> {
    boolean existsByEstablecimientoMhIgnoreCase(String establecimientoMh);
    boolean existsByEstablecimientoMhIgnoreCaseAndIdNot(String establecimientoMh, Long id);
    List<Sucursal> findAllByEstado(Integer estado);
    List<Sucursal> findAllByEmpresaIdAndEstado(Long empresaId, Integer estado);
}
