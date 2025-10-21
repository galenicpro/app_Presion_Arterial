// lib/core/services/notification_service.dart

import 'package:flutter/material.dart';
import '../../data/models/medicacion.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // Placeholder para implementación real con flutter_local_notifications
  // Por ahora usamos un sistema simple de callbacks

  final List<Function(Medicacion)> _onMedicacionListeners = [];

  void addMedicacionListener(Function(Medicacion) listener) {
    _onMedicacionListeners.add(listener);
  }

  void removeMedicacionListener(Function(Medicacion) listener) {
    _onMedicacionListeners.remove(listener);
  }

  // Simular notificación (para desarrollo)
  void simulateMedicacionNotification(Medicacion medicacion) {
    for (final listener in _onMedicacionListeners) {
      listener(medicacion);
    }
  }

  // En una implementación real, aquí iría la lógica con flutter_local_notifications
  Future<void> programarRecordatorios(Medicacion medicacion) async {
    debugPrint('📅 Programando recordatorios para: ${medicacion.nombre}');
    // Implementar con flutter_local_notifications
  }

  Future<void> cancelarRecordatorios(Medicacion medicacion) async {
    debugPrint('❌ Cancelando recordatorios para: ${medicacion.nombre}');
    // Implementar con flutter_local_notifications
  }
}
