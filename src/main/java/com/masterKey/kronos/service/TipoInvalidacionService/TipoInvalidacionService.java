package com.masterKey.kronos.service.TipoInvalidacionService;

import com.masterKey.kronos.model.TipoInvalidacion;

import java.util.List;
import java.util.Optional;

public interface TipoInvalidacionService {
    List<TipoInvalidacion> findAll();
    Optional<TipoInvalidacion> findById(Long id);
}
