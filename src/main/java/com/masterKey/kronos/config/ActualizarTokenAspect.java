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

    // Aplica a cualquier méto do de HomeController
    @Pointcut("execution(* com.masterKey.kronos.controller.HomeController.*(..))")
    public void anyHomeControllerMethod() {}

    // Ejecuta antes de cada méto do del HomeController
    @Before("anyHomeControllerMethod()")
    public void actualizarTokenAntesDeHomeController() {
        System.out.println("-----------------------------");
        System.out.println("Actualizando token antes de HomeController");
        helperService.actualizarTokenMH();
    }
}
