package com.masterKey.kronos.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "VENTA_PAGO")
public class VentaPago {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // SERIAL en PostgreSQL
    @Column(name = "ID")
    private Long id;

    @ManyToOne
    @JsonBackReference
    @JoinColumn(name = "VENTA_ID", referencedColumnName = "ID")
    private Venta venta;

    @ManyToOne
    @JoinColumn(name = "TIPO_PAGO_ID", referencedColumnName = "ID")
    private TipoPago tipoPago;

    @Column(name = "ESTADO", precision = 1)
    private Integer estado = 1;

    @Column(name = "VALOR", precision = 12, scale = 2, nullable = false)
    private BigDecimal valor;

    public VentaPago() {
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

    public TipoPago getTipoPago() {
        return tipoPago;
    }

    public void setTipoPago(TipoPago tipoPago) {
        this.tipoPago = tipoPago;
    }

    public Integer getEstado() {
        return estado;
    }

    public void setEstado(Integer estado) {
        this.estado = estado;
    }

    public BigDecimal getValor() {
        return valor;
    }

    public void setValor(BigDecimal valor) {
        this.valor = valor;
    }
}
