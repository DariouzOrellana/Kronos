package com.masterKey.kronos.controller;

import com.masterKey.kronos.model.Empresa;
import com.masterKey.kronos.model.Sucursal;
import com.masterKey.kronos.repository.EmpresaRepository;
import com.masterKey.kronos.repository.SucursalRepository;
import com.masterKey.kronos.service.SucursalService.SucursalService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;
import java.util.regex.Pattern;

@Controller
@RequestMapping("/sucursales")
public class SucursalController extends BaseController {

    private final SucursalService sucursalService;
    private final EmpresaRepository empresaRepository;
    private final SucursalRepository sucursalRepository;

    public SucursalController(SucursalService sucursalService, EmpresaRepository empresaRepository, SucursalRepository sucursalRepository) {
        this.sucursalService = sucursalService;
        this.empresaRepository = empresaRepository;
        this.sucursalRepository = sucursalRepository;
    }

    @GetMapping
    public String listar(Model model, HttpSession session) {
        model.addAttribute("title", "Sucursales");
        model.addAttribute("sucursales", sucursalService.findAll());
        return "sucursales/ver_sucursales";
    }

    @GetMapping("/crear")
    public String crear(Model model, HttpSession session) {
        model.addAttribute("title", "Crear Sucursal");
        model.addAttribute("sucursal", new Sucursal());
        cargarEmpresas(model);
        return "sucursales/crear_sucursal";
    }

    @PostMapping("/guardar")
    public String guardar(@ModelAttribute("sucursal") Sucursal sucursal,
                          @RequestParam(value = "empresaId", required = false) Long empresaId,
                          BindingResult result,
                          Model model) {
        if (result.hasErrors()) {
            model.addAttribute("title", "Crear Sucursal");
            cargarEmpresas(model);
            return "sucursales/crear_sucursal";
        }
        // Normalizar y validar campos obligatorios
        if (sucursal.getNombreSucursal() != null) {
            sucursal.setNombreSucursal(sucursal.getNombreSucursal().trim().toUpperCase());
        }
        if (sucursal.getEstablecimientoMh() != null) {
            sucursal.setEstablecimientoMh(sucursal.getEstablecimientoMh().trim().toUpperCase());
        }

        if (sucursal.getNombreSucursal() == null || sucursal.getNombreSucursal().isEmpty()) {
            result.rejectValue("nombreSucursal", "required", "El nombre es obligatorio");
        }
        if (sucursal.getEstablecimientoMh() == null || sucursal.getEstablecimientoMh().isEmpty()) {
            result.rejectValue("establecimientoMh", "required", "El establecimiento es obligatorio");
        } else {
            Pattern estPattern = Pattern.compile("^[MS]\\d{3}$");
            if (!estPattern.matcher(sucursal.getEstablecimientoMh()).matches()) {
                result.rejectValue("establecimientoMh", "pattern", "Formato inválido. Use M001 o S001");
            }
        }
        if (empresaId != null) {
            Optional<Empresa> emp = empresaRepository.findById(empresaId);
            emp.ifPresent(sucursal::setEmpresa);
        } else {
            sucursal.setEmpresa(null);
        }
        if (sucursal.getEmpresa() == null) {
            model.addAttribute("empresaError", "Debe seleccionar una empresa");
        }
        // Unicidad de establecimientoMh (global)
        if (!result.hasErrors() && sucursal.getEstablecimientoMh() != null && !sucursal.getEstablecimientoMh().isEmpty()) {
            if (sucursalRepository.existsByEstablecimientoMhIgnoreCase(sucursal.getEstablecimientoMh())) {
                result.rejectValue("establecimientoMh", "duplicate", "Ya existe una sucursal con ese Establecimiento MH");
            }
        }
        if (result.hasErrors() || sucursal.getEmpresa() == null) {
            model.addAttribute("title", "Crear Sucursal");
            cargarEmpresas(model);
            return "sucursales/crear_sucursal";
        }
        sucursal.setId(null);
        sucursalService.save(sucursal);
        return "redirect:/sucursales";
    }

