// lib/features/home/widgets/quick_stats_card.dart

import 'package:flutter/material.dart';

class QuickStatsCard extends StatelessWidget {
  final Map<String, dynamic> estadisticas;

  const QuickStatsCard({super.key, required this.estadisticas});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.analytics, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Resumen Estadístico',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            if (estadisticas['totalRegistros'] == 0)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'No hay suficientes registros para mostrar estadísticas',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              _buildStatsGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Column(
      children: [
        // Primera fila: Sistólica
        _buildStatRow(
          'Sistólica',
          estadisticas['promedioSistolica'],
          estadisticas['maximaSistolica'],
          estadisticas['minimaSistolica'],
          Colors.red,
        ),

        const SizedBox(height: 12),

        // Segunda fila: Diastólica
        _buildStatRow(
          'Diastólica',
          estadisticas['promedioDiastolica'],
          estadisticas['maximaDiastolica'],
          estadisticas['minimaDiastolica'],
          Colors.blue,
        ),

        const SizedBox(height: 12),

        // Tercera fila: Pulso
        _buildStatRow(
          'Pulso',
          estadisticas['promedioPulso'],
          null,
          null,
          Colors.green,
        ),

        const SizedBox(height: 8),

        // Total de registros
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.list_alt, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                'Total de registros: ${estadisticas['totalRegistros']}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatRow(
    String title,
    double promedio,
    int? maxima,
    int? minima,
    Color color,
  ) {
    return Row(
      children: [
        // Título
        SizedBox(
          width: 80,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),

        // Promedio
        Expanded(
          child: Column(
            children: [
              const Text(
                'Promedio',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                promedio.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),

        // Máxima (si existe)
        if (maxima != null)
          Expanded(
            child: Column(
              children: [
                const Text(
                  'Máxima',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  maxima.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),

        // Mínima (si existe)
        if (minima != null)
          Expanded(
            child: Column(
              children: [
                const Text(
                  'Mínima',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  minima.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
