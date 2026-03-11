package com.masterKey.kronos.repository;

import com.masterKey.kronos.model.Cliente;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ClienteRepository extends JpaRepository<Cliente, Long> {
    List<Cliente> findAllByEstado(Integer estado);
    List<Cliente> findByIdNot(Long id);
}