    @GetMapping("/{id}/editar")
    public String editar(@PathVariable Long id, Model model) {
        Optional<Sucursal> opt = sucursalService.findById(id);
        if (opt.isEmpty()) {
            return "redirect:/sucursales";
        }
        model.addAttribute("title", "Editar Sucursal");
        model.addAttribute("sucursal", opt.get());
        cargarEmpresas(model);
        return "sucursales/editar_sucursal";
    }

    @PostMapping("/{id}/actualizar")
    public String actualizar(@PathVariable Long id,
                             @ModelAttribute("sucursal") Sucursal sucursal,
                             @RequestParam(value = "empresaId", required = false) Long empresaId,
                             BindingResult result,
                             Model model) {
        if (result.hasErrors()) {
            model.addAttribute("title", "Editar Sucursal");
            cargarEmpresas(model);
            return "sucursales/editar_sucursal";
        }
        if (sucursal.getNombreSucursal() != null) {
            sucursal.setNombreSucursal(sucursal.getNombreSucursal().trim());
        }
        if (sucursal.getEstablecimientoMh() != null) {
            sucursal.setEstablecimientoMh(sucursal.getEstablecimientoMh().trim().toUpperCase());
        }
        if (sucursal.getNombreSucursal() == null || sucursal.getNombreSucursal().isEmpty()) {
            result.rejectValue("nombreSucursal", "required", "El nombre es obligatorio");
        }
        if (sucursal.getEstablecimientoMh() == null || sucursal.getEstablecimientoMh().isEmpty()) {
            result.rejectValue("establecimientoMh", "required", "El establecimiento es obligatorio");
        } else {
            Pattern estPattern = Pattern.compile("^[MS]\\d{3}$");
            if (!estPattern.matcher(sucursal.getEstablecimientoMh()).matches()) {
                result.rejectValue("establecimientoMh", "pattern", "Formato inválido. Use M001 o S001");
            }
        }
        if (empresaId != null) {
            empresaRepository.findById(empresaId).ifPresent(sucursal::setEmpresa);
        } else {
            sucursal.setEmpresa(null);
        }
        if (sucursal.getEmpresa() == null) {
            model.addAttribute("empresaError", "Debe seleccionar una empresa");
        }
        // Unicidad de establecimientoMh excluyendo la propia sucursal
        if (!result.hasErrors() && sucursal.getEstablecimientoMh() != null && !sucursal.getEstablecimientoMh().isEmpty()) {
            if (sucursalRepository.existsByEstablecimientoMhIgnoreCaseAndIdNot(sucursal.getEstablecimientoMh(), id)) {
                result.rejectValue("establecimientoMh", "duplicate", "Ya existe una sucursal con ese Establecimiento MH");
            }
        }
        if (result.hasErrors() || sucursal.getEmpresa() == null) {
            model.addAttribute("title", "Editar Sucursal");
            cargarEmpresas(model);
            return "sucursales/editar_sucursal";
        }
        sucursal.setId(id);
        sucursalService.save(sucursal);
        return "redirect:/sucursales";
    }

    @PostMapping("/{id}/eliminar")
    public String eliminar(@PathVariable Long id) {
        sucursalService.deleteById(id);
        return "redirect:/sucursales";
    }

    private void cargarEmpresas(Model model) {
        List<Empresa> empresasActivas = empresaRepository.findAllByEstado(1);
        // Si estamos en edición y la empresa asociada está inactiva, incluirla para no romper el select
        Object suc = model.getAttribute("sucursal");
        if (suc instanceof Sucursal) {
            Empresa emp = ((Sucursal) suc).getEmpresa();
            if (emp != null && emp.getId() != null && (emp.getEstado() == null || emp.getEstado() != 1)) {
                boolean yaIncluida = empresasActivas.stream().anyMatch(e -> e.getId().equals(emp.getId()));
                if (!yaIncluida) {
                    empresasActivas.add(emp);
                }
            }
        }
        model.addAttribute("empresas", empresasActivas);
    }

    @GetMapping("/by-empresa/{empresaId}")
    @ResponseBody
    public List<Sucursal> listarPorEmpresa(@PathVariable Long empresaId) {
        return sucursalRepository.findAllByEmpresaIdAndEstado(empresaId, 1);
    }
}
