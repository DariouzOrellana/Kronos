package com.masterKey.kronos.service.ContadorDteService;

import com.masterKey.kronos.model.ContadorDte.ContadorDte;
import com.masterKey.kronos.model.ContadorDte.ContadorDteId;

import java.util.Optional;

public interface ContadorDteService {
    ContadorDte save(ContadorDte contadorDte);
    Optional<ContadorDte> findById(ContadorDteId id);
}
