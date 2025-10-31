package com.masterKey.kronos.service.ProductoService;

import com.masterKey.kronos.model.Producto;

import java.util.List;
import java.util.Optional;

public interface ProductoService {

    public List<Producto> findAll();
    Optional<Producto> findById(Long id);
}
