package com.masterKey.kronos.service.ParametroService;

import com.masterKey.kronos.model.Parametro;
import com.masterKey.kronos.repository.ParametroRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class ParametroServiceImpl implements ParametroService {

    private final ParametroRepository parametroRepository;

    @Autowired
    public ParametroServiceImpl(ParametroRepository parametroRepository) {
        this.parametroRepository = parametroRepository;
    }

    @Override
    public Optional<Parametro> findById(String id){
        return parametroRepository.findById(id);
    }
    @Override
    public Parametro save(Parametro parametro) {
        return parametroRepository.save(parametro);
    }

}
