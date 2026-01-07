package com.masterKey.kronos.service.InvalidacionService;

import com.masterKey.kronos.model.Invalidacion;

import java.util.List;

public interface InvalidacionService {
    Invalidacion save(Invalidacion invalidacion);
    Invalidacion findByVentaId(Long id);
    List<Invalidacion> findAll();
}
