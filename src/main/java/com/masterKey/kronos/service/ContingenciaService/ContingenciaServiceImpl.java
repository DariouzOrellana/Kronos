package com.masterKey.kronos.service.ContingenciaService;

import com.masterKey.kronos.model.Contingencia;
import com.masterKey.kronos.repository.ContingenciaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ContingenciaServiceImpl implements ContingenciaService{

    private final ContingenciaRepository contingenciaRepository;

    @Autowired
    public ContingenciaServiceImpl(ContingenciaRepository contingenciaRepository) {
        this.contingenciaRepository = contingenciaRepository;
    }

    @Override
    public List<Contingencia> findAllOrderByIdDesc(){
        return contingenciaRepository.findAllByOrderByIdDesc();
    }

    @Override
    public Contingencia save(Contingencia contingencia){
        return contingenciaRepository.save(contingencia);
    }

    @Override
    public Contingencia findById(Long id){
        return contingenciaRepository.findById(id).get();
    }
    @Override
    public Contingencia findByCodigoGeneracion(String codigoGeneracion){
        return contingenciaRepository.findByCodigoGeneracion(codigoGeneracion);
    }
}
