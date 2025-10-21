// lib/features/historial/widgets/export_pdf_button.dart

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../../../data/repositories/lectura_repository.dart';
import '../../../data/models/lectura_ta.dart';

class ExportPdfButton extends StatelessWidget {
  const ExportPdfButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.picture_as_pdf),
      onPressed: () => _exportToPdf(context),
      tooltip: 'Exportar a PDF',
    );
  }

  Future<void> _exportToPdf(BuildContext context) async {
    if (!context.mounted) return;

    try {
      final repository = LecturaRepository();
      final lecturas = repository.getAllLecturas();
      final estadisticas = repository.getEstadisticas();

      if (lecturas.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No hay registros para exportar')),
        );
        return;
      }

      final pdf = await _generatePdf(lecturas, estadisticas);

      await Printing.layoutPdf(
        onLayout: (format) => pdf.save(),
        name:
            'Reporte_CardioCare_${DateFormat('yyyyMMdd').format(DateTime.now())}',
      );

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF generado exitosamente')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error generando PDF: $e')));
    }
  }

  Future<pw.Document> _generatePdf(
    List<LecturaTa> lecturas,
    Map<String, dynamic> estadisticas,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            _buildHeader(),
            pw.SizedBox(height: 20),
            _buildStatistics(estadisticas),
            pw.SizedBox(height: 20),
            _buildTable(lecturas),
          ];
        },
      ),
    );

    return pdf;
  }

  pw.Widget _buildHeader() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'CardioCare - Reporte de Presión Arterial',
          style: pw.TextStyle(
            fontSize: 20,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.Text(
          'Grupo Hogar Salud',
          style: pw.TextStyle(fontSize: 14, color: PdfColors.blue800),
        ),
        pw.SizedBox(height: 10),
        pw.Text(
          'Fecha de generación: ${DateFormat('dd/MM/yyyy, HH:mm').format(DateTime.now())}',
          style: const pw.TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  pw.Widget _buildStatistics(Map<String, dynamic> stats) {
    String formatValue(dynamic value, [String unit = '']) {
      return (value is double ? value.toStringAsFixed(1) : value.toString()) +
          unit;
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Total de registros: ${stats['totalRegistros']}',
          style: const pw.TextStyle(fontSize: 12),
        ),
        pw.SizedBox(height: 10),
        pw.Text(
          'Resumen Estadístico',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue700,
          ),
        ),
        pw.SizedBox(height: 5),

        // Fila Sistólica
        pw.Text(
          'Presión Sistólica - Promedio: ${formatValue(stats['promedioSistolica'], ' mmHg')} | '
          'Máxima: ${formatValue(stats['maximaSistolica'], ' mmHg')} | '
          'Mínima: ${formatValue(stats['minimaSistolica'], ' mmHg')}',
          style: const pw.TextStyle(fontSize: 11),
        ),

        // Fila Diastólica
        pw.Text(
          'Presión Diastólica - Promedio: ${formatValue(stats['promedioDiastolica'], ' mmHg')} | '
          'Máxima: ${formatValue(stats['maximaDiastolica'], ' mmHg')} | '
          'Mínima: ${formatValue(stats['minimaDiastolica'], ' mmHg')}',
          style: const pw.TextStyle(fontSize: 11),
        ),

        // Fila Pulso
        pw.Text(
          'Pulso - Promedio: ${formatValue(stats['promedioPulso'], ' bpm')}',
          style: const pw.TextStyle(fontSize: 11),
        ),
      ],
    );
  }

  pw.Widget _buildTable(List<LecturaTa> lecturas) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey500),
      columnWidths: {
        0: const pw.FlexColumnWidth(2),
        1: const pw.FlexColumnWidth(1.5),
        2: const pw.FlexColumnWidth(1.5),
        3: const pw.FlexColumnWidth(1),
        4: const pw.FlexColumnWidth(2),
        5: const pw.FlexColumnWidth(3),
      },
      children: [
        // Encabezado
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.blue700),
          children: [
            _buildHeaderCell('Fecha'),
            _buildHeaderCell('Hora'),
            _buildHeaderCell('Presión (mmHg)'),
            _buildHeaderCell('Pulso (bpm)'),
            _buildHeaderCell('Estado'),
            _buildHeaderCell('Síntomas'),
          ],
        ),
        // Filas de datos
        for (final lectura in lecturas)
          pw.TableRow(
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(color: PdfColors.grey200),
              ),
            ),
            children: [
              _buildTableCell(DateFormat('dd/MM/yyyy').format(lectura.fecha)),
              _buildTableCell(DateFormat('HH:mm').format(lectura.fecha)),
              _buildTableCell('${lectura.sistolica}/${lectura.diastolica}'),
              _buildTableCell('${lectura.pulso}'),
              _buildTableCell(lectura.categoriaPresion),
              _buildTableCell(
                lectura.sintomas?.isNotEmpty == true ? lectura.sintomas! : '-',
              ),
            ],
          ),
      ],
    );
  }

  pw.Widget _buildHeaderCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          fontSize: 10,
          color: PdfColors.white,
        ),
      ),
    );
  }

  pw.Widget _buildTableCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.left,
        style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 10),
      ),
    );
  }
}
