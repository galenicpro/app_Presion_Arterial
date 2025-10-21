// lib/data/models/lectura_ta.dart

import 'package:hive/hive.dart';

part 'lectura_ta.g.dart';

@HiveType(typeId: 0)
class LecturaTa extends HiveObject {
  @HiveField(0)
  final DateTime fecha;

  @HiveField(1)
  final int sistolica;

  @HiveField(2)
  final int diastolica;

  @HiveField(3)
  final int pulso;

  @HiveField(4)
  final String? sintomas; // Cambiado a nullable para consistencia con el formulario

  @HiveField(5)
  final String? notas; // Mantenemos notas como opcional

  @HiveField(6)
  final String tipoRegistro;

  LecturaTa({
    required this.fecha,
    required this.sistolica,
    required this.diastolica,
    required this.pulso,
    this.sintomas,
    this.notas,
    this.tipoRegistro = 'Manual',
  }) {
    // Validaciones en el constructor para seguridad
    _validateRanges();
  }

  // --- VALIDACIONES DE SEGURIDAD PARA ADULTOS MAYORES ---
  void _validateRanges() {
    if (sistolica < 70 || sistolica > 250) {
      throw ArgumentError(
        'Presión sistólica fuera de rango seguro: $sistolica',
      );
    }
    if (diastolica < 40 || diastolica > 150) {
      throw ArgumentError(
        'Presión diastólica fuera de rango seguro: $diastolica',
      );
    }
    if (pulso < 30 || pulso > 200) {
      throw ArgumentError('Pulso fuera de rango seguro: $pulso');
    }
    if (diastolica > sistolica) {
      throw ArgumentError(
        'La presión diastólica no puede ser mayor que la sistólica',
      );
    }
  }

  // --- MÉTODOS DE UTILIDAD ---

  /// Crea una copia del registro (útil para inmutabilidad)
  LecturaTa copyWith({
    DateTime? fecha,
    int? sistolica,
    int? diastolica,
    int? pulso,
    String? sintomas,
    String? notas,
    String? tipoRegistro,
  }) {
    return LecturaTa(
      fecha: fecha ?? this.fecha,
      sistolica: sistolica ?? this.sistolica,
      diastolica: diastolica ?? this.diastolica,
      pulso: pulso ?? this.pulso,
      sintomas: sintomas ?? this.sintomas,
      notas: notas ?? this.notas,
      tipoRegistro: tipoRegistro ?? this.tipoRegistro,
    );
  }

  /// Formatea la presión arterial como string (ej: "145/89 mmHg")
  String get presionFormateada => '$sistolica/$diastolica mmHg';

  /// Formatea la fecha y hora para mostrar
  String get fechaFormateada {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final fechaRegistro = DateTime(fecha.year, fecha.month, fecha.day);

    String fechaText;
    if (fechaRegistro == today) {
      fechaText = 'Hoy';
    } else if (fechaRegistro == yesterday) {
      fechaText = 'Ayer';
    } else {
      fechaText =
          '${fecha.day.toString().padLeft(2, '0')}/'
          '${fecha.month.toString().padLeft(2, '0')}/'
          '${fecha.year}';
    }

    final horaText =
        '${fecha.hour.toString().padLeft(2, '0')}:'
        '${fecha.minute.toString().padLeft(2, '0')}';

    return '$fechaText - $horaText';
  }

  /// Determina la categoría de la presión arterial según estándares médicos
  String get categoriaPresion {
    if (sistolica >= 180 || diastolica >= 120) {
      return 'Crisis Hipertensiva';
    } else if (sistolica >= 140 || diastolica >= 90) {
      return 'Hipertensión Grado 1';
    } else if (sistolica >= 130 || diastolica >= 85) {
      return 'Presión Elevada';
    } else if (sistolica >= 120 && diastolica < 80) {
      return 'Normal';
    } else {
      return 'Óptima';
    }
  }

  /// Obtiene el color correspondiente a la categoría (útil para la UI)
  String get colorCategoria {
    switch (categoriaPresion) {
      case 'Crisis Hipertensiva':
        return '#FF0000'; // Rojo
      case 'Hipertensión Grado 1':
        return '#FF9800'; // Naranja
      case 'Presión Elevada':
        return '#FFC107'; // Amarillo
      case 'Normal':
        return '#4CAF50'; // Verde
      case 'Óptima':
        return '#2E7D32'; // Verde oscuro
      default:
        return '#757575'; // Gris
    }
  }

  /// Verifica si la lectura indica una condición crítica
  bool get esCritica {
    return sistolica >= 180 || diastolica >= 120 || pulso >= 140 || pulso <= 40;
  }

  /// Calcula la presión arterial media (MAP)
  double get presionArterialMedia {
    return diastolica + (sistolica - diastolica) / 3;
  }

  // --- MÉTODOS DE COMPARACIÓN ---

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LecturaTa &&
        other.fecha == fecha &&
        other.sistolica == sistolica &&
        other.diastolica == diastolica &&
        other.pulso == pulso &&
        other.sintomas == sintomas &&
        other.notas == notas &&
        other.tipoRegistro == tipoRegistro;
  }

  @override
  int get hashCode {
    return Object.hash(
      fecha,
      sistolica,
      diastolica,
      pulso,
      sintomas,
      notas,
      tipoRegistro,
    );
  }

  @override
  String toString() {
    return 'LecturaTa{'
        'fecha: $fecha, '
        'sistolica: $sistolica, '
        'diastolica: $diastolica, '
        'pulso: $pulso, '
        'sintomas: $sintomas, '
        'notas: $notas, '
        'tipoRegistro: $tipoRegistro'
        '}';
  }

  // --- MÉTODOS DE SERIALIZACIÓN ADICIONALES ---

  /// Convierte el modelo a Map (útil para JSON u otras serializaciones)
  Map<String, dynamic> toMap() {
    return {
      'fecha': fecha.toIso8601String(),
      'sistolica': sistolica,
      'diastolica': diastolica,
      'pulso': pulso,
      'sintomas': sintomas,
      'notas': notas,
      'tipoRegistro': tipoRegistro,
      'key': key, // Incluye la clave de Hive si existe
    };
  }

  /// Crea una instancia desde Map
  factory LecturaTa.fromMap(Map<String, dynamic> map) {
    return LecturaTa(
      fecha: DateTime.parse(map['fecha']),
      sistolica: map['sistolica'] as int,
      diastolica: map['diastolica'] as int,
      pulso: map['pulso'] as int,
      sintomas: map['sintomas'] as String?,
      notas: map['notas'] as String?,
      tipoRegistro: map['tipoRegistro'] as String? ?? 'Manual',
    );
  }
}
