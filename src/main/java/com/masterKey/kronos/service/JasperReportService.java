package com.masterKey.kronos.service;

import com.masterKey.kronos.model.Venta;
import com.masterKey.kronos.service.VentaService.VentaService;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.sql.DataSource;
import java.io.InputStream;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;

@Service
public class JasperReportService {

    @Autowired
    private DataSource dataSource;

    public byte[] generarReporteDte(Long idVenta) throws Exception {
        try (
                InputStream reportStream =
                        getClass().getResourceAsStream("/reportes/documento_electronico.jasper");
                InputStream logo =
                        getClass().getResourceAsStream("/reportes/img/master_key.png");
                Connection conn = dataSource.getConnection()
        ) {

            Map<String, Object> params = new HashMap<>();
            params.put("id", idVenta.intValue());
            params.put("LOGO", logo);

            JasperPrint jasperPrint =
                    JasperFillManager.fillReport(reportStream, params, conn);

            return JasperExportManager.exportReportToPdf(jasperPrint);
        }

    }
}
