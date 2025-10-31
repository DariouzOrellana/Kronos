package com.masterKey.kronos.model;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;

@Entity
@Table(name = "EMPRESA")
public class Empresa {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // SERIAL en PostgreSQL
    @Column(name = "ID")
    private Long id;

    @Column(name = "NOMBRE_EMPRESA", length = 255)
    private String nombreEmpresa;

    @Column(name = "REPRESENTANTE_LEGAL", length = 255)
    private String representanteLegal;

    @Column(name = "TELEFONO", length = 25)
    private String telefono;

    @Column(name = "CORREO", length = 255)
    private String correo;

    @Column(name = "NOMBRE_COMERCIAL", length = 255)
    private String nombreComercial;

    @Column(name = "NO_REGISTRO", length = 25)
    private String noRegistro;

    @Column(name = "NIT", length = 25)
    private String nit;

    @Column(name = "DUI", length = 25)
    private String dui;

    @ManyToOne
    @JoinColumn(name = "CODIGO_ACTIVIDAD_ID", referencedColumnName = "ID")
    private ActividadEconomica actividadEconomica;

    @Column(name = "DIRECCION", columnDefinition = "TEXT")
    private String direccion;

    @ManyToOne
    @JoinColumn(name = "DEPARTAMENTO_ID", referencedColumnName = "ID")
    @JsonManagedReference
    private Departamento departamento;

    @ManyToOne
    @JoinColumn(name = "MUNICIPIO_ID", referencedColumnName = "ID")
    @JsonManagedReference
    private Municipio municipio;

    @ManyToOne
    @JoinColumn(name = "TIPO_CONTRIBUYENTE_ID", referencedColumnName = "ID")
    private TipoContribuyente tipoContribuyente;

    @Column(name = "ESTADO")
    private Integer estado;

    public Empresa() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNombreEmpresa() {
        return nombreEmpresa;
    }

    public void setNombreEmpresa(String nombreEmpresa) {
        this.nombreEmpresa = nombreEmpresa;
    }

    public String getRepresentanteLegal() {
        return representanteLegal;
    }

    public void setRepresentanteLegal(String representanteLegal) {
        this.representanteLegal = representanteLegal;
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

    public String getNombreComercial() {
        return nombreComercial;
    }

    public void setNombreComercial(String nombreComercial) {
        this.nombreComercial = nombreComercial;
    }

    public String getNoRegistro() {
        return noRegistro;
    }

    public void setNoRegistro(String noRegistro) {
        this.noRegistro = noRegistro;
    }

    public String getNit() {
        return nit;
    }

    public void setNit(String nit) {
        this.nit = nit;
    }

    public String getDui() {
        return dui;
    }

    public void setDui(String dui) {
        this.dui = dui;
    }

    public ActividadEconomica getActividadEconomica() {
        return actividadEconomica;
    }

    public void setActividadEconomica(ActividadEconomica actividadEconomica) {
        this.actividadEconomica = actividadEconomica;
    }

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    public Departamento getDepartamento() {
        return departamento;
    }

    public void setDepartamento(Departamento departamento) {
        this.departamento = departamento;
    }

    public Municipio getMunicipio() {
        return municipio;
    }

    public void setMunicipio(Municipio municipio) {
        this.municipio = municipio;
    }

    public TipoContribuyente getTipoContribuyente() {
        return tipoContribuyente;
    }

    public void setTipoContribuyente(TipoContribuyente tipoContribuyente) {
        this.tipoContribuyente = tipoContribuyente;
    }

    public Integer getEstado() {
        return estado;
    }

    public void setEstado(Integer estado) {
        this.estado = estado;
    }
}
