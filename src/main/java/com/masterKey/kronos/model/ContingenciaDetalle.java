package com.masterKey.kronos.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;

@Entity
@Table(name = "CONTINGENCIA_DETALLE")
public class ContingenciaDetalle {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // SERIAL en PostgreSQL
    @Column(name = "ID")
    private Long id;

    @ManyToOne
    @JsonBackReference
    @JoinColumn(name = "CONTINGENCIA_ID", referencedColumnName = "ID")
    private Contingencia contingencia;

    @ManyToOne
    @JoinColumn(name = "VENTA_ID", referencedColumnName = "ID")
    private Venta venta;

    public ContingenciaDetalle() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Contingencia getContingencia() {
        return contingencia;
    }

    public void setContingencia(Contingencia contingencia) {
        this.contingencia = contingencia;
    }

    public Venta getVenta() {
        return venta;
    }

    public void setVenta(Venta venta) {
        this.venta = venta;
    }
}
