package com.masterKey.kronos.service.ClienteService;

import com.masterKey.kronos.model.Cliente;

import java.util.List;
import java.util.Optional;

public interface ClienteService {
    List<Cliente> findAll();
    Optional<Cliente> findById(Long id);
    Cliente save(Cliente cliente);
    void deleteById(Long id);
}
