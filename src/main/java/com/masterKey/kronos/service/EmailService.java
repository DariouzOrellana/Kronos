package com.masterKey.kronos.service;

import com.masterKey.kronos.model.Parametro;
import com.masterKey.kronos.model.Venta;
import com.masterKey.kronos.service.ParametroService.ParametroService;
import com.masterKey.kronos.service.VentaService.VentaService;
import jakarta.mail.Message;
import jakarta.mail.Multipart;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeBodyPart;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.internet.MimeMultipart;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;
import java.util.Map;

@Service
public class EmailService {

    private final JavaMailSender mailSender;
    private final VentaService ventaService;
    private final JsonHelper jsonHelper;
    private final JasperReportService jasperReportService;
    private final ParametroService parametroService;

    @Autowired
    public EmailService(JavaMailSender javaMailSender,
                        VentaService ventaService,
                        JsonHelper jsonHelper,
                        JasperReportService jasperReportService,
                        ParametroService parametroService) {
        this.mailSender = javaMailSender;
        this.ventaService = ventaService;
        this.jsonHelper = jsonHelper;
        this.jasperReportService = jasperReportService;
        this.parametroService = parametroService;
    }

    @Async
    public void enviarCorreo(Long idVenta, String destinatario) {

        if (destinatario == null || destinatario.isBlank()) {
            return;
        }

        File tempPdf = null;
        File tempJson = null;
        File tempLogo = null;

        try {
            // =========================
            // Datos de la venta
            // =========================
            Venta venta = ventaService.findById(idVenta);
            String json = jsonHelper.identificarJson(idVenta);

            // =========================
            // Crear archivos temporales
            // =========================
            tempPdf = File.createTempFile(venta.getCodigoGeneracion(), ".pdf");
            Files.write(tempPdf.toPath(),
                    jasperReportService.generarReporteDte(venta.getId()));

            tempJson = File.createTempFile(venta.getCodigoGeneracion(), ".json");
            Files.writeString(tempJson.toPath(), json, StandardCharsets.UTF_8);

            try (InputStream is = getClass()
                    .getResourceAsStream("/static/img/master_key.png")) {

                if (is == null) {
                    throw new RuntimeException("No se encontró el logo");
                }

                tempLogo = File.createTempFile("logo_masterkey", ".png");
                Files.copy(is, tempLogo.toPath(), StandardCopyOption.REPLACE_EXISTING);
            }

            // =========================
            // HTML del correo
            // =========================
            String cuerpoHtml = parametroService.findById("HTML_CORREO_TEMPLATE")
                    .map(Parametro::getValor)
                    .orElse("");

            Map<String, String> valores = Map.of(
                    "{nombre_empresa}", venta.getUsuario().getCaja().getSucursal().getEmpresa().getNombreEmpresa(),
                    "{nombre_cliente}", venta.getNombreFactura(),
                    "{codigo_generacion}", venta.getCodigoGeneracion(),
                    "{numero_control}", venta.getNumeroControl(),
                    "{sello}", venta.getSelloMh() == null ? "" : venta.getSelloMh(),
                    "{fecha_hora_emision}", venta.getFecha().toLocalDate().toString(),
                    "{monto_total}", String.format("$%.2f", venta.getTotal()),
                    "{telefono_empresa}", venta.getUsuario().getCaja().getSucursal().getEmpresa().getTelefono(),
                    "{direccion_empresa}", venta.getUsuario().getCaja().getSucursal().getEmpresa().getDireccion(),
                    "{anio_actual}", String.valueOf(LocalDate.now().getYear())
            );

            for (var e : valores.entrySet()) {
                cuerpoHtml = cuerpoHtml.replace(e.getKey(), e.getValue());
            }

            // =========================
            // Crear mensaje
            // =========================
            MimeMessage message = mailSender.createMimeMessage();
            message.setFrom(new InternetAddress("masterkeysv04@gmail.com"));
            message.setRecipients(Message.RecipientType.TO,
                    InternetAddress.parse(destinatario));
            message.setSubject("Facturación Electrónica - MasterKey "
                    + venta.getCodigoGeneracion(), "UTF-8");

            // =========================
            // Parte HTML
            // =========================
            MimeBodyPart htmlPart = new MimeBodyPart();
            htmlPart.setContent(cuerpoHtml, "text/html; charset=UTF-8");

            // =========================
            // Imagen INLINE (CID)
            // =========================
            MimeBodyPart logoPart = new MimeBodyPart();
            logoPart.attachFile(tempLogo);
            logoPart.setContentID("<logoEmpresa>");
            logoPart.setDisposition(MimeBodyPart.INLINE);

            // =========================
            // Adjuntos
            // =========================
            MimeBodyPart pdfPart = new MimeBodyPart();
            pdfPart.attachFile(tempPdf);

            MimeBodyPart jsonPart = new MimeBodyPart();
            jsonPart.attachFile(tempJson);

            // =========================
            // Multipart FINAL (orden IMPORTA)
            // =========================
            Multipart multipart = new MimeMultipart();
            multipart.addBodyPart(htmlPart);
            multipart.addBodyPart(logoPart);
            multipart.addBodyPart(pdfPart);
            multipart.addBodyPart(jsonPart);

            message.setContent(multipart);
            mailSender.send(message);
            //Transport.send(message);

            System.out.println("Correo enviado correctamente a " + destinatario);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (tempPdf != null) tempPdf.delete();
            if (tempJson != null) tempJson.delete();
            if (tempLogo != null) tempLogo.delete();
        }
    }

