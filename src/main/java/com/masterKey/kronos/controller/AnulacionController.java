package com.masterKey.kronos.controller;


import com.masterKey.kronos.model.Contingencia;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@Controller
@RequestMapping("/anulacion")
public class AnulacionController extends BaseController{

    public AnulacionController() {
    }

    @PostMapping("/guardar")
    public ResponseEntity<?> guardarAnulacion(
            @RequestBody Map<String, Object> payload
    ){
        Map<String, Object> res = new HashMap<>();
        try {

            res.put("ok", true);
            res.put("message", "Anulacion guardada exitosamente");
            return ResponseEntity.ok(res);
        } catch (Exception ex) {
            res.put("ok", false);
            res.put("message", "Error al actualizar: " + ex.getMessage());
            return ResponseEntity.internalServerError().body(res);
        }
    }
}
