package com.masterKey.kronos.model;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "INVALIDACION")
public class Invalidacion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // SERIAL en PostgreSQL
    @Column(name = "ID")
    private Long id;

    @Column(name = "CODIGO_GENERACION", length = 255)
    private String codigoGeneracion;

    @Column(name = "SELLO_INVALIDACION", length = 255)
    private String selloInvalidacion;

    @OneToOne
    @JoinColumn(name = "VENTA_ID", referencedColumnName = "ID", unique = true)
    private Venta venta;

    @ManyToOne
    @JoinColumn(name = "TIPO_ANULACION_ID", referencedColumnName = "ID")
    private TipoInvalidacion tipoAnulacion;

    @Column(name = "MOTIVO_ANULACION", columnDefinition = "TEXT")
    private String motivoAnulacion;

    @Column(name = "NOMBRE_RESPONSABLE", length = 250)
    private String nombreResponsable;

    @Column(name = "TIP_DOC_RESPONSABLE", length = 4)
    private String tipDocResponsable;

    @Column(name = "NUM_DOC_RESPONSABLE", length = 30)
    private String numDocResponsable;

    @Column(name = "NOMBRE_SOLICITA", length = 250)
    private String nombreSolicita;

    @Column(name = "TIP_DOC_SOLICITA", length = 4)
    private String tipDocSolicita;

    @Column(name = "NUM_DOC_SOLICITA", length = 30)
    private String numDocSolicita;

    @Column(name = "FEC_ANULA")
    private LocalDate fecAnula;

    public Invalidacion() {
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

    public String getSelloInvalidacion() {
        return selloInvalidacion;
    }

    public void setSelloInvalidacion(String selloInvalidacion) {
        this.selloInvalidacion = selloInvalidacion;
    }

    public Venta getVenta() {
        return venta;
    }

    public void setVenta(Venta venta) {
        this.venta = venta;
    }

    public TipoInvalidacion getTipoAnulacion() {
        return tipoAnulacion;
    }

    public void setTipoAnulacion(TipoInvalidacion tipoAnulacion) {
        this.tipoAnulacion = tipoAnulacion;
    }

    public String getMotivoAnulacion() {
        return motivoAnulacion;
    }

    public void setMotivoAnulacion(String motivoAnulacion) {
        this.motivoAnulacion = motivoAnulacion;
    }

    public String getNombreResponsable() {
        return nombreResponsable;
    }

    public void setNombreResponsable(String nombreResponsable) {
        this.nombreResponsable = nombreResponsable;
    }

    public String getTipDocResponsable() {
        return tipDocResponsable;
    }

    public void setTipDocResponsable(String tipDocResponsable) {
        this.tipDocResponsable = tipDocResponsable;
    }

    public String getNumDocResponsable() {
        return numDocResponsable;
    }

    public void setNumDocResponsable(String numDocResponsable) {
        this.numDocResponsable = numDocResponsable;
    }

    public String getNombreSolicita() {
        return nombreSolicita;
    }

    public void setNombreSolicita(String nombreSolicita) {
        this.nombreSolicita = nombreSolicita;
    }

    public String getTipDocSolicita() {
        return tipDocSolicita;
    }

    public void setTipDocSolicita(String tipDocSolicita) {
        this.tipDocSolicita = tipDocSolicita;
    }

    public String getNumDocSolicita() {
        return numDocSolicita;
    }

    public void setNumDocSolicita(String numDocSolicita) {
        this.numDocSolicita = numDocSolicita;
    }

    public LocalDate getFecAnula() {
        return fecAnula;
    }

    public void setFecAnula(LocalDate fecAnula) {
        this.fecAnula = fecAnula;
    }
}
