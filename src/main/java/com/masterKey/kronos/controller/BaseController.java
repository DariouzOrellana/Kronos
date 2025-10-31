package com.masterKey.kronos.controller;

import com.masterKey.kronos.model.Usuario;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;


@Controller
public abstract class BaseController {


    @ModelAttribute
    public void addCommonAttributes(Model model, HttpSession session) {

        Usuario userAuth = (Usuario) session.getAttribute("userAuth");
        model.addAttribute("userAuth", userAuth);
    }
}
