package com.masterKey.kronos.service.TipoContingenciaService;

import com.masterKey.kronos.model.TipoContingencia;
import com.masterKey.kronos.repository.TipoContingenciaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class TipoContingenciaServiceImpl implements TipoContingenciaService{

    private final TipoContingenciaRepository tipoContingenciaRepository;

    @Autowired
    public TipoContingenciaServiceImpl(TipoContingenciaRepository tipoContingenciaRepository) {
        this.tipoContingenciaRepository = tipoContingenciaRepository;
    }

    @Override
    public List<TipoContingencia> findAll(){
        return tipoContingenciaRepository.findAll();
    }

    @Override
    public Optional<TipoContingencia> findById(Long id) {
        return tipoContingenciaRepository.findById(id);
    }

}
