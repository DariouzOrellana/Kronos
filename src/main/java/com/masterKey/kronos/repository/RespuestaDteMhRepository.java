package com.masterKey.kronos.repository;

import com.masterKey.kronos.model.RespuestaDteMh;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RespuestaDteMhRepository extends JpaRepository <RespuestaDteMh, Long>{
}
