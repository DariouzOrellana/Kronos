package com.masterKey.kronos.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;

import java.util.List;

@Entity
@Table(name = "DEPARTAMENTO")
public class Departamento {

    @Id
    @Column(name = "ID", length = 4, nullable = false)
    private String id;

    @Column(name = "NOMBRE_DEPARTAMENTO", length = 100, nullable = false)
    private String nombreDepartamento;

    @OneToMany(mappedBy = "departamento")
    @JsonManagedReference
    private List<Municipio> municipio;

    @JsonBackReference
    @OneToMany(mappedBy = "departamento")
    private List<Empresa> empresa;



    public List<Municipio> getMunicipio() {
        return municipio;
    }

    public void setMunicipio(List<Municipio> municipio) {
        this.municipio = municipio;
    }

    public List<Empresa> getEmpresa() {
        return empresa;
    }

    public void setEmpresa(List<Empresa> empresa) {
        this.empresa = empresa;
    }

    public Departamento() {
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getNombreDepartamento() {
        return nombreDepartamento;
    }

    public void setNombreDepartamento(String nombreDepartamento) {
        this.nombreDepartamento = nombreDepartamento;
    }
}
