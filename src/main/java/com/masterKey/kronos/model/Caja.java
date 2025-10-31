package com.masterKey.kronos.model;

import jakarta.persistence.*;

@Entity
@Table(name = "CAJA")
public class Caja {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // SERIAL en PostgreSQL
    @Column(name = "ID")
    private Long id;

    @Column(name = "DESCRIPCION", columnDefinition = "TEXT")
    private String descripcion;

    @Column(name = "PUNTO_VENTA_MH", length = 25)
    private String puntoVentaMh;

    @ManyToOne
    @JoinColumn(name = "SUCURSAL_ID", referencedColumnName = "ID")
    private Sucursal sucursal;

    public Caja() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getPuntoVentaMh() {
        return puntoVentaMh;
    }

    public void setPuntoVentaMh(String puntoVentaMh) {
        this.puntoVentaMh = puntoVentaMh;
    }

    public Sucursal getSucursal() {
        return sucursal;
    }

    public void setSucursal(Sucursal sucursal) {
        this.sucursal = sucursal;
    }
}
