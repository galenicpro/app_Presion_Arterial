// lib/features/home/widgets/blood_pressure_chart.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../data/models/lectura_ta.dart';

class BloodPressureChart extends StatelessWidget {
  final List<LecturaTa> lecturas;

  const BloodPressureChart({super.key, required this.lecturas});

  @override
  Widget build(BuildContext context) {
    if (lecturas.isEmpty) {
      return _buildEmptyChart(context);
    }

    // Ordenar por fecha (más antiguas primero) y tomar máximo 15 lecturas
    final sortedLecturas =
        lecturas
            .where(
              (lectura) => lectura.fecha.isAfter(
                DateTime.now().subtract(const Duration(days: 30)),
              ),
            )
            .toList()
          ..sort((a, b) => a.fecha.compareTo(b.fecha));

    final chartLecturas = sortedLecturas.length > 15
        ? sortedLecturas.sublist(sortedLecturas.length - 15)
        : sortedLecturas;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título del gráfico
            const Row(
              children: [
                Icon(Icons.show_chart, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Evolución de la Presión Arterial',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Gráfico real con fl_chart
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 20,
                    verticalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade300,
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade300,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: chartLecturas.length > 7 ? 2 : 1,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 &&
                              value.toInt() < chartLecturas.length) {
                            final fecha = chartLecturas[value.toInt()].fecha;
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                '${fecha.day}/${fecha.month}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 20,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey.shade400, width: 1),
                  ),
                  minX: 0,
                  maxX: (chartLecturas.length - 1).toDouble(),
                  minY: 40,
                  maxY: 200,
                  lineBarsData: [
                    // Línea de Sistólica (roja)
                    LineChartBarData(
                      spots: _generateSpots(chartLecturas, 'sistolica'),
                      isCurved: true,
                      color: Colors.red,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
                    ),
                    // Línea de Diastólica (azul)
                    LineChartBarData(
                      spots: _generateSpots(chartLecturas, 'diastolica'),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
                    ),
                    // Línea de Pulso (verde) - en escala secundaria
                    LineChartBarData(
                      spots: _generateSpots(chartLecturas, 'pulso'),
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: Colors.blueGrey.withAlpha(
                        200,
                      ), // CORREGIDO: usar withAlpha
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots
                            .map((touchedSpot) {
                              final index = touchedSpot.spotIndex;
                              if (index < 0 || index >= chartLecturas.length) {
                                return null;
                              }
                              final lectura = chartLecturas[index];
                              final text = switch (touchedSpot.barIndex) {
                                0 => 'Sistólica: ${lectura.sistolica} mmHg',
                                1 => 'Diastólica: ${lectura.diastolica} mmHg',
                                2 => 'Pulso: ${lectura.pulso} bpm',
                                _ => '',
                              };
                              return LineTooltipItem(
                                text,
                                const TextStyle(color: Colors.white),
                              );
                            })
                            .where((item) => item != null)
                            .cast<LineTooltipItem>()
                            .toList();
                      },
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Leyenda interactiva
            _buildLegend(),

            // Información adicional
            if (chartLecturas.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildAdditionalInfo(chartLecturas),
            ],
          ],
        ),
      ),
    );
  }

  List<FlSpot> _generateSpots(List<LecturaTa> lecturas, String tipo) {
    return List.generate(lecturas.length, (index) {
      final value = switch (tipo) {
        'sistolica' => lecturas[index].sistolica.toDouble(),
        'diastolica' => lecturas[index].diastolica.toDouble(),
        'pulso' => lecturas[index].pulso.toDouble(),
        _ => 0.0,
      };
      return FlSpot(index.toDouble(), value);
    });
  }

  Widget _buildLegend() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _LegendItem(color: Colors.red, text: 'Sistólica (mmHg)'),
        _LegendItem(color: Colors.blue, text: 'Diastólica (mmHg)'),
        _LegendItem(color: Colors.green, text: 'Pulso (bpm)'),
      ],
    );
  }

  Widget _buildAdditionalInfo(List<LecturaTa> lecturas) {
    final ultima = lecturas.last;
    final primera = lecturas.first;
    final dias = ultima.fecha.difference(primera.fecha).inDays;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Período: $dias días',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                'Registros: ${lecturas.length}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Última: ${ultima.sistolica}/${ultima.diastolica}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              Text(
                'Categoría: ${ultima.categoriaPresion}',
                style: TextStyle(
                  fontSize: 12,
                  color: _getCategoryColor(ultima.categoriaPresion),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String categoria) {
    return switch (categoria) {
      'Crisis Hipertensiva' => Colors.red,
      'Hipertensión Grado 1' => Colors.orange,
      'Presión Elevada' => Colors.amber.shade700,
      'Normal' => Colors.green,
      'Óptima' => Colors.green.shade800,
      _ => Colors.grey,
    };
  }

  Widget _buildEmptyChart(BuildContext context) {
    // CORREGIDO: agregar context como parámetro
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Icon(Icons.bar_chart, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text(
              'Gráfico de Evolución',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Agregue registros de presión arterial\npara ver la evolución gráfica',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // Navegar a pantalla de registro
                Navigator.of(context).pushNamed('/registro');
              },
              icon: const Icon(Icons.add),
              label: const Text('Agregar Primer Registro'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const _LegendItem({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade400),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