    public void enviarCorreo2(Long idVenta, String destinatario) {

        if (destinatario == null || destinatario.isBlank()) {
            return;
        }

        File tempPdf = null;
        File tempJson = null;
        File tempLogo = null;

        try {
            // =========================
            // Datos de la venta
            // =========================
            Venta venta = ventaService.findById(idVenta);
            String json = jsonHelper.identificarJson(idVenta);

            // =========================
            // Crear archivos temporales
            // =========================
            tempPdf = File.createTempFile(venta.getCodigoGeneracion(), ".pdf");
            Files.write(tempPdf.toPath(),
                    jasperReportService.generarReporteDte(venta.getId()));

            tempJson = File.createTempFile(venta.getCodigoGeneracion(), ".json");
            Files.writeString(tempJson.toPath(), json, StandardCharsets.UTF_8);

            try (InputStream is = getClass()
                    .getResourceAsStream("/static/img/master_key.png")) {

                if (is == null) {
                    throw new RuntimeException("No se encontró el logo");
                }

                tempLogo = File.createTempFile("logo_masterkey", ".png");
                Files.copy(is, tempLogo.toPath(), StandardCopyOption.REPLACE_EXISTING);
            }

            // =========================
            // HTML del correo
            // =========================
            String cuerpoHtml = parametroService.findById("HTML_CORREO_TEMPLATE")
                    .map(Parametro::getValor)
                    .orElse("");

            Map<String, String> valores = Map.of(
                    "{nombre_empresa}", venta.getUsuario().getCaja().getSucursal().getEmpresa().getNombreEmpresa(),
                    "{nombre_cliente}", venta.getNombreFactura(),
                    "{codigo_generacion}", venta.getCodigoGeneracion(),
                    "{numero_control}", venta.getNumeroControl(),
                    "{sello}", venta.getSelloMh() == null ? "" : venta.getSelloMh(),
                    "{fecha_hora_emision}", venta.getFecha().toLocalDate().toString(),
                    "{monto_total}", String.format("$%.2f", venta.getTotal()),
                    "{telefono_empresa}", venta.getUsuario().getCaja().getSucursal().getEmpresa().getTelefono(),
                    "{direccion_empresa}", venta.getUsuario().getCaja().getSucursal().getEmpresa().getDireccion(),
                    "{anio_actual}", String.valueOf(LocalDate.now().getYear())
            );

            for (var e : valores.entrySet()) {
                cuerpoHtml = cuerpoHtml.replace(e.getKey(), e.getValue());
            }

            // =========================
            // Crear mensaje
            // =========================
            MimeMessage message = mailSender.createMimeMessage();
            message.setFrom(new InternetAddress("masterkeysv04@gmail.com"));
            message.setRecipients(Message.RecipientType.TO,
                    InternetAddress.parse(destinatario));
            message.setSubject("Facturación Electrónica - MasterKey "
                    + venta.getCodigoGeneracion(), "UTF-8");

            // =========================
            // Parte HTML
            // =========================
            MimeBodyPart htmlPart = new MimeBodyPart();
            htmlPart.setContent(cuerpoHtml, "text/html; charset=UTF-8");

            // =========================
            // Imagen INLINE (CID)
            // =========================
            MimeBodyPart logoPart = new MimeBodyPart();
            logoPart.attachFile(tempLogo);
            logoPart.setContentID("<logoEmpresa>");
            logoPart.setDisposition(MimeBodyPart.INLINE);

            // =========================
            // Adjuntos
            // =========================
            MimeBodyPart pdfPart = new MimeBodyPart();
            pdfPart.attachFile(tempPdf);

            MimeBodyPart jsonPart = new MimeBodyPart();
            jsonPart.attachFile(tempJson);

            // =========================
            // Multipart FINAL (orden IMPORTA)
            // =========================
            Multipart multipart = new MimeMultipart();
            multipart.addBodyPart(htmlPart);
            multipart.addBodyPart(logoPart);
            multipart.addBodyPart(pdfPart);
            multipart.addBodyPart(jsonPart);

            message.setContent(multipart);
            mailSender.send(message);
            //Transport.send(message);

            System.out.println("Correo enviado correctamente a " + destinatario);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (tempPdf != null) tempPdf.delete();
            if (tempJson != null) tempJson.delete();
            if (tempLogo != null) tempLogo.delete();
        }
    }

