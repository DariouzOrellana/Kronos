package com.masterKey.kronos.service.TipoInvalidacionService;

import com.masterKey.kronos.model.TipoInvalidacion;
import com.masterKey.kronos.repository.TipoInvalidacionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TipoInvalidacionServiceImpl implements TipoInvalidacionService{

    private final TipoInvalidacionRepository tipoInvalidacionRepository;

    @Autowired
    public TipoInvalidacionServiceImpl(TipoInvalidacionRepository tipoInvalidacionRepository) {
        this.tipoInvalidacionRepository = tipoInvalidacionRepository;
    }

    @Override
    public List<TipoInvalidacion> findAll(){
        return tipoInvalidacionRepository.findAllByOrderByIdAsc();
    }
}
