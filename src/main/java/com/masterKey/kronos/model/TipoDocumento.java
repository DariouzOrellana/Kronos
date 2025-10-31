package com.masterKey.kronos.model;

import jakarta.persistence.*;

@Entity
@Table(name = "TIPO_DOCUMENTO")
public class TipoDocumento {

    @Id
    @Column(name = "ID", length = 25, nullable = false)
    private String id;

    @Column(name = "NOMBRE", length = 25)
    private String nombre;

    @Column(name = "NOMBRE_CORTO", length = 10)
    private String nombreCorto;

    @Column(name = "VERSION_DTE", length = 10)
    private String versionDte;

    public TipoDocumento() {
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getNombreCorto() {
        return nombreCorto;
    }

    public void setNombreCorto(String nombreCorto) {
        this.nombreCorto = nombreCorto;
    }

    public String getVersionDte() {
        return versionDte;
    }

    public void setVersionDte(String versionDte) {
        this.versionDte = versionDte;
    }
}
