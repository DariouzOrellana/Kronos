package com.masterKey.kronos.repository;

import com.masterKey.kronos.model.Contingencia;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ContingenciaRepository extends JpaRepository<Contingencia, Long> {
    List<Contingencia> findAllByOrderByIdDesc();
    Contingencia findByCodigoGeneracion(String codigo);
}
