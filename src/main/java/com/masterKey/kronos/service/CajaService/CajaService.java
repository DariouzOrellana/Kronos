package com.masterKey.kronos.service.CajaService;

import com.masterKey.kronos.model.Caja;

import java.util.List;
import java.util.Optional;

public interface CajaService {
    List<Caja> findAll();
    Optional<Caja> findById(Long id);
    Caja save(Caja caja);
    void deleteById(Long id);
}
