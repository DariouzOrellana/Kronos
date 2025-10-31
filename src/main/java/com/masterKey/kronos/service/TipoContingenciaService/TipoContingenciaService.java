package com.masterKey.kronos.service.TipoContingenciaService;

import com.masterKey.kronos.model.TipoContingencia;

import java.util.List;
import java.util.Optional;

public interface TipoContingenciaService {
    List<TipoContingencia>findAll();
    Optional<TipoContingencia> findById(Long id);
}
