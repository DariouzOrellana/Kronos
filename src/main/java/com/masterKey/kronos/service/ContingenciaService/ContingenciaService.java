package com.masterKey.kronos.service.ContingenciaService;

import com.masterKey.kronos.model.Contingencia;

import java.util.List;

public interface ContingenciaService {
    public Contingencia save(Contingencia contingencia);
    public List<Contingencia> findAllOrderByIdDesc();
    Contingencia findById(Long id);
    Contingencia findByCodigoGeneracion(String codigoGeneracion);

}
