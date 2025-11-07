package com.masterKey.kronos.service.SucursalService;

import com.masterKey.kronos.model.Sucursal;

import java.util.List;
import java.util.Optional;

public interface SucursalService {
    List<Sucursal> findAll();
    Optional<Sucursal> findById(Long id);
    Sucursal save(Sucursal sucursal);
    void deleteById(Long id);
}
