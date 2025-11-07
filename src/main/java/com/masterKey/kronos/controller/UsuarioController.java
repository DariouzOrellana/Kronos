package com.masterKey.kronos.controller;

import com.masterKey.kronos.model.Usuario;
import com.masterKey.kronos.repository.CajaRepository;
import com.masterKey.kronos.repository.RolRepository;
import com.masterKey.kronos.repository.UsuarioRepository;
import com.masterKey.kronos.service.UsuarioService.UsuarioService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@Controller
@RequestMapping("/usuarios")
public class UsuarioController extends BaseController {

    private final UsuarioService usuarioService;
    private final UsuarioRepository usuarioRepository;
    private final RolRepository rolRepository;
    private final CajaRepository cajaRepository;

    public UsuarioController(UsuarioService usuarioService,
                             UsuarioRepository usuarioRepository,
                             RolRepository rolRepository,
                             CajaRepository cajaRepository) {
        this.usuarioService = usuarioService;
        this.usuarioRepository = usuarioRepository;
        this.rolRepository = rolRepository;
        this.cajaRepository = cajaRepository;
    }

    @GetMapping
    public String listar(Model model){
        model.addAttribute("title", "Usuarios");
        model.addAttribute("usuarios", usuarioService.findAll());
        return "usuarios/ver_usuarios";
        }

    @GetMapping("/crear")
    public String crear(Model model){
        model.addAttribute("title", "Crear Usuario");
        model.addAttribute("usuario", new Usuario());
        cargarCatalogos(model);
        return "usuarios/crear_usuario";
    }

    @PostMapping("/guardar")
    public String guardar(@ModelAttribute("usuario") Usuario usuario,
                          @RequestParam(value = "rolId", required = false) Long rolId,
                          @RequestParam(value = "cajaId", required = false) Long cajaId,
                          BindingResult result,
                          Model model){
        if (result.hasErrors()){
            model.addAttribute("title", "Crear Usuario");
            cargarCatalogos(model);
            return "usuarios/crear_usuario";
        }
        if (usuario.getUsername() != null){
            usuario.setUsername(usuario.getUsername().trim());
        }
        if (usuario.getUsername() == null || usuario.getUsername().isBlank()){
            model.addAttribute("usernameError", "El nombre de usuario es obligatorio");
            model.addAttribute("title", "Crear Usuario");
            cargarCatalogos(model);
            return "usuarios/crear_usuario";
        }
        if (usuarioRepository.findByUsername(usuario.getUsername()).isPresent()){
            model.addAttribute("usernameError", "El nombre de usuario ya existe");
            model.addAttribute("title", "Crear Usuario");
            cargarCatalogos(model);
            return "usuarios/crear_usuario";
        }
        if (rolId != null) rolRepository.findById(rolId).ifPresent(usuario::setRol);
        if (cajaId != null) cajaRepository.findById(cajaId).ifPresent(usuario::setCaja);
        usuario.setId(null);
        usuarioService.save(usuario);
        return "redirect:/usuarios";
    }

    @GetMapping("/{id}/editar")
    public String editar(@PathVariable Long id, Model model){
        Optional<Usuario> opt = usuarioService.findById(id);
        if (opt.isEmpty()) return "redirect:/usuarios";
        model.addAttribute("title", "Editar Usuario");
        model.addAttribute("usuario", opt.get());
        cargarCatalogos(model);
        return "usuarios/editar_usuario";
    }

    @PostMapping("/{id}/actualizar")
    public String actualizar(@PathVariable Long id,
                             @ModelAttribute("usuario") Usuario usuario,
                             @RequestParam(value = "rolId", required = false) Long rolId,
                             @RequestParam(value = "cajaId", required = false) Long cajaId,
                             BindingResult result,
                             Model model){
        if (result.hasErrors()){
            model.addAttribute("title", "Editar Usuario");
            cargarCatalogos(model);
            return "usuarios/editar_usuario";
        }
        Optional<Usuario> currentOpt = usuarioService.findById(id);
        if (currentOpt.isEmpty()) return "redirect:/usuarios";
        Usuario current = currentOpt.get();
        if (usuario.getUsername() != null){
            usuario.setUsername(usuario.getUsername().trim());
        }
        if (usuario.getUsername() == null || usuario.getUsername().isBlank()){
            model.addAttribute("usernameError", "El nombre de usuario es obligatorio");
            model.addAttribute("title", "Editar Usuario");
            cargarCatalogos(model);
            return "usuarios/editar_usuario";
        }
        usuarioRepository.findByUsername(usuario.getUsername()).ifPresent(u -> {
            if (!u.getId().equals(id)){
                model.addAttribute("usernameError", "El nombre de usuario ya existe");
            }
        });
        if (model.containsAttribute("usernameError")){
            model.addAttribute("title", "Editar Usuario");
            cargarCatalogos(model);
            return "usuarios/editar_usuario";
        }
        if (rolId != null) rolRepository.findById(rolId).ifPresent(usuario::setRol);
        else usuario.setRol(null);
        if (cajaId != null) cajaRepository.findById(cajaId).ifPresent(usuario::setCaja);
        else usuario.setCaja(null);
        if (usuario.getPassword() == null || usuario.getPassword().isBlank()){
            usuario.setPassword(current.getPassword());
        }
        usuario.setId(id);
        usuarioService.save(usuario);
        return "redirect:/usuarios";
    }

    @PostMapping("/{id}/eliminar")
    public String eliminar(@PathVariable Long id){
        usuarioService.deleteById(id);
        return "redirect:/usuarios";
    }

    private void cargarCatalogos(Model model){
        model.addAttribute("roles", rolRepository.findAll());
        model.addAttribute("cajas", cajaRepository.findAll());
    }
}
