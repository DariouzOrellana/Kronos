package com.masterKey.kronos.controller;

import com.masterKey.kronos.model.*;
import com.masterKey.kronos.service.ClienteService.ClienteService;
import com.masterKey.kronos.repository.DepartamentoRepository;
import com.masterKey.kronos.repository.MunicipioRepository;
import com.masterKey.kronos.repository.ActividadEconomicaRepository;
import com.masterKey.kronos.repository.TipoContribuyenteRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@Controller
@RequestMapping("/clientes")
public class ClienteController extends BaseController {

    private final ClienteService clienteService;
    private final DepartamentoRepository departamentoRepository;
    private final MunicipioRepository municipioRepository;
    private final ActividadEconomicaRepository actividadEconomicaRepository;
    private final TipoContribuyenteRepository tipoContribuyenteRepository;

    public ClienteController(ClienteService clienteService,
                             DepartamentoRepository departamentoRepository,
                             MunicipioRepository municipioRepository,
                             ActividadEconomicaRepository actividadEconomicaRepository,
                             TipoContribuyenteRepository tipoContribuyenteRepository) {
        this.clienteService = clienteService;
        this.departamentoRepository = departamentoRepository;
        this.municipioRepository = municipioRepository;
        this.actividadEconomicaRepository = actividadEconomicaRepository;
        this.tipoContribuyenteRepository = tipoContribuyenteRepository;
    }

    private void cargarCatalogos(Model model){
        model.addAttribute("departamentos", departamentoRepository.findAll());
        model.addAttribute("municipios", municipioRepository.findAll());
        model.addAttribute("actividades", actividadEconomicaRepository.findAll());
        model.addAttribute("tiposContribuyente", tipoContribuyenteRepository.findAll());
    }

    @GetMapping
    public String listar(Model model, HttpSession session) {
        model.addAttribute("title", "Clientes");
        model.addAttribute("clientes", clienteService.findAll());
        return "clientes/ver_clientes";
    }

    @GetMapping("/crear")
    public String crear(Model model, HttpSession session) {
        model.addAttribute("title", "Crear Cliente");
        model.addAttribute("cliente", new Cliente());
        cargarCatalogos(model);
        return "clientes/crear_cliente";
    }

    @PostMapping("/guardar")
    public String guardar(@ModelAttribute("cliente") Cliente cliente,
                          @RequestParam(value = "departamentoId", required = false) String departamentoId,
                          @RequestParam(value = "municipioId", required = false) String municipioId,
                          @RequestParam(value = "actividadId", required = false) String actividadId,
                          @RequestParam(value = "tipoContribuyenteId", required = false) Long tipoContribuyenteId,
                          BindingResult result, Model model) {
        if (result.hasErrors()) {
            model.addAttribute("title", "Crear Cliente");
            cargarCatalogos(model);
            return "clientes/crear_cliente";
        }
        if (departamentoId != null && !departamentoId.isBlank()) departamentoRepository.findById(departamentoId).ifPresent(cliente::setDepartamento);
        if (municipioId != null && !municipioId.isBlank()) municipioRepository.findById(municipioId).ifPresent(cliente::setMunicipio);
        if (actividadId != null && !actividadId.isBlank()) actividadEconomicaRepository.findById(actividadId).ifPresent(cliente::setActividadEconomica);
        if (tipoContribuyenteId != null) tipoContribuyenteRepository.findById(tipoContribuyenteId).ifPresent(cliente::setTipoContribuyente);
        clienteService.save(cliente);
        return "redirect:/clientes";
    }

    @GetMapping("/{id}")
    public String ver(@PathVariable Long id, Model model) {
        Optional<Cliente> opt = clienteService.findById(id);
        if (opt.isEmpty()) {
            return "redirect:/clientes";
        }
        model.addAttribute("title", "Detalle Cliente");
        model.addAttribute("cliente", opt.get());
        return "clientes/ver_cliente";
    }

    @GetMapping("/{id}/editar")
    public String editar(@PathVariable Long id, Model model) {
        Optional<Cliente> opt = clienteService.findById(id);
        if (opt.isEmpty()) {
            return "redirect:/clientes";
        }
        model.addAttribute("title", "Editar Cliente");
        model.addAttribute("cliente", opt.get());
        cargarCatalogos(model);
        return "clientes/editar_cliente";
    }

    @PostMapping("/{id}/actualizar")
    public String actualizar(@PathVariable Long id,
                             @ModelAttribute("cliente") Cliente cliente,
                             @RequestParam(value = "departamentoId", required = false) String departamentoId,
                             @RequestParam(value = "municipioId", required = false) String municipioId,
                             @RequestParam(value = "actividadId", required = false) String actividadId,
                             @RequestParam(value = "tipoContribuyenteId", required = false) Long tipoContribuyenteId,
                             BindingResult result, Model model) {
        if (result.hasErrors()) {
            model.addAttribute("title", "Editar Cliente");
            cargarCatalogos(model);
            return "clientes/editar_cliente";
        }
        cliente.setId(id);
        if (departamentoId != null && !departamentoId.isBlank()) departamentoRepository.findById(departamentoId).ifPresent(cliente::setDepartamento);
        if (municipioId != null && !municipioId.isBlank()) municipioRepository.findById(municipioId).ifPresent(cliente::setMunicipio);
        if (actividadId != null && !actividadId.isBlank()) actividadEconomicaRepository.findById(actividadId).ifPresent(cliente::setActividadEconomica);
        if (tipoContribuyenteId != null) tipoContribuyenteRepository.findById(tipoContribuyenteId).ifPresent(cliente::setTipoContribuyente);
        clienteService.save(cliente);
        return "redirect:/clientes";
    }

    @PostMapping("/{id}/eliminar")
    public String eliminar(@PathVariable Long id) {
        clienteService.deleteById(id);
        return "redirect:/clientes";
    }
}
