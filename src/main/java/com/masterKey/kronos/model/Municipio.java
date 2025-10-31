package com.masterKey.kronos.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;

import java.util.List;

@Entity
@Table(name = "MUNICIPIO")
public class Municipio {

    @Id
    @Column(name = "ID", length = 4, nullable = false)
    private String id;

    @Column(name = "NOMBRE_MUNICIPIO", length = 100, nullable = false)
    private String nombreMunicipio;

    @Column(name = "MUNICIPIO_ID", length = 4)
    private String municipioId;

    @ManyToOne
    @JoinColumn(name = "DEPARTAMENTO_ID", referencedColumnName = "ID")
    @JsonBackReference
    private Departamento departamento;

    @JsonBackReference
    @OneToMany(mappedBy = "municipio")
    private List<Empresa> empresa;

    public Municipio() {

    }

    public List<Empresa> getEmpresa() {
        return empresa;
    }

    public void setEmpresa(List<Empresa> empresa) {
        this.empresa = empresa;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getNombreMunicipio() {
        return nombreMunicipio;
    }

    public void setNombreMunicipio(String nombreMunicipio) {
        this.nombreMunicipio = nombreMunicipio;
    }

    public String getMunicipioId() {
        return municipioId;
    }

    public void setMunicipioId(String municipioId) {
        this.municipioId = municipioId;
    }

    public Departamento getDepartamento() {
        return departamento;
    }

    public void setDepartamento(Departamento departamento) {
        this.departamento = departamento;
    }
}
