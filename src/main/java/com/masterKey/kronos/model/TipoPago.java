package com.masterKey.kronos.model;

import jakarta.persistence.*;

@Entity
@Table(name = "TIPO_PAGO")
public class TipoPago {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // SERIAL en PostgreSQL
    @Column(name = "ID")
    private Long id;

    @Column(name = "NOMBRE", length = 255)
    private String nombre;

    @Column(name = "ESTADO", precision = 1)
    private Integer estado = 1;

    public TipoPago() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public Integer getEstado() {
        return estado;
    }

    public void setEstado(Integer estado) {
        this.estado = estado;
    }
}
