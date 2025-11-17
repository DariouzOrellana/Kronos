package com.masterKey.kronos.model.ContadorDte;

import jakarta.persistence.*;

@Entity
@Table(name = "CONTADOR_DTE")
@IdClass(ContadorDteId.class) // Clave compuesta
public class ContadorDte {

    @Id
    @Column(name = "TIPO_DOCUMENTO_ID", length = 25)
    private String tipoDocumentoId;

    @Id
    @Column(name = "ANIO")
    private Integer anio;

    @Id
    @Column(name = "SUCURSAL_ID")
    private Integer sucursalId;

    @Column(name = "CONTADOR")
    private Integer contador;

    public String getTipoDocumentoId() {
        return tipoDocumentoId;
    }

    public void setTipoDocumentoId(String tipoDocumentoId) {
        this.tipoDocumentoId = tipoDocumentoId;
    }

    public Integer getAnio() {
        return anio;
    }

    public void setAnio(Integer anio) {
        this.anio = anio;
    }

    public Integer getSucursalId() {
        return sucursalId;
    }

    public void setSucursalId(Integer sucursalId) {
        this.sucursalId = sucursalId;
    }

    public Integer getContador() {
        return contador;
    }

    public void setContador(Integer contador) {
        this.contador = contador;
    }
}

