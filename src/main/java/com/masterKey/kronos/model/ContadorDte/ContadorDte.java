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

}

