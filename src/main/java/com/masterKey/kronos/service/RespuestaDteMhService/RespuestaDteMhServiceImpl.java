package com.masterKey.kronos.service.RespuestaDteMhService;

import com.masterKey.kronos.model.RespuestaDteMh;
import com.masterKey.kronos.repository.RespuestaDteMhRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class RespuestaDteMhServiceImpl implements RespuestaDteMhService{
    private final RespuestaDteMhRepository respuestaDteMhRepository;

    @Autowired
    public RespuestaDteMhServiceImpl(RespuestaDteMhRepository respuestaDteMhRepository) {
        this.respuestaDteMhRepository = respuestaDteMhRepository;
    }

    @Override
    public void save(RespuestaDteMh respuestaDteMh) {
        respuestaDteMhRepository.save(respuestaDteMh);
    }
}
