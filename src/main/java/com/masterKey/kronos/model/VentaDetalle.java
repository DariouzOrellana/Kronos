package com.masterKey.kronos.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "VENTA_DETALLE")
public class VentaDetalle {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // SERIAL en PostgreSQL
    @Column(name = "ID")
    private Long id;

    @ManyToOne
    @JsonBackReference
    @JoinColumn(name = "VENTA_ID", referencedColumnName = "ID", nullable = false)
    private Venta venta;

    @ManyToOne
    @JoinColumn(name = "PRODUCTO_ID", referencedColumnName = "ID", nullable = false)
    private Producto producto;

    @Column(name = "CANTIDAD", precision = 12, scale = 2, nullable = false)
    private BigDecimal cantidad = BigDecimal.ONE;

    @Column(name = "PRECIO_UNITARIO", precision = 12, scale = 2, nullable = false)
    private BigDecimal precioUnitario;

    @Column(name = "DESCUENTO", precision = 12, scale = 2, nullable = false)
    private BigDecimal descuento = BigDecimal.ZERO;

    @Column(name = "IVA", precision = 12, scale = 2, nullable = false)
    private BigDecimal iva = BigDecimal.ZERO;

    @Column(name = "SUB_TOTAL", precision = 12, scale = 2, nullable = false)
    private BigDecimal subTotal = BigDecimal.ZERO;

    @Column(name = "TOTAL_LINEA", precision = 12, scale = 2, nullable = false)
    private BigDecimal totalLinea = BigDecimal.ZERO;

    public VentaDetalle() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Venta getVenta() {
        return venta;
    }

    public void setVenta(Venta venta) {
        this.venta = venta;
    }

    public Producto getProducto() {
        return producto;
    }

    public void setProducto(Producto producto) {
        this.producto = producto;
    }

    public BigDecimal getCantidad() {
        return cantidad;
    }

    public void setCantidad(BigDecimal cantidad) {
        this.cantidad = cantidad;
    }

    public BigDecimal getPrecioUnitario() {
        return precioUnitario;
    }

    public void setPrecioUnitario(BigDecimal precioUnitario) {
        this.precioUnitario = precioUnitario;
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

    public BigDecimal getSubTotal() {
        return subTotal;
    }

    public void setSubTotal(BigDecimal subTotal) {
        this.subTotal = subTotal;
    }

    public BigDecimal getTotalLinea() {
        return totalLinea;
    }

    public void setTotalLinea(BigDecimal totalLinea) {
        this.totalLinea = totalLinea;
    }
}
