package com.masterKey.kronos.config;

import com.masterKey.kronos.service.HelperService.HelperService;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.stereotype.Component;

@Aspect
@Component
public class ActualizarTokenAspect {

    private final HelperService helperService;

    public ActualizarTokenAspect(HelperService helperService) {
        this.helperService = helperService;
    }

    // Aplica a cualquier méto do de VentaController
    @Pointcut("execution(* com.masterKey.kronos.controller.VentaController.*(..)) ||" +
    "execution(* com.masterKey.kronos.controller.ContingenciaController.*(..)) ||" +
    "execution(* com.masterKey.kronos.controller.AnulacionController.*(..))"
    )
    public void anyVentaControllerMethod() {}

    // Ejecuta antes de cada méto do del HomeController
    @Before("anyVentaControllerMethod()")
    public void actualizarTokenAntesDeHomeController() {
        System.out.println("-----------------------------");
        System.out.println("Actualizando token antes de anyVentaControllerMethod");
        helperService.actualizarTokenMH();
    }
}
