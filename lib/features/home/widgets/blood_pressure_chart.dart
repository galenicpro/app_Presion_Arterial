// lib/features/home/widgets/blood_pressure_chart.dart

import 'package:flutter/material.dart';
import '../../../data/models/lectura_ta.dart';

class BloodPressureChart extends StatelessWidget {
  final List<LecturaTa> lecturas;

  const BloodPressureChart({super.key, required this.lecturas});

  @override
  Widget build(BuildContext context) {
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

            // Placeholder del gráfico (será reemplazado con fl_chart)
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade50,
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bar_chart, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      'Gráfico de evolución\n(Próximamente)',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Leyenda simplificada
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _LegendItem(color: Colors.red, text: 'Sistólica'),
                _LegendItem(color: Colors.blue, text: 'Diastólica'),
                _LegendItem(color: Colors.green, text: 'Pulso'),
              ],
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
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
