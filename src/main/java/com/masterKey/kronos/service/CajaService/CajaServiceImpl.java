package com.masterKey.kronos.service.CajaService;

import com.masterKey.kronos.model.Caja;
import com.masterKey.kronos.repository.CajaRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class CajaServiceImpl implements CajaService {

    private final CajaRepository cajaRepository;

    public CajaServiceImpl(CajaRepository cajaRepository) {
        this.cajaRepository = cajaRepository;
    }

    @Override
    public List<Caja> findAll() {
        return cajaRepository.findAll();
    }

    @Override
    public Optional<Caja> findById(Long id) {
        return cajaRepository.findById(id);
    }

    @Override
    public Caja save(Caja caja) {
        return cajaRepository.save(caja);
    }

    @Override
    public void deleteById(Long id) {
        cajaRepository.deleteById(id);
    }
}
