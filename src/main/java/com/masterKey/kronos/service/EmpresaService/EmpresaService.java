package com.masterKey.kronos.service.EmpresaService;

import com.masterKey.kronos.model.Empresa;

import java.util.List;
import java.util.Optional;

public interface EmpresaService {
    List<Empresa> findAll();
    Optional<Empresa> findById(Long id);
    Empresa save(Empresa empresa);
    void deleteById(Long id);
}
