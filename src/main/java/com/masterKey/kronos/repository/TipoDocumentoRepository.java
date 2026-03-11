package com.masterKey.kronos.repository;

import com.masterKey.kronos.model.TipoDocumento;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface TipoDocumentoRepository extends JpaRepository<TipoDocumento, String> {
    List<TipoDocumento> findByIdNot(String id);
}
