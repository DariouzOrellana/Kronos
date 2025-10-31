package com.masterKey.kronos.service.ParametroService;

import com.masterKey.kronos.model.Parametro;

import java.util.Optional;

public interface ParametroService {
    Optional<Parametro> findById(String id);
    Parametro save(Parametro parametro);
}
