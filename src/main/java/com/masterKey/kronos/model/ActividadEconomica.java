package com.masterKey.kronos.model;

import jakarta.persistence.*;

@Entity
@Table(name = "ACTIVIDAD_ECONOMICA")
public class ActividadEconomica {

    @Id
    @Column(name = "ID", length = 25, nullable = false)
    private String id;

    @Column(name = "NOMBRE_ACTIVIDAD_ECONOMICA", nullable = false, columnDefinition = "TEXT")
    private String nombreActividadEconomica;

    public ActividadEconomica() {
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getNombreActividadEconomica() {
        return nombreActividadEconomica;
    }

    public void setNombreActividadEconomica(String nombreActividadEconomica) {
        this.nombreActividadEconomica = nombreActividadEconomica;
    }
}
