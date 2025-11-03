package com.masterKey.kronos.service.InvalidacionService;

import com.masterKey.kronos.model.Invalidacion;
import com.masterKey.kronos.repository.InvalidacionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class InvalidacionServiceImpl implements InvalidacionService{

    private final InvalidacionRepository invalidacionRepository;

    @Autowired
    public InvalidacionServiceImpl(InvalidacionRepository invalidacionRepository) {
        this.invalidacionRepository = invalidacionRepository;
    }

    @Override
    public void save(Invalidacion invalidacion) {
        invalidacionRepository.save(invalidacion);
    }

    @Override
    public Invalidacion findByVentaId(Long id){
        return invalidacionRepository.findByVentaId(id);
    }

    @Override
    public List<Invalidacion> findAll(){
        return invalidacionRepository.findAll();
    }

}
