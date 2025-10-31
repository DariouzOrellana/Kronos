package com.masterKey.kronos.model;

import jakarta.persistence.*;

@Entity
@Table(name = "SUCURSAL")
public class Sucursal {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // SERIAL en PostgreSQL
    @Column(name = "ID")
    private Long id;

    @Column(name = "NOMBRE_SUCURSAL", length = 25)
    private String nombreSucursal;

    @Column(name = "DIRECCION", columnDefinition = "TEXT")
    private String direccion;

    @Column(name = "TELEFONO", length = 25)
    private String telefono;

    @Column(name = "CORREO", length = 255)
    private String correo;

    @Column(name = "ESTABLECIMIENTO_MH", length = 25)
    private String establecimientoMh;

    @Column(name = "ESTADO")
    private Integer estado;

    @ManyToOne
    @JoinColumn(name = "EMPRESA_ID", referencedColumnName = "ID")
    private Empresa empresa;

    public Sucursal() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNombreSucursal() {
        return nombreSucursal;
    }

    public void setNombreSucursal(String nombreSucursal) {
        this.nombreSucursal = nombreSucursal;
    }

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public String getEstablecimientoMh() {
        return establecimientoMh;
    }

    public void setEstablecimientoMh(String establecimientoMh) {
        this.establecimientoMh = establecimientoMh;
    }

    public Integer getEstado() {
        return estado;
    }

    public void setEstado(Integer estado) {
        this.estado = estado;
    }

    public Empresa getEmpresa() {
        return empresa;
    }

    public void setEmpresa(Empresa empresa) {
        this.empresa = empresa;
    }
}
