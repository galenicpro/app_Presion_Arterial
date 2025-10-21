// lib/core/services/recordatorio_service.dart

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../../data/models/medicacion.dart';

class RecordatorioService {
  static final RecordatorioService _instance = RecordatorioService._internal();
  factory RecordatorioService() => _instance;
  RecordatorioService._internal();

  late FlutterLocalNotificationsPlugin _notifications;
  bool _isInitialized = false;

  // Configuración de notificaciones
  static const AndroidNotificationDetails _androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'recordatorio_medicacion_channel',
        'Recordatorios de Medicación',
        channelDescription: 'Recordatorios para tomar medicamentos',
        importance: Importance.high,
        priority: Priority.high,
      );

  static const DarwinNotificationDetails _iOSPlatformChannelSpecifics =
      DarwinNotificationDetails();

  /// Inicializa el servicio de notificaciones
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      // Inicializar timezone
      tz.initializeTimeZones();

      _notifications = FlutterLocalNotificationsPlugin();

      // Configuración para Android
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // Configuración para iOS
      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          );

      final InitializationSettings initializationSettings =
          InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
          );

      await _notifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationTap,
      );

      _isInitialized = true;
      _log('✅ RecordatorioService inicializado');
    } catch (e) {
      _log('❌ Error inicializando RecordatorioService: $e', isError: true);
    }
  }

  /// Programa recordatorios para una medicación
  Future<void> programarRecordatoriosMedicacion(Medicacion medicacion) async {
    if (!_isInitialized) await init();

    try {
      // Cancelar recordatorios existentes para esta medicación
      await cancelarRecordatoriosMedicacion(medicacion);

      if (!medicacion.activa) return;

      for (final dia in medicacion.dias) {
        for (final horario in medicacion.horarios) {
          await _programarRecordatorioDiario(
            medicacion: medicacion,
            diaSemana: dia,
            horario: horario,
          );
        }
      }

      _log('📅 Recordatorios programados para: ${medicacion.nombre}');
    } catch (e) {
      _log('❌ Error programando recordatorios: $e', isError: true);
    }
  }

  /// Programa un recordatorio diario específico
  Future<void> _programarRecordatorioDiario({
    required Medicacion medicacion,
    required int diaSemana,
    required TimeOfDay horario,
  }) async {
    final now = DateTime.now();
    final today = now.weekday;

    // Calcular el próximo día que coincida
    int daysToAdd = diaSemana - today;
    if (daysToAdd < 0) daysToAdd += 7;

    DateTime scheduledDate = DateTime(
      now.year,
      now.month,
      now.day + daysToAdd,
      horario.hour,
      horario.minute,
    );

    // Si ya pasó el horario de hoy, programar para la próxima semana
    if (daysToAdd == 0 && scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 7));
    }

    final notificationId = _generarNotificationId(
      medicacion.key.toString(),
      diaSemana,
      horario,
    );

    // Convertir a TZDateTime
    final tzDateTime = tz.TZDateTime.from(scheduledDate, tz.local);

    await _notifications.zonedSchedule(
      notificationId,
      'Recordatorio de Medicación',
      _generarMensajeRecordatorio(medicacion),
      tzDateTime,
      NotificationDetails(
        android: _androidPlatformChannelSpecifics,
        iOS: _iOSPlatformChannelSpecifics,
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  /// Genera el mensaje del recordatorio
  String _generarMensajeRecordatorio(Medicacion medicacion) {
    String mensaje = 'Es hora de tomar ${medicacion.nombre}';

    if (medicacion.dosis.isNotEmpty) {
      mensaje += ' - ${medicacion.dosis}';
    }

    if (medicacion.instrucciones != null) {
      mensaje += '. ${medicacion.instrucciones}';
    }

    return mensaje;
  }

  /// Cancela todos los recordatorios de una medicación
  Future<void> cancelarRecordatoriosMedicacion(Medicacion medicacion) async {
    if (!_isInitialized) return;

    try {
      for (final dia in medicacion.dias) {
        for (final horario in medicacion.horarios) {
          final notificationId = _generarNotificationId(
            medicacion.key.toString(),
            dia,
            horario,
          );
          await _notifications.cancel(notificationId);
        }
      }
      _log('❌ Recordatorios cancelados para: ${medicacion.nombre}');
    } catch (e) {
      _log('❌ Error cancelando recordatorios: $e', isError: true);
    }
  }

  /// Cancela todos los recordatorios
  Future<void> cancelarTodosLosRecordatorios() async {
    if (!_isInitialized) return;

    try {
      await _notifications.cancelAll();
      _log('🗑️ Todos los recordatorios cancelados');
    } catch (e) {
      _log('❌ Error cancelando todos los recordatorios: $e', isError: true);
    }
  }

  /// Genera un ID único para la notificación
  int _generarNotificationId(String medicacionId, int dia, TimeOfDay horario) {
    return medicacionId.hashCode + dia + horario.hour + horario.minute;
  }

  /// Maneja el tap en la notificación
  void _onNotificationTap(NotificationResponse response) {
    _log('📱 Notificación tocada: ${response.payload}');
  }

  /// Muestra una notificación inmediata (para testing)
  Future<void> mostrarNotificacionInmediata({
    required String titulo,
    required String mensaje,
  }) async {
    if (!_isInitialized) await init();

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      titulo,
      mensaje,
      const NotificationDetails(
        android: _androidPlatformChannelSpecifics,
        iOS: _iOSPlatformChannelSpecifics,
      ),
    );
  }

  /// Obtiene las medicaciones pendientes para hoy
  List<Medicacion> getMedicacionesPendientesHoy(List<Medicacion> medicaciones) {
    final ahora = TimeOfDay.now();
    return medicaciones.where((med) {
      if (!med.activa || !med.esHoy) return false;

      final proximoHorario = med.proximoHorarioHoy;
      if (proximoHorario == null) return false;

      // Considerar pendiente si el horario está dentro de los próximos 30 minutos
      final diferenciaHoras = proximoHorario.hour - ahora.hour;
      final diferenciaMinutos = proximoHorario.minute - ahora.minute;
      final totalMinutos = diferenciaHoras * 60 + diferenciaMinutos;

      return totalMinutos <= 30 && totalMinutos >= 0;
    }).toList();
  }

  /// Verifica si hay medicaciones pendientes ahora
  bool hayMedicacionesPendientes(List<Medicacion> medicaciones) {
    return getMedicacionesPendientesHoy(medicaciones).isNotEmpty;
  }

  // Logging mejorado
  void _log(String message, {bool isError = false}) {
    assert(() {
      debugPrint('RecordatorioService: $message');
      return true;
    }());
  }
}
