import 'package:hive/hive.dart';

// Generar el adaptador de Hive (código generado por build_runner)
// Ejecutar: flutter pub run build_runner build
part 'lectura_ta.g.dart'; // ¡El archivo generado!

// El número del tipo de Hive debe ser único en toda la aplicación.
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
  final String notas;

  @HiveField(5)
  final String tipoRegistro; // Ej: 'Manual', 'Dispositivo'

  @HiveField(6)
  final String? sintomas; // sintomas agregados (opcional)

  LecturaTa({
    required this.fecha,
    required this.sistolica,
    required this.diastolica,
    required this.pulso,
    this.notas = '',
    this.sintomas,
    this.tipoRegistro = 'Manual',
  });

  // Método de utilidad para crear una copia (útil para inmutabilidad)
  LecturaTa copyWith({
    DateTime? fecha,
    int? sistolica,
    int? diastolica,
    int? pulso,
    String? notas,
    String? sintomas,
    String? tipoRegistro,
  }) {
    return LecturaTa(
      fecha: fecha ?? this.fecha,
      sistolica: sistolica ?? this.sistolica,
      diastolica: diastolica ?? this.diastolica,
      pulso: pulso ?? this.pulso,
      notas: notas ?? this.notas,
      sintomas: sintomas ?? this.sintomas,
      tipoRegistro: tipoRegistro ?? this.tipoRegistro,
    );
  }
}
