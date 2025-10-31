package com.masterKey.kronos.model;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import java.time.LocalDate;
import java.util.List;

@Entity
@Table(name = "CONTINGENCIA")
public class Contingencia {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // SERIAL en PostgreSQL
    @Column(name = "ID")
    private Long id;

    @Column(name = "CODIGO_GENERACION", length = 255)
    private String codigoGeneracion;

    @Column(name = "SELLO_CONTINGENCIA", length = 255)
    private String selloContingencia;

    @Column(name = "F_INICIO")
    private LocalDate fInicio;

    @Column(name = "F_FIN")
    private LocalDate fFin;

    @ManyToOne
    @JoinColumn(name = "TIPO_CONTINGENCIA_ID", referencedColumnName = "ID")
    private TipoContingencia tipoContingencia;

    @Column(name = "MOTIVO_CONTINGENCIA", columnDefinition = "TEXT")
    private String motivoContingencia;

    @OneToMany(mappedBy = "contingencia")
    @JsonManagedReference
    private List<ContingenciaDetalle> detalles;

    public Contingencia() {
    }

    public List<ContingenciaDetalle> getDetalles() {
        return detalles;
    }

    public void setDetalles(List<ContingenciaDetalle> detalles) {
        this.detalles = detalles;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getCodigoGeneracion() {
        return codigoGeneracion;
    }

    public void setCodigoGeneracion(String codigoGeneracion) {
        this.codigoGeneracion = codigoGeneracion;
    }

    public String getSelloContingencia() {
        return selloContingencia;
    }

    public void setSelloContingencia(String selloContingencia) {
        this.selloContingencia = selloContingencia;
    }

    public LocalDate getfInicio() {
        return fInicio;
    }

    public void setfInicio(LocalDate fInicio) {
        this.fInicio = fInicio;
    }

    public LocalDate getfFin() {
        return fFin;
    }

    public void setfFin(LocalDate fFin) {
        this.fFin = fFin;
    }

    public TipoContingencia getTipoContingencia() {
        return tipoContingencia;
    }

    public void setTipoContingencia(TipoContingencia tipoContingencia) {
        this.tipoContingencia = tipoContingencia;
    }

    public String getMotivoContingencia() {
        return motivoContingencia;
    }

    public void setMotivoContingencia(String motivoContingencia) {
        this.motivoContingencia = motivoContingencia;
    }
}
