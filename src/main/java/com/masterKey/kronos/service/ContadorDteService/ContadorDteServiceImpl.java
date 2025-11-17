package com.masterKey.kronos.service.ContadorDteService;

import com.masterKey.kronos.model.ContadorDte.ContadorDte;
import com.masterKey.kronos.model.ContadorDte.ContadorDteId;
import com.masterKey.kronos.repository.ContadorDteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ContadorDteServiceImpl implements ContadorDteService{

    private final ContadorDteRepository contadorDteRepository;

    @Autowired
    public ContadorDteServiceImpl(ContadorDteRepository contadorDteRepository) {
        this.contadorDteRepository = contadorDteRepository;
    }

    @Override
    public ContadorDte save(ContadorDte contadorDte) {
        contadorDteRepository.save(contadorDte);
        return contadorDte;
    }

    @Override
    public ContadorDte findById(ContadorDteId id){
        return contadorDteRepository.findById(id).get();
    }

}
