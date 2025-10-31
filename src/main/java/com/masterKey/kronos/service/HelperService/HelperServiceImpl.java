package com.masterKey.kronos.service.HelperService;

import com.masterKey.kronos.model.Parametro;
import com.masterKey.kronos.service.ParametroService.ParametroService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.Optional;

@Service
public class HelperServiceImpl implements HelperService {

    private ParametroService parametroService;

    @Autowired
    public HelperServiceImpl(ParametroService parametroService) {
        this.parametroService = parametroService;
    }

    @Override
    public void actualizarTokenMH() {
        // Obtener tiempo de recarga
        String tiempo = parametroService.findById("recargaParametro")
                .map(Parametro::getValor)
                .orElse("23:30");
        System.out.println("Tiempo configurado para recarga: " + tiempo);

        // Convertir tiempo a Duration
        String[] partes = tiempo.split(":");
        long horas = Long.parseLong(partes[0]);
        long minutos = Long.parseLong(partes[1]);
        Duration duracion = Duration.ofHours(horas).plusMinutes(minutos);
        System.out.println("Duración en horas:minutos -> " + duracion.toHours() + "h " + duracion.toMinutesPart() + "m");

        // Revisar tokenMH
        parametroService.findById("tokenMH").ifPresentOrElse(
                p -> {
                    System.out.println("Verificando tokenMH...");
                    LocalDateTime ultActualizacion = p.getUpdatedAt();
                    LocalDateTime ahora = LocalDateTime.now();

                    System.out.println("Última actualización: " + ultActualizacion);
                    System.out.println("Hora actual: " + ahora);

                    Duration transcurrido = Duration.between(ultActualizacion, ahora);
                    System.out.println("Tiempo transcurrido desde última actualización: "
                            + transcurrido.toHours() + "h " + transcurrido.toMinutesPart() + "m");

                    if (transcurrido.compareTo(duracion) > 0) {
                        System.out.println("⏰ Ha pasado más del tiempo configurado. Actualizando tokenMH...");
                        String nuevoToken = "PRUEBITAS"; // Mh.obtenerToken()
                        p.setValor(nuevoToken);
                        p.setUpdatedAt(LocalDateTime.now());
                        parametroService.save(p);
                        System.out.println("✅ TokenMH actualizado: " + nuevoToken);
                    } else {
                        System.out.println("✅ TokenMH aún vigente, no se actualiza.");
                    }
                },
                () -> {
                    System.out.println("El parámetro tokenMH no existe, creándolo...");
                    Parametro parametro = new Parametro();
                    parametro.setNombreParametro("tokenMH");
                    parametro.setValor("PRUEBITAS"); // Mh.obtenerToken()
                    parametro.setCreatedAt(LocalDateTime.now());
                    parametro.setUpdatedAt(LocalDateTime.now());
                    parametroService.save(parametro);
                    System.out.println("✅ TokenMH creado: " + parametro.getValor());
                }
        );
    }

}
