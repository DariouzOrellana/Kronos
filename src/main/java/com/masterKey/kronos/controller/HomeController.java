package com.masterKey.kronos.controller;
import com.masterKey.kronos.service.HelperService.HelperService;
import com.masterKey.kronos.service.ParametroService.ParametroService;
import com.masterKey.kronos.service.UsuarioService.UsuarioService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController extends BaseController{

    private final UsuarioService usuarioService;
    private final ParametroService parametroService;
    private final HelperService  helperService;

    @Autowired
    public HomeController(UsuarioService usuarioService,
                          ParametroService parametroService,
                          HelperService helperService) {
        this.usuarioService = usuarioService;
        this.parametroService = parametroService;
        this.helperService = helperService;
    }

    @GetMapping("/")
    public String root(Model model) {
        //model.addAttribute("title", "Home");

        return "redirect:/home";
    }

    @GetMapping("/home")
    public String home(Model model) {
        model.addAttribute("title", "Home");

        return "home";
    }

}
