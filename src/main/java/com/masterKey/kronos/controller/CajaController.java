package com.masterKey.kronos.controller;

import com.masterKey.kronos.model.Caja;
import com.masterKey.kronos.model.Sucursal;
import com.masterKey.kronos.service.CajaService.CajaService;
import com.masterKey.kronos.repository.CajaRepository;
import com.masterKey.kronos.repository.SucursalRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/cajas")
public class CajaController extends BaseController {

    private final CajaService cajaService;
    private final SucursalRepository sucursalRepository;
    private final CajaRepository cajaRepository;

    public CajaController(CajaService cajaService, SucursalRepository sucursalRepository, CajaRepository cajaRepository) {
        this.cajaService = cajaService;
        this.sucursalRepository = sucursalRepository;
        this.cajaRepository = cajaRepository;
    }

    @GetMapping
    public String listar(Model model, HttpSession session) {
        model.addAttribute("title", "Cajas");
        model.addAttribute("cajas", cajaService.findAll());
        return "cajas/ver_cajas";
    }

    @GetMapping("/crear")
    public String crear(Model model, HttpSession session) {
        model.addAttribute("title", "Crear Caja");
        model.addAttribute("caja", new Caja());
        cargarSucursales(model);
        return "cajas/crear_caja";
    }

    @PostMapping("/guardar")
    public String guardar(@ModelAttribute("caja") Caja caja,
                          @RequestParam(value = "sucursalId", required = false) Long sucursalId,
                          BindingResult result,
                          Model model) {
        if (result.hasErrors()) {
            model.addAttribute("title", "Crear Caja");
            cargarSucursales(model);
            return "cajas/crear_caja";
        }
        // Normalizar PV
        if (caja.getPuntoVentaMh() != null) {
            caja.setPuntoVentaMh(caja.getPuntoVentaMh().trim().toUpperCase());
        }
        if (sucursalId != null) {
            Optional<Sucursal> suc = sucursalRepository.findById(sucursalId);
            suc.ifPresent(caja::setSucursal);
        } else {
            caja.setSucursal(null);
        }
        if (caja.getSucursal() == null) {
            model.addAttribute("title", "Crear Caja");
            cargarSucursales(model);
            model.addAttribute("sucursalError", "Debe seleccionar una sucursal");
            return "cajas/crear_caja";
        }
        // Unicidad PV por sucursal (solo si ambos presentes)
        if (caja.getSucursal() != null && caja.getPuntoVentaMh() != null && !caja.getPuntoVentaMh().isEmpty()) {
            boolean exists = cajaRepository.existsBySucursalIdAndPuntoVentaMhIgnoreCase(caja.getSucursal().getId(), caja.getPuntoVentaMh());
            if (exists) {
                result.rejectValue("puntoVentaMh", "duplicate", "Ya existe una caja con ese Punto de venta MH en la misma sucursal");
                model.addAttribute("title", "Crear Caja");
                cargarSucursales(model);
                return "cajas/crear_caja";
            }
        }
        caja.setId(null);
        cajaService.save(caja);
        return "redirect:/cajas";
    }

    @GetMapping("/{id}/editar")
    public String editar(@PathVariable Long id, Model model) {
        Optional<Caja> opt = cajaService.findById(id);
        if (opt.isEmpty()) {
            return "redirect:/cajas";
        }
        model.addAttribute("title", "Editar Caja");
        model.addAttribute("caja", opt.get());
        cargarSucursales(model);
        return "cajas/editar_caja";
    }

    @PostMapping("/{id}/actualizar")
    public String actualizar(@PathVariable Long id,
                             @ModelAttribute("caja") Caja caja,
                             @RequestParam(value = "sucursalId", required = false) Long sucursalId,
                             BindingResult result,
                             Model model) {
        if (result.hasErrors()) {
            model.addAttribute("title", "Editar Caja");
            cargarSucursales(model);
            return "cajas/editar_caja";
        }
        if (caja.getPuntoVentaMh() != null) {
            caja.setPuntoVentaMh(caja.getPuntoVentaMh().trim().toUpperCase());
        }
        if (sucursalId != null) {
            sucursalRepository.findById(sucursalId).ifPresent(caja::setSucursal);
        } else {
            caja.setSucursal(null);
        }
        if (caja.getSucursal() == null) {
            model.addAttribute("title", "Editar Caja");
            cargarSucursales(model);
            model.addAttribute("sucursalError", "Debe seleccionar una sucursal");
            return "cajas/editar_caja";
        }
        // Unicidad PV excluyendo el propio id
        if (caja.getSucursal() != null && caja.getPuntoVentaMh() != null && !caja.getPuntoVentaMh().isEmpty()) {
            boolean exists = cajaRepository.existsBySucursalIdAndPuntoVentaMhIgnoreCaseAndIdNot(caja.getSucursal().getId(), caja.getPuntoVentaMh(), id);
            if (exists) {
                result.rejectValue("puntoVentaMh", "duplicate", "Ya existe una caja con ese Punto de venta MH en la misma sucursal");
                model.addAttribute("title", "Editar Caja");
                cargarSucursales(model);
                return "cajas/editar_caja";
            }
        }
        caja.setId(id);
        cajaService.save(caja);
        return "redirect:/cajas";
    }

    @PostMapping("/{id}/eliminar")
    public String eliminar(@PathVariable Long id) {
        cajaService.deleteById(id);
        return "redirect:/cajas";
    }

    private void cargarSucursales(Model model) {
        List<Sucursal> sucursalesActivas = sucursalRepository.findAllByEstado(1);
        // Si estamos en edición y la sucursal asociada está inactiva, incluirla para no romper el select
        Object cajaObj = model.getAttribute("caja");
        if (cajaObj instanceof Caja) {
            Sucursal suc = ((Caja) cajaObj).getSucursal();
            if (suc != null && suc.getId() != null && (suc.getEstado() == null || suc.getEstado() != 1)) {
                boolean yaIncluida = sucursalesActivas.stream().anyMatch(s -> s.getId().equals(suc.getId()));
                if (!yaIncluida) {
                    sucursalesActivas.add(suc);
                }
            }
        }
        model.addAttribute("sucursales", sucursalesActivas);
    }

    @GetMapping("/by-sucursal/{sucursalId}")
    @ResponseBody
    public List<Caja> listarPorSucursal(@PathVariable Long sucursalId) {
        return cajaRepository.findAllBySucursalId(sucursalId);
    }
}
