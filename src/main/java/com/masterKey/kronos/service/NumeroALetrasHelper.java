package com.masterKey.kronos.service;

import org.springframework.stereotype.Service;

import java.text.DecimalFormat;

@Service
public class NumeroALetrasHelper {

    private final String[] UNIDADES = {
            "", "UNO", "DOS", "TRES", "CUATRO", "CINCO",
            "SEIS", "SIETE", "OCHO", "NUEVE", "DIEZ",
            "ONCE", "DOCE", "TRECE", "CATORCE", "QUINCE",
            "DIECISÉIS", "DIECISIETE", "DIECIOCHO", "DIECINUEVE", "VEINTE"
    };

    private final String[] DECENAS = {
            "VEINTI", "TREINTA", "CUARENTA", "CINCUENTA",
            "SESENTA", "SETENTA", "OCHENTA", "NOVENTA"
    };

    private final String[] CENTENAS = {
            "", "CIENTO", "DOSCIENTOS", "TRESCIENTOS",
            "CUATROCIENTOS", "QUINIENTOS", "SEISCIENTOS",
            "SETECIENTOS", "OCHOCIENTOS", "NOVECIENTOS"
    };

    public String convertir(double numero) {
        if (numero == 0) {
            return "CERO";
        }

        long parteEntera = (long) numero;
        int centavos = (int) Math.round((numero - parteEntera) * 100);

        String letras = convertirNumero((int) (parteEntera / 1000000)) + (parteEntera >= 1000000 ? " MILLONES " : "");
        letras += convertirNumero((int) ((parteEntera % 1000000) / 1000)) + ((parteEntera % 1000000) >= 1000 ? " MIL " : "");
        letras += convertirNumero((int) (parteEntera % 1000));

        letras = letras.trim().replaceAll("\\s+", " ");

        if (centavos > 0) {
            letras += " CON " + String.format("%02d", centavos) + "/100";
        }

        return letras.trim();
    }

    private String convertirNumero(int numero) {
        if (numero == 0) return "";
        if (numero <= 20) return UNIDADES[numero];
        if (numero < 30) return DECENAS[0] + UNIDADES[numero - 20].toLowerCase();

        if (numero < 100) {
            int decena = numero / 10;
            int unidad = numero % 10;
            return DECENAS[decena - 2] + (unidad > 0 ? " Y " + UNIDADES[unidad] : "");
        }

        if (numero == 100) return "CIEN";
        if (numero < 1000) {
            int centena = numero / 100;
            int resto = numero % 100;
            return CENTENAS[centena] + (resto > 0 ? " " + convertirNumero(resto) : "");
        }

        return "";
    }
}

