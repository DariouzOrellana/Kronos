package com.masterKey.kronos.model.ContadorDte;

import java.io.Serializable;
import java.util.Objects;

public class ContadorDteId implements Serializable {

    private String tipoDocumentoId;
    private Integer anio;
    private Integer sucursalId;

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

    public ContadorDteId() {}

    public ContadorDteId(String tipoDocumentoId, Integer anio, Integer sucursalId) {
        this.tipoDocumentoId = tipoDocumentoId;
        this.anio = anio;
        this.sucursalId = sucursalId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof ContadorDteId)) return false;
        ContadorDteId that = (ContadorDteId) o;
        return Objects.equals(tipoDocumentoId, that.tipoDocumentoId) &&
                Objects.equals(anio, that.anio) &&
                Objects.equals(sucursalId, that.sucursalId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(tipoDocumentoId, anio, sucursalId);
    }
}
