// lib/data/models/medicacion.dart

import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

part 'medicacion.g.dart';

@HiveType(typeId: 1)
class Medicacion extends HiveObject {
  @HiveField(0)
  final String nombre;

  @HiveField(1)
  final String dosis;

  @HiveField(2)
  final List<int> dias; // [1,2,3,4,5,6,7] donde 1=lunes, 7=domingo

  @HiveField(3)
  final List<TimeOfDay> horarios;

  @HiveField(4)
  final bool activa;

  @HiveField(5)
  final DateTime fechaInicio;

  @HiveField(6)
  final String? instrucciones;

  @HiveField(7)
  final String? viaAdministracion; // Oral, Sublingual, etc.

  Medicacion({
    required this.nombre,
    required this.dosis,
    required this.dias,
    required this.horarios,
    this.activa = true,
    required this.fechaInicio,
    this.instrucciones,
    this.viaAdministracion,
  });

  // Métodos de utilidad
  String get diasSemanaFormateados {
    if (dias.length == 7) return 'Todos los días';

    final diasNombres = {
      1: 'Lunes',
      2: 'Martes',
      3: 'Miércoles',
      4: 'Jueves',
      5: 'Viernes',
      6: 'Sábado',
      7: 'Domingo',
    };

    return dias.map((dia) => diasNombres[dia]!).join(', ');
  }

  String get horariosFormateados {
    return horarios.map((hora) => _formatTimeOfDay(hora)).join(', ');
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'a.m.' : 'p.m.';
    return '$hour:$minute $period';
  }

  // Verifica si hay que tomar medicación hoy
  bool get esHoy {
    final hoy = DateTime.now().weekday;
    return dias.contains(hoy);
  }

  // Próximo horario de hoy
  TimeOfDay? get proximoHorarioHoy {
    if (!esHoy) return null;

    final ahora = TimeOfDay.now();
    for (final horario in horarios) {
      if (_isTimeAfter(horario, ahora)) {
        return horario;
      }
    }
    return null;
  }

  bool _isTimeAfter(TimeOfDay time1, TimeOfDay time2) {
    if (time1.hour > time2.hour) return true;
    if (time1.hour == time2.hour && time1.minute > time2.minute) return true;
    return false;
  }

  // Crea una copia
  Medicacion copyWith({
    String? nombre,
    String? dosis,
    List<int>? dias,
    List<TimeOfDay>? horarios,
    bool? activa,
    DateTime? fechaInicio,
    String? instrucciones,
    String? viaAdministracion,
  }) {
    return Medicacion(
      nombre: nombre ?? this.nombre,
      dosis: dosis ?? this.dosis,
      dias: dias ?? this.dias,
      horarios: horarios ?? this.horarios,
      activa: activa ?? this.activa,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      instrucciones: instrucciones ?? this.instrucciones,
      viaAdministracion: viaAdministracion ?? this.viaAdministracion,
    );
  }

  @override
  String toString() {
    return 'Medicacion{nombre: $nombre, dosis: $dosis, dias: $dias, horarios: $horarios, activa: $activa}';
  }
}
