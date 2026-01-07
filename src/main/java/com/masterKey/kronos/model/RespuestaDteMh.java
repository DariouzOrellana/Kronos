package com.masterKey.kronos.model;


import jakarta.persistence.*;

import java.sql.Timestamp;
import java.time.LocalDateTime;

@Entity
@Table(name = "RESPUESTAS_DTE_MH")
public class RespuestaDteMh {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;


    @Column(name = "venta_id")
    private Long idVenta;

    @Column(name = "estado")
    private String estado;

    @Lob
    @Column(name = "respuesta")
    private String respuesta;

    @Lob
    @Column(name = "json_enviado")
    private String jsonEnviado;

    @Lob
    @Column(name = "firma")
    private String firma;

    @Column(name = "sello_mh")
    private String selloMh;

    @Column(name = "fecha")
    private LocalDateTime fecha;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getIdVenta() {
        return idVenta;
    }

    public void setIdVenta(Long idVenta) {
        this.idVenta = idVenta;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getRespuesta() {
        return respuesta;
    }

    public void setRespuesta(String respuesta) {
        this.respuesta = respuesta;
    }

    public String getJsonEnviado() {
        return jsonEnviado;
    }

    public void setJsonEnviado(String jsonEnviado) {
        this.jsonEnviado = jsonEnviado;
    }

    public String getFirma() {
        return firma;
    }

    public void setFirma(String firma) {
        this.firma = firma;
    }

    public String getSelloMh() {
        return selloMh;
    }

    public void setSelloMh(String selloMh) {
        this.selloMh = selloMh;
    }

    public LocalDateTime getFecha() {
        return fecha;
    }

    public void setFecha(LocalDateTime fecha) {
        this.fecha = fecha;
    }
}