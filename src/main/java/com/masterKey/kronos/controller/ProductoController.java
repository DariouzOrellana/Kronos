package com.masterKey.kronos.controller;

import com.masterKey.kronos.model.Producto;
import com.masterKey.kronos.service.ProductoService.ProductoService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@Controller
@RequestMapping("/productos")
public class ProductoController extends BaseController {

    private final ProductoService productoService;

    public ProductoController(ProductoService productoService) {
        this.productoService = productoService;
    }

    @GetMapping
    public String listar(Model model, HttpSession session) {
        model.addAttribute("title", "Productos");
        model.addAttribute("productos", productoService.findAll());
        return "productos/ver_productos";
    }

    @GetMapping("/crear")
    public String crear(Model model, HttpSession session) {
        model.addAttribute("title", "Crear Producto");
        model.addAttribute("producto", new Producto());
        return "productos/crear_producto";
    }

    @PostMapping("/guardar")
    public String guardar(@ModelAttribute("producto") Producto producto,
                          BindingResult result, Model model) {
        if (result.hasErrors()) {
            model.addAttribute("title", "Crear Producto");
            return "productos/crear_producto";
        }
        // Evitar IDs accidentales en creación
        producto.setId(null);
        productoService.save(producto);
        return "redirect:/productos";
    }

    @GetMapping("/{id}/editar")
    public String editar(@PathVariable Long id, Model model) {
        Optional<Producto> opt = productoService.findById(id);
        if (opt.isEmpty()) {
            return "redirect:/productos";
        }
        model.addAttribute("title", "Editar Producto");
        model.addAttribute("producto", opt.get());
        return "productos/editar_producto";
    }

    @PostMapping("/{id}/actualizar")
    public String actualizar(@PathVariable Long id,
                             @ModelAttribute("producto") Producto producto,
                             BindingResult result, Model model) {
        if (result.hasErrors()) {
            model.addAttribute("title", "Editar Producto");
            return "productos/editar_producto";
        }
        producto.setId(id);
        productoService.save(producto);
        return "redirect:/productos";
    }

    @PostMapping("/{id}/eliminar")
    public String eliminar(@PathVariable Long id) {
        productoService.deleteById(id);
        return "redirect:/productos";
    }
}
