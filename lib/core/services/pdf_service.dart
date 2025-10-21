// lib/core/services/pdf_service.dart

import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import '../../data/models/lectura_ta.dart';

class PdfService {
  static Future<void> generateAndSharePdf(List<LecturaTa> lecturas) async {
    final pdf = pw.Document();
    final fechaGeneracion = DateFormat(
      'dd/MM/yyyy HH:mm',
    ).format(DateTime.now());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => [
          _buildHeader(fechaGeneracion),
          _buildSummary(lecturas, context),
          _buildRecordsTable(lecturas, context),
          _buildFooter(),
        ],
      ),
    );

    // Guardar y compartir
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/reporte_presion_arterial.pdf");
    await file.writeAsBytes(await pdf.save());

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  static pw.Widget _buildHeader(String fechaGeneracion) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Reporte de Presión Arterial - CardioCare',
          style: pw.TextStyle(
            fontSize: 20,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue800,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          'Grupo Hogar Salud - $fechaGeneracion',
          style: pw.TextStyle(fontSize: 12, color: PdfColors.grey600),
        ),
        pw.Divider(thickness: 2, color: PdfColors.blue400),
        pw.SizedBox(height: 20),
      ],
    );
  }

  static pw.Widget _buildSummary(List<LecturaTa> lecturas, pw.Context context) {
    if (lecturas.isEmpty) {
      return pw.Center(
        child: pw.Text(
          'No hay registros para mostrar',
          style: pw.TextStyle(fontSize: 16, color: PdfColors.grey600),
        ),
      );
    }

    final ultima = lecturas.first;
    final promedioSistolica =
        lecturas.map((l) => l.sistolica).reduce((a, b) => a + b) /
        lecturas.length;
    final promedioDiastolica =
        lecturas.map((l) => l.diastolica).reduce((a, b) => a + b) /
        lecturas.length;
    final promedioPulso =
        lecturas.map((l) => l.pulso).reduce((a, b) => a + b) / lecturas.length;

    // Encontrar lecturas más altas
    final sistolicaMax = lecturas.reduce(
      (a, b) => a.sistolica > b.sistolica ? a : b,
    );
    final diastolicaMax = lecturas.reduce(
      (a, b) => a.diastolica > b.diastolica ? a : b,
    );

    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.blue200, width: 1),
        borderRadius: pw.BorderRadius.circular(8),
        color: PdfColors.blue50,
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            '📊 Resumen Estadístico',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue800,
            ),
          ),
          pw.SizedBox(height: 12),

          // Primera fila de estadísticas
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCard(
                'Total Registros',
                '${lecturas.length}',
                PdfColors.blue700,
              ),
              _buildStatCard(
                'Período',
                '${_calculateDaysRange(lecturas)} días',
                PdfColors.green700,
              ),
            ],
          ),
          pw.SizedBox(height: 8),

          // Segunda fila de estadísticas
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCard(
                'Prom. Sistólica',
                '${promedioSistolica.round()} mmHg',
                PdfColors.red700,
              ),
              _buildStatCard(
                'Prom. Diastólica',
                '${promedioDiastolica.round()} mmHg',
                PdfColors.blue700,
              ),
              _buildStatCard(
                'Prom. Pulso',
                '${promedioPulso.round()} bpm',
                PdfColors.green700,
              ),
            ],
          ),
          pw.SizedBox(height: 12),

          // Lecturas destacadas
          pw.Text(
            '📈 Lecturas Destacadas:',
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 6),
          pw.Row(
            children: [
              pw.Expanded(
                child: pw.Text(
                  'Sistólica más alta: ${sistolicaMax.sistolica} mmHg (${DateFormat('dd/MM').format(sistolicaMax.fecha)})',
                  style: pw.TextStyle(fontSize: 10, color: PdfColors.red700),
                ),
              ),
              pw.Expanded(
                child: pw.Text(
                  'Diastólica más alta: ${diastolicaMax.diastolica} mmHg (${DateFormat('dd/MM').format(diastolicaMax.fecha)})',
                  style: pw.TextStyle(fontSize: 10, color: PdfColors.blue700),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'Última: ${ultima.sistolica}/${ultima.diastolica} mmHg - ${ultima.categoriaPresion}',
            style: pw.TextStyle(fontSize: 10, color: PdfColors.green700),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildStatCard(String title, String value, PdfColor color) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        border: pw.Border.all(color: color, width: 0.5),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildRecordsTable(
    List<LecturaTa> lecturas,
    pw.Context context,
  ) {
    if (lecturas.isEmpty) return pw.SizedBox();

    // Preparar datos para la tabla
    final tableData = [
      [
        'Fecha',
        'Hora',
        'Sistólica',
        'Diastólica',
        'Pulso',
        'Categoría',
        'Síntomas',
      ],
      ...lecturas.map(
        (lectura) => [
          DateFormat('dd/MM/yyyy').format(lectura.fecha),
          DateFormat('HH:mm').format(lectura.fecha),
          '${lectura.sistolica} mmHg',
          '${lectura.diastolica} mmHg',
          '${lectura.pulso} bpm',
          lectura.categoriaPresion,
          lectura.sintomas!.isNotEmpty
              ? lectura.sintomas
              : '-', // CORREGIDO: null safety
        ],
      ),
    ];

    return pw.Column(
      children: [
        pw.SizedBox(height: 20),
        pw.Text(
          '📋 Historial Detallado de Registros',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue800,
          ),
        ),
        pw.SizedBox(height: 12),
        pw.TableHelper.fromTextArray(
          // CORREGIDO: Usar TableHelper en lugar de Table
          context: context,
          headers: tableData[0] as List<String>,
          data: tableData.sublist(1) as List<List<String>>,
          headerStyle: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.white,
            fontSize: 10,
          ),
          headerDecoration: pw.BoxDecoration(color: PdfColors.blue700),
          cellStyle: const pw.TextStyle(fontSize: 9),
          cellAlignment: pw.Alignment.centerLeft,
          cellPadding: const pw.EdgeInsets.all(6),
          border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
        ),
      ],
    );
  }

  static pw.Widget _buildFooter() {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 30),
      child: pw.Column(
        children: [
          pw.Divider(color: PdfColors.grey400),
          pw.SizedBox(height: 10),
          pw.Text(
            '💙 Este reporte fue generado automáticamente por CardioCare - Grupo Hogar Salud',
            style: pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey600,
              fontStyle: pw.FontStyle.italic,
            ),
            textAlign: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            '⚠️ Consulte a su médico para una interpretación profesional de estos datos',
            style: pw.TextStyle(
              fontSize: 9,
              color: PdfColors.orange700,
              fontStyle: pw.FontStyle.italic,
            ),
            textAlign: pw.TextAlign.center,
          ),
        ],
      ),
    );
  }

  static int _calculateDaysRange(List<LecturaTa> lecturas) {
    if (lecturas.length < 2) return 1;
    final primera = lecturas.last.fecha;
    final ultima = lecturas.first.fecha;
    return ultima.difference(primera).inDays + 1;
  }
}
