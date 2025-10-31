package com.masterKey.kronos.service.TipoDocumentoService;

import com.masterKey.kronos.model.TipoDocumento;

import java.util.List;
import java.util.Optional;

public interface TipoDocumentoService {
    List<TipoDocumento> findAll();
    Optional<TipoDocumento> findById(String id);
}
