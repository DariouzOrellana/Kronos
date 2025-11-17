package com.masterKey.kronos.service.ContadorDteService;

import com.masterKey.kronos.model.ContadorDte.ContadorDte;
import com.masterKey.kronos.model.ContadorDte.ContadorDteId;

public interface ContadorDteService {
    ContadorDte save(ContadorDte contadorDte);
    ContadorDte findById(ContadorDteId id);
}
