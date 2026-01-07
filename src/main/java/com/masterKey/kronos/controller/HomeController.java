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
    private final com.masterKey.kronos.service.VentaService.VentaService ventaService;

    @Autowired
    public HomeController(UsuarioService usuarioService,
                          ParametroService parametroService,
                          HelperService helperService,
                          com.masterKey.kronos.service.VentaService.VentaService ventaService) {
        this.usuarioService = usuarioService;
        this.parametroService = parametroService;
        this.helperService = helperService;
        this.ventaService = ventaService;
    }

    @GetMapping("/")
    public String root(Model model) {
        //model.addAttribute("title", "Home");

        return "redirect:/home";
    }

    @GetMapping("/home")
    public String home(@org.springframework.web.bind.annotation.RequestParam(value = "fecha", required = false) String fecha,
                       Model model) {
        model.addAttribute("title", "Home");

        // Determinar fecha seleccionada
        java.time.LocalDate selected = null;
        if(fecha != null && !fecha.isBlank()){
            try { selected = java.time.LocalDate.parse(fecha); } catch(Exception e){ selected = java.time.LocalDate.now(); }
        } else {
            selected = java.time.LocalDate.now();
        }
        model.addAttribute("fechaSeleccionada", selected.toString());

        // Sólo agregar datos de ventas si el usuario es ADMIN
        com.masterKey.kronos.model.Usuario userAuth = (com.masterKey.kronos.model.Usuario) model.asMap().get("userAuth");
        if(userAuth != null && userAuth.getRol() != null && "ADMIN".equals(userAuth.getRol().getNombreRol())){
            java.time.LocalDateTime desde = selected.atStartOfDay();
            java.time.LocalDateTime hasta = java.time.LocalTime.MAX.atDate(selected);

            // Total vendido (monto)
            java.math.BigDecimal totalVendidoHoy = ventaService.sumTotalByFechaBetween(desde, hasta);
            model.addAttribute("totalVendidoHoy", totalVendidoHoy != null ? totalVendidoHoy : java.math.BigDecimal.ZERO);

            // Ventas por cliente (lista de objetos)
            java.util.List<Object[]> ventasClienteRaw = ventaService.ventasPorClienteBetween(desde, hasta);
            java.util.List<com.masterKey.kronos.model.VentaResumenCliente> ventasClienteHoy = new java.util.ArrayList<>();
            if(ventasClienteRaw != null){
                for(Object[] r : ventasClienteRaw){
                    String nombre = r[0] != null ? r[0].toString() : "-";
                    Long cantidad = r[1] != null ? ((Number)r[1]).longValue() : 0L;
                    java.math.BigDecimal total = r[2] != null ? new java.math.BigDecimal(r[2].toString()) : java.math.BigDecimal.ZERO;
                    ventasClienteHoy.add(new com.masterKey.kronos.model.VentaResumenCliente(nombre, cantidad, total));
                }
            }
            model.addAttribute("ventasClienteHoy", ventasClienteHoy);

            // Conteos
            Long ventaTotal = ventaService.countByFechaBetween(desde, hasta);
            Long ventaSinSello = ventaService.countByFechaBetweenAndSelloMhIsNull(desde, hasta);
            Long ventaConSello = (ventaTotal != null ? ventaTotal : 0L) - (ventaSinSello != null ? ventaSinSello : 0L);
            Long ventaConting = ventaService.countByFechaBetweenAndContingencia(desde, hasta);
            model.addAttribute("ventaTotal", ventaTotal != null ? ventaTotal : 0L);
            model.addAttribute("ventaConSello", ventaConSello != null ? ventaConSello : 0L);
            model.addAttribute("ventaSinSello", ventaSinSello != null ? ventaSinSello : 0L);
            model.addAttribute("ventaContingencia", ventaConting != null ? ventaConting : 0L);

            // Tipos DTE: labels (nombres), counts and totals
            java.util.List<Object[]> tiposCount = ventaService.countGroupByTipoBetween(desde, hasta);
            java.util.List<Object[]> tiposTotals = ventaService.sumTotalGroupByTipoBetween(desde, hasta);
            java.util.List<String> tiposLabels = new java.util.ArrayList<>();
            java.util.List<Long> tiposValues = new java.util.ArrayList<>();
            java.util.List<java.math.BigDecimal> tiposTotalsVals = new java.util.ArrayList<>();

            if(tiposCount != null){
                for(Object[] r: tiposCount){
                    tiposLabels.add(r[0] != null ? r[0].toString() : "-");
                    tiposValues.add(r[1] != null ? ((Number)r[1]).longValue() : 0L);
                }
            }
            if(tiposTotals != null){
                // match totals by label
                java.util.Map<String, java.math.BigDecimal> mapTotals = new java.util.HashMap<>();
                for(Object[] r: tiposTotals){
                    String k = r[0] != null ? r[0].toString() : "-";
                    java.math.BigDecimal v = r[1] != null ? new java.math.BigDecimal(r[1].toString()) : java.math.BigDecimal.ZERO;
                    mapTotals.put(k, v);
                }
                for(String lbl: tiposLabels){
                    tiposTotalsVals.add(mapTotals.getOrDefault(lbl, java.math.BigDecimal.ZERO));
                }
            }

            model.addAttribute("tiposDteLabels", tiposLabels);
            model.addAttribute("tiposDteValues", tiposValues);
            model.addAttribute("tiposDteTotals", tiposTotalsVals);
            // Ventas por usuario: obtenemos tanto la cantidad de ventas por usuario como el total monetario
            java.util.List<Object[]> ventasPorUsuarioCount = ventaService.countGroupByUsuarioBetween(desde, hasta);
            java.util.List<Object[]> ventasPorUsuarioSum = ventaService.sumTotalGroupByUsuarioBetween(desde, hasta);
            java.util.Map<String, java.math.BigDecimal> sumaPorUsuarioMap = new java.util.HashMap<>();
            if (ventasPorUsuarioSum != null) {
                for (Object[] r : ventasPorUsuarioSum) {
                    String usr = r[0] != null ? r[0].toString() : "-";
                    java.math.BigDecimal v = r[1] != null ? new java.math.BigDecimal(r[1].toString()) : java.math.BigDecimal.ZERO;
                    sumaPorUsuarioMap.put(usr, v);
                }
            }

            java.util.List<String> usuariosLabels = new java.util.ArrayList<>();
            java.util.List<Long> usuariosCounts = new java.util.ArrayList<>();
            java.text.NumberFormat nf = java.text.NumberFormat.getCurrencyInstance(java.util.Locale.US);
            if (ventasPorUsuarioCount != null) {
                for (Object[] r : ventasPorUsuarioCount) {
                    String usr = r[0] != null ? r[0].toString() : "-";
                    long cnt = r[1] != null ? ((Number) r[1]).longValue() : 0L;
                    java.math.BigDecimal totalUsr = sumaPorUsuarioMap.getOrDefault(usr, java.math.BigDecimal.ZERO);
                    String label = String.format("%s — %d ventas — %s", usr, cnt, nf.format(totalUsr));
                    usuariosLabels.add(label);
                    usuariosCounts.add(cnt);
                }
            }
            model.addAttribute("ventaPorUsuarioLabels", usuariosLabels);
            model.addAttribute("ventaPorUsuarioTotals", usuariosCounts);
        }

        // Si no es ADMIN, obtener las ventas del usuario para la fecha seleccionada
        if(userAuth != null && (userAuth.getRol() == null || !"ADMIN".equals(userAuth.getRol().getNombreRol()))){
            java.time.LocalDateTime desdeUser = selected.atStartOfDay();
            java.time.LocalDateTime hastaUser = java.time.LocalTime.MAX.atDate(selected);
            java.util.List<com.masterKey.kronos.model.Venta> ventasUsuarioHoy = ventaService.findByUsuario_IdAndFechaBetween(userAuth.getId(), desdeUser, hastaUser);
            model.addAttribute("ventasUsuarioHoy", ventasUsuarioHoy);
        }

        return "home";
    }

}
