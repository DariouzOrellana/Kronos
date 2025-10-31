package com.masterKey.kronos.repository;

import com.masterKey.kronos.model.TipoInvalidacion;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface TipoInvalidacionRepository extends JpaRepository<TipoInvalidacion, Long> {

    List<TipoInvalidacion> findAllByOrderByIdAsc();
}

