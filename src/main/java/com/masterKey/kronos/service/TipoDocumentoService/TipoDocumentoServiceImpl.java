package com.masterKey.kronos.service.TipoDocumentoService;

import com.masterKey.kronos.model.TipoDocumento;
import com.masterKey.kronos.repository.TipoDocumentoRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class TipoDocumentoServiceImpl implements TipoDocumentoService {

    private final TipoDocumentoRepository tipoDocumentoRepository;

    public TipoDocumentoServiceImpl(TipoDocumentoRepository tipoDocumentoRepository) {
        this.tipoDocumentoRepository = tipoDocumentoRepository;
    }

    @Override
    public List<TipoDocumento> findAll() {
        return tipoDocumentoRepository.findAll();
    }

    @Override
    public Optional<TipoDocumento> findById(String id) {
        return tipoDocumentoRepository.findById(id);
    }
}
