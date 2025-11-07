package com.masterKey.kronos.controller;

import com.masterKey.kronos.model.Empresa;
import com.masterKey.kronos.repository.ActividadEconomicaRepository;
import com.masterKey.kronos.repository.DepartamentoRepository;
import com.masterKey.kronos.repository.MunicipioRepository;
import com.masterKey.kronos.repository.TipoContribuyenteRepository;
import com.masterKey.kronos.service.EmpresaService.EmpresaService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/empresas")
public class EmpresaController extends BaseController {

    private final EmpresaService empresaService;
    private final ActividadEconomicaRepository actividadEconomicaRepository;
    private final DepartamentoRepository departamentoRepository;
    private final MunicipioRepository municipioRepository;
    private final TipoContribuyenteRepository tipoContribuyenteRepository;

    public EmpresaController(EmpresaService empresaService,
                             ActividadEconomicaRepository actividadEconomicaRepository,
                             DepartamentoRepository departamentoRepository,
                             MunicipioRepository municipioRepository,
                             TipoContribuyenteRepository tipoContribuyenteRepository) {
        this.empresaService = empresaService;
        this.actividadEconomicaRepository = actividadEconomicaRepository;
        this.departamentoRepository = departamentoRepository;
        this.municipioRepository = municipioRepository;
        this.tipoContribuyenteRepository = tipoContribuyenteRepository;
    }

    @GetMapping
    public String listar(Model model, HttpSession session) {
        model.addAttribute("title", "Empresas");
        model.addAttribute("empresas", empresaService.findAll());
        return "empresas/ver_empresas";
    }

    @GetMapping("/crear")
    public String crear(Model model, HttpSession session) {
        model.addAttribute("title", "Crear Empresa");
        model.addAttribute("empresa", new Empresa());
        cargarCatalogos(model);
        return "empresas/crear_empresa";
    }

    @PostMapping("/guardar")
    public String guardar(@ModelAttribute("empresa") Empresa empresa,
                          @RequestParam(value = "actividadId", required = false) String actividadId,
                          @RequestParam(value = "departamentoId", required = false) String departamentoId,
                          @RequestParam(value = "municipioId", required = false) String municipioId,
                          @RequestParam(value = "tipoContribuyenteId", required = false) Long tipoContribuyenteId,
                          BindingResult result,
                          Model model) {
        if (result.hasErrors()) {
            model.addAttribute("title", "Crear Empresa");
            cargarCatalogos(model);
            return "empresas/crear_empresa";
        }
        if (empresa.getNombreEmpresa() != null) {
            empresa.setNombreEmpresa(empresa.getNombreEmpresa().trim().toUpperCase());
        }
        if (actividadId != null && !actividadId.isBlank()) {
            actividadEconomicaRepository.findById(actividadId).ifPresent(empresa::setActividadEconomica);
        } else { empresa.setActividadEconomica(null); }
        if (departamentoId != null && !departamentoId.isBlank()) {
            departamentoRepository.findById(departamentoId).ifPresent(empresa::setDepartamento);
        } else { empresa.setDepartamento(null); }
        if (municipioId != null && !municipioId.isBlank()) {
            municipioRepository.findById(municipioId).ifPresent(empresa::setMunicipio);
        } else { empresa.setMunicipio(null); }
        if (tipoContribuyenteId != null) {
            tipoContribuyenteRepository.findById(tipoContribuyenteId).ifPresent(empresa::setTipoContribuyente);
        } else { empresa.setTipoContribuyente(null); }
        empresa.setId(null);
        empresaService.save(empresa);
        return "redirect:/empresas";
    }

    @GetMapping("/{id}/editar")
    public String editar(@PathVariable Long id, Model model) {
        Empresa empresa = empresaService.findById(id).orElse(null);
        if (empresa == null) return "redirect:/empresas";
        model.addAttribute("title", "Editar Empresa");
        model.addAttribute("empresa", empresa);
        cargarCatalogos(model);
        return "empresas/editar_empresa";
    }

    @PostMapping("/{id}/actualizar")
    public String actualizar(@PathVariable Long id,
                             @ModelAttribute("empresa") Empresa empresa,
                             @RequestParam(value = "actividadId", required = false) String actividadId,
                             @RequestParam(value = "departamentoId", required = false) String departamentoId,
                             @RequestParam(value = "municipioId", required = false) String municipioId,
                             @RequestParam(value = "tipoContribuyenteId", required = false) Long tipoContribuyenteId,
                             BindingResult result,
                             Model model) {
        if (result.hasErrors()) {
            model.addAttribute("title", "Editar Empresa");
            cargarCatalogos(model);
            return "empresas/editar_empresa";
        }
        if (empresa.getNombreEmpresa() != null) {
            empresa.setNombreEmpresa(empresa.getNombreEmpresa().trim().toUpperCase());
        }
        if (actividadId != null && !actividadId.isBlank()) {
            actividadEconomicaRepository.findById(actividadId).ifPresent(empresa::setActividadEconomica);
        } else { empresa.setActividadEconomica(null); }
        if (departamentoId != null && !departamentoId.isBlank()) {
            departamentoRepository.findById(departamentoId).ifPresent(empresa::setDepartamento);
        } else { empresa.setDepartamento(null); }
        if (municipioId != null && !municipioId.isBlank()) {
            municipioRepository.findById(municipioId).ifPresent(empresa::setMunicipio);
        } else { empresa.setMunicipio(null); }
        if (tipoContribuyenteId != null) {
            tipoContribuyenteRepository.findById(tipoContribuyenteId).ifPresent(empresa::setTipoContribuyente);
        } else { empresa.setTipoContribuyente(null); }
        empresa.setId(id);
        empresaService.save(empresa);
        return "redirect:/empresas";
    }

    @PostMapping("/{id}/eliminar")
    public String eliminar(@PathVariable Long id) {
        empresaService.deleteById(id);
        return "redirect:/empresas";
    }

    private void cargarCatalogos(Model model) {
        model.addAttribute("actividades", actividadEconomicaRepository.findAll());
        model.addAttribute("departamentos", departamentoRepository.findAll());
        model.addAttribute("municipios", municipioRepository.findAll());
        model.addAttribute("tiposContribuyente", tipoContribuyenteRepository.findAll());
        model.addAttribute("estados", List.of(1,0));
    }
}
