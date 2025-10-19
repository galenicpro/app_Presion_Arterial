// lib/features/home/widgets/empty_state.dart

import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icono grande y llamativo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border,
                size: 60,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 32),

            // Título principal
            const Text(
              'Bienvenido a CardioCare',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Subtítulo
            const Text(
              'Comienza a registrar tu presión arterial',
              style: TextStyle(fontSize: 18, color: Colors.grey),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Instrucción clara
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.touch_app, color: Colors.green, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Presiona el botón "+" abajo para agregar tu primer registro',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Información adicional para adultos mayores
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      '💡 Recomendaciones:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• Toma tu presión a la misma hora cada día\n'
                      '• Descansa 5 minutos antes de medir\n'
                      '• Mantén el brazo a la altura del corazón\n'
                      '• Registra cualquier síntoma que sientas',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
