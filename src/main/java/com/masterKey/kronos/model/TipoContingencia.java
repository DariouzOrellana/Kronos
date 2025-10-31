package com.masterKey.kronos.model;

import jakarta.persistence.*;

@Entity
@Table(name = "TIPO_CONTINGENCIA")
public class TipoContingencia {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // SERIAL en PostgreSQL
    @Column(name = "ID")
    private Long id;

    @Column(name = "NOMBRE", columnDefinition = "TEXT")
    private String nombre;

    public TipoContingencia() {
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
}
