// lib/features/home/widgets/registro_list_item.dart

import 'package:flutter/material.dart';
import '../../../data/models/lectura_ta.dart';

class RegistroListItem extends StatelessWidget {
  final LecturaTa lectura;
  final VoidCallback? onTap;

  const RegistroListItem({super.key, required this.lectura, this.onTap});

  @override
  Widget build(BuildContext context) {
    // CORREGIDO: Usar la categoría directamente del modelo LecturaTa
    final categoria = lectura.categoriaPresion;
    final color = _getColorForCategoria(categoria);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        // CORREGIDO: Reemplazado withOpacity por withAlpha
        side: BorderSide(color: color.withAlpha(77), width: 2), // ~30% opacity
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Primera fila: Presión y estado
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Presión arterial
                  Text(
                    '${lectura.sistolica}/${lectura.diastolica} mmHg',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),

                  // Estado con badge de color
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      // CORREGIDO: Reemplazado withOpacity por withAlpha
                      color: color.withAlpha(25), // ~10% opacity
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: color),
                    ),
                    child: Text(
                      categoria,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Segunda fila: Pulso y fecha/hora
              Row(
                children: [
                  // Pulso
                  Row(
                    children: [
                      const Icon(Icons.favorite, size: 18, color: Colors.red),
                      const SizedBox(width: 4),
                      Text(
                        'Pulso: ${lectura.pulso} bpm',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Fecha y hora
                  Text(
                    _formatDateTime(lectura.fecha),
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),

              // Tercera fila: Síntomas (si existen)
              if (lectura.sintomas != null && lectura.sintomas!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber,
                        size: 16,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Síntomas: ${lectura.sintomas!}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.orange,
                            fontStyle: FontStyle.italic,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getColorForCategoria(String categoria) {
    switch (categoria) {
      case 'Crisis Hipertensiva':
        return Colors.red;
      case 'Hipertensión Grado 1':
        return Colors.orange;
      case 'Presión Elevada':
        return Colors
            .amber; // Usar Colors.amber en lugar de Colors.yellow.shade700
      case 'Normal':
        return Colors.green;
      case 'Óptima':
        return const Color(0xFF2E7D32); // Verde oscuro directamente
      default:
        return Colors.grey;
    }
  }

  String _formatDateTime(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(date.year, date.month, date.day);

    String dateText;
    if (dateToCheck == today) {
      dateText = 'Hoy';
    } else if (dateToCheck == yesterday) {
      dateText = 'Ayer';
    } else {
      dateText = '${date.day}/${date.month}/${date.year}';
    }

    final timeText =
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

    return '$dateText - $timeText';
  }
}
