package com.masterKey.kronos.model;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import org.springframework.data.repository.cdi.Eager;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "VENTA")
public class Venta {

    @OneToMany(mappedBy = "venta", cascade = CascadeType.ALL,orphanRemoval = true, fetch = FetchType.EAGER)
    @JsonManagedReference
    private List<VentaDetalle> detalles;

    @OneToMany(mappedBy = "venta")
    @JsonManagedReference
    private List<VentaPago> pagos;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // SERIAL en PostgreSQL
    @Column(name = "ID")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "USUARIO_ID", referencedColumnName = "ID", nullable = false)
    private Usuario usuario;

    @ManyToOne
    @JoinColumn(name = "TIPO_DOCUMENTO_ID", referencedColumnName = "ID", nullable = false)
    private TipoDocumento tipoDocumento;

    @ManyToOne
    @JoinColumn(name = "CLIENTE_ID", referencedColumnName = "ID", nullable = false)
    private Cliente cliente;

    @Column(name = "FECHA")
    private LocalDateTime fecha = LocalDateTime.now();

    @Column(name = "CODIGO_GENERACION", length = 100)
    private String codigoGeneracion;

    @Column(name = "NUMERO_CONTROL", length = 100)
    private String numeroControl;

    @Column(name = "SELLO_MH", length = 100)
    private String selloMh;

    @Column(name = "SUBTOTAL", precision = 12, scale = 2, nullable = false)
    private BigDecimal subtotal = BigDecimal.ZERO;

    @Column(name = "DESCUENTO", precision = 12, scale = 2, nullable = false)
    private BigDecimal descuento = BigDecimal.ZERO;

    @Column(name = "IVA", precision = 12, scale = 2, nullable = false)
    private BigDecimal iva = BigDecimal.ZERO;

    @Column(name = "RETENCION", precision = 12, scale = 2, nullable = false)
    private BigDecimal retencion = BigDecimal.ZERO;

    @Column(name = "PERCEPCION", precision = 12, scale = 2, nullable = false)
    private BigDecimal percepcion = BigDecimal.ZERO;

    @Column(name = "TOTAL", precision = 12, scale = 2, nullable = false)
    private BigDecimal total = BigDecimal.ZERO;

    @Column(name = "PRECIO_INCLUYE_IVA", precision = 1)
    private Integer precioIncluyeIva = 1;

    @Column(name = "CODIGO_GENERACION_CONTINGENCIA", length = 100)
    private String codigoGeneracionContingencia = "";

    @Column(name = "CODIGO_GENERACION_ANULACION", length = 100)
    private String codigoGeneracionAnulacion = "";

    @Column(name = "INTENTOS", precision = 2)
    private Integer intentos = 0;

    @Column(name = "ESTADO", precision = 1)
    private Integer estado = 1;

    @Column(name = "NOMBRE_FACTURA")
    private String nombreFactura;

    @Column(name = "TIPO_DOC_FACTURA")
    private String tipoDocFactura;

    @Column(name = "DOC_FACTURA")
    private String docFactura;

    @Column(name = "CORREO")
    private String correo;

    @Column(name = "VENTA_ID_NC")
    private BigDecimal ventaIdNc;

    @Column(name = "CONTINGENCIA")
    private Integer contingencia;

    public List<VentaDetalle> getDetalles() {
        return detalles;
    }

    public void setDetalles(List<VentaDetalle> detalles) {
        this.detalles = detalles;
    }

    public List<VentaPago> getPagos() {
        return pagos;
    }

    public void setPagos(List<VentaPago> pagos) {
        this.pagos = pagos;
    }

    public Venta() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }

    public TipoDocumento getTipoDocumento() {
        return tipoDocumento;
    }

    public void setTipoDocumento(TipoDocumento tipoDocumento) {
        this.tipoDocumento = tipoDocumento;
    }

    public Cliente getCliente() {
        return cliente;
    }

    public void setCliente(Cliente cliente) {
        this.cliente = cliente;
    }

    public LocalDateTime getFecha() {
        return fecha;
    }

    public void setFecha(LocalDateTime fecha) {
        this.fecha = fecha;
    }

    public String getCodigoGeneracion() {
        return codigoGeneracion;
    }

    public void setCodigoGeneracion(String codigoGeneracion) {
        this.codigoGeneracion = codigoGeneracion;
    }

    public String getNumeroControl() {
        return numeroControl;
    }

    public void setNumeroControl(String numeroControl) {
        this.numeroControl = numeroControl;
    }

    public String getSelloMh() {
        return selloMh;
    }

    public void setSelloMh(String selloMh) {
        this.selloMh = selloMh;
    }

    public BigDecimal getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }

    public BigDecimal getDescuento() {
        return descuento;
    }

    public void setDescuento(BigDecimal descuento) {
        this.descuento = descuento;
    }

    public BigDecimal getIva() {
        return iva;
    }

    public void setIva(BigDecimal iva) {
        this.iva = iva;
    }

    public BigDecimal getRetencion() {
        return retencion;
    }

    public void setRetencion(BigDecimal retencion) {
        this.retencion = retencion;
    }

    public BigDecimal getPercepcion() {
        return percepcion;
    }

    public void setPercepcion(BigDecimal percepcion) {
        this.percepcion = percepcion;
    }

    public BigDecimal getTotal() {
        return total;
    }

    public void setTotal(BigDecimal total) {
        this.total = total;
    }

    public Integer getPrecioIncluyeIva() {
        return precioIncluyeIva;
    }

    public void setPrecioIncluyeIva(Integer precioIncluyeIva) {
        this.precioIncluyeIva = precioIncluyeIva;
    }

    public String getCodigoGeneracionContingencia() {
        return codigoGeneracionContingencia;
    }

    public void setCodigoGeneracionContingencia(String codigoGeneracionContingencia) {
        this.codigoGeneracionContingencia = codigoGeneracionContingencia;
    }

    public String getCodigoGeneracionAnulacion() {
        return codigoGeneracionAnulacion;
    }

    public void setCodigoGeneracionAnulacion(String codigoGeneracionAnulacion) {
        this.codigoGeneracionAnulacion = codigoGeneracionAnulacion;
    }

    public Integer getIntentos() {
        return intentos;
    }

    public void setIntentos(Integer intentos) {
        this.intentos = intentos;
    }

    public Integer getEstado() {
        return estado;
    }

    public void setEstado(Integer estado) {
        this.estado = estado;
    }

    public String getNombreFactura() {
        return nombreFactura;
    }

    public void setNombreFactura(String nombreFactura) {
        this.nombreFactura = nombreFactura;
    }

    public String getTipoDocFactura() {
        return tipoDocFactura;
    }

    public void setTipoDocFactura(String tipoDocFactura) {
        this.tipoDocFactura = tipoDocFactura;
    }

    public String getDocFactura() {
        return docFactura;
    }

    public void setDocFactura(String docFactura) {
        this.docFactura = docFactura;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public BigDecimal getVentaIdNc() {
        return ventaIdNc;
    }

    public void setVentaIdNc(BigDecimal ventaIdNc) {
        this.ventaIdNc = ventaIdNc;
    }

    public Integer getContingencia() {
        return contingencia;
    }

    public void setContingencia(Integer contingencia) {
        this.contingencia = contingencia;
    }
}