    @Async
    public void enviarCorreoInvalidacion(Long idVenta, String destinatario) {

        if (destinatario == null || destinatario.isBlank()) {
            return;
        }

        File tempPdf = null;
        File tempJson = null;
        File tempLogo = null;

        try {
            Venta venta = ventaService.findById(idVenta);
            String json = jsonHelper.identificarJson(idVenta);

            tempPdf = File.createTempFile(venta.getCodigoGeneracion(), ".pdf");
            Files.write(tempPdf.toPath(),
                    jasperReportService.generarReporteDte(venta.getId()));

            tempJson = File.createTempFile(venta.getCodigoGeneracion(), ".json");
            Files.writeString(tempJson.toPath(), json, StandardCharsets.UTF_8);

            try (InputStream is = getClass().getResourceAsStream("/static/img/master_key.png")) {

                if (is == null) {
                    throw new RuntimeException("No se encontró el logo");
                }

                tempLogo = File.createTempFile("logo_masterkey", ".png");
                Files.copy(is, tempLogo.toPath(), StandardCopyOption.REPLACE_EXISTING);
            }

            String cuerpoHtml = parametroService.findById("HTML_CORREO_INVALIDACION")
                    .map(Parametro::getValor)
                    .orElse("");

            if (cuerpoHtml == null || cuerpoHtml.isBlank()) {
                cuerpoHtml = parametroService.findById("HTML_CORREO_TEMPLATE")
                        .map(Parametro::getValor)
                        .orElse("");
            }

            Map<String, String> valores = Map.of(
                    "{nombre_empresa}", venta.getUsuario().getCaja().getSucursal().getEmpresa().getNombreEmpresa(),
                    "{nombre_cliente}", venta.getNombreFactura(),
                    "{codigo_generacion}", venta.getCodigoGeneracion(),
                    "{numero_control}", venta.getNumeroControl(),
                    "{sello}", venta.getCodigoGeneracionAnulacion() == null ? "" : venta.getCodigoGeneracionAnulacion(),
                    "{fecha_hora_emision}", venta.getFecha().toLocalDate().toString(),
                    "{monto_total}", String.format("$%.2f", venta.getTotal()),
                    "{telefono_empresa}", venta.getUsuario().getCaja().getSucursal().getEmpresa().getTelefono(),
                    "{direccion_empresa}", venta.getUsuario().getCaja().getSucursal().getEmpresa().getDireccion(),
                    "{anio_actual}", String.valueOf(LocalDate.now().getYear())
            );

            for (var e : valores.entrySet()) {
                cuerpoHtml = cuerpoHtml.replace(e.getKey(), e.getValue());
            }

            MimeMessage message = mailSender.createMimeMessage();
            message.setFrom(new InternetAddress("masterkeysv04@gmail.com"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(destinatario));
            message.setSubject("Invalidación DTE - MasterKey " + venta.getCodigoGeneracion(), "UTF-8");

            MimeBodyPart htmlPart = new MimeBodyPart();
            htmlPart.setContent(cuerpoHtml, "text/html; charset=UTF-8");

            MimeBodyPart logoPart = new MimeBodyPart();
            logoPart.attachFile(tempLogo);
            logoPart.setContentID("<logoEmpresa>");
            logoPart.setDisposition(MimeBodyPart.INLINE);

            MimeBodyPart pdfPart = new MimeBodyPart();
            pdfPart.attachFile(tempPdf);

            MimeBodyPart jsonPart = new MimeBodyPart();
            jsonPart.attachFile(tempJson);

            Multipart multipart = new MimeMultipart();
            multipart.addBodyPart(htmlPart);
            multipart.addBodyPart(logoPart);
            multipart.addBodyPart(pdfPart);
            multipart.addBodyPart(jsonPart);

            message.setContent(multipart);
            mailSender.send(message);

            System.out.println("Correo de invalidación enviado correctamente a " + destinatario);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (tempPdf != null) tempPdf.delete();
            if (tempJson != null) tempJson.delete();
            if (tempLogo != null) tempLogo.delete();
        }
    }


}
