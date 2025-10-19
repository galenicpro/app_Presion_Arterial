// lib/data/repositories/lectura_repository.dart

import 'package:hive/hive.dart';
import '../../core/services/local_storage_service.dart';
import '../models/lectura_ta.dart';

class LecturaRepository {
  final Box<LecturaTa> _lecturasBox = LocalStorageService().lecturasTaBox;

  // --- MÉTODOS CRUD MEJORADOS ---

  /// Guarda un nuevo registro con validación para adultos mayores
  Future<void> saveLectura(LecturaTa lectura) async {
    // Validación de rangos razonables para adultos mayores
    _validateLecturaRanges(lectura);

    await _lecturasBox.add(lectura);
  }

  /// Obtiene todos los registros ordenados (más reciente primero)
  List<LecturaTa> getAllLecturas() {
    final allLecturas = _lecturasBox.values.toList();
    allLecturas.sort((a, b) => b.fecha.compareTo(a.fecha));
    return allLecturas;
  }

  /// Obtiene registros de un rango de fechas específico
  List<LecturaTa> getLecturasByDateRange(DateTime start, DateTime end) {
    return getAllLecturas().where((lectura) {
      return lectura.fecha.isAfter(start.subtract(const Duration(days: 1))) &&
          lectura.fecha.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  /// Elimina un registro específico
  Future<void> deleteLectura(LecturaTa lectura) async {
    await lectura.delete();
  }

  /// Obtiene estadísticas para reportes (como el PDF que muestras)
  Map<String, dynamic> getEstadisticas() {
    final lecturas = getAllLecturas();
    if (lecturas.isEmpty) {
      return {
        'totalRegistros': 0,
        'promedioSistolica': 0.0,
        'promedioDiastolica': 0.0,
        'promedioPulso': 0.0,
        'maximaSistolica': 0,
        'minimaSistolica': 0,
        'maximaDiastolica': 0,
        'minimaDiastolica': 0,
      };
    }

    final sistolicas = lecturas.map((l) => l.sistolica).toList();
    final diastolicas = lecturas.map((l) => l.diastolica).toList();
    final pulsos = lecturas.map((l) => l.pulso).toList();

    return {
      'totalRegistros': lecturas.length,
      'promedioSistolica': _calcularPromedio(sistolicas),
      'promedioDiastolica': _calcularPromedio(diastolicas),
      'promedioPulso': _calcularPromedio(pulsos),
      'maximaSistolica': sistolicas.reduce((a, b) => a > b ? a : b),
      'minimaSistolica': sistolicas.reduce((a, b) => a < b ? a : b),
      'maximaDiastolica': diastolicas.reduce((a, b) => a > b ? a : b),
      'minimaDiastolica': diastolicas.reduce((a, b) => a < b ? a : b),
    };
  }

  /// Clasifica el estado de la presión arterial (Alta E1, Normal, etc.)
  String clasificarPresion(int sistolica, int diastolica) {
    if (sistolica >= 180 || diastolica >= 120) return 'Crisis Hipertensiva';
    if (sistolica >= 140 || diastolica >= 90) return 'Alta E1';
    if (sistolica >= 130 || diastolica >= 85) return 'Normal Alta';
    if (sistolica >= 120 && diastolica < 80) return 'Normal';
    return 'Óptima';
  }

  // --- MÉTODOS PRIVADOS ---

  double _calcularPromedio(List<int> valores) {
    return valores.reduce((a, b) => a + b) / valores.length;
  }

  void _validateLecturaRanges(LecturaTa lectura) {
    // Rangos de seguridad para adultos mayores
    if (lectura.sistolica < 70 || lectura.sistolica > 250) {
      throw ArgumentError('Valor sistólico fuera de rango seguro');
    }
    if (lectura.diastolica < 40 || lectura.diastolica > 150) {
      throw ArgumentError('Valor diastólico fuera de rango seguro');
    }
    if (lectura.pulso < 30 || lectura.pulso > 200) {
      throw ArgumentError('Valor de pulso fuera de rango seguro');
    }
  }

  /// Stream reactivo para la UI
  Stream<BoxEvent> get lecturasStream => _lecturasBox.watch();
}
