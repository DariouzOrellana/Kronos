package com.masterKey.kronos.model;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "PRODUCTO")
public class Producto {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // SERIAL en PostgreSQL
    @Column(name = "ID")
    private Long id;

    @Column(name = "DESCRIPCION", columnDefinition = "TEXT", nullable = false)
    private String descripcion;

    @Column(name = "PRECIO", precision = 12, scale = 2)
    private BigDecimal precio = BigDecimal.ZERO;

    @Column(name = "TIPO", length = 20)
    private String tipo; // 'PRODUCTO' o 'SERVICIO'

    @Column(name = "VECES_USADO", precision = 12)
    private Integer vecesUsado = 0;

    public Producto() {
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

    public BigDecimal getPrecio() {
        return precio;
    }

    public void setPrecio(BigDecimal precio) {
        this.precio = precio;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public Integer getVecesUsado() {
        return vecesUsado;
    }

    public void setVecesUsado(Integer vecesUsado) {
        this.vecesUsado = vecesUsado;
    }
}
