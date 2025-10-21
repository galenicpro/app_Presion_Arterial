// lib/data/repositories/lectura_repository.dart

import 'package:hive/hive.dart';
import '../../core/services/local_storage_service.dart';
import '../models/lectura_ta.dart';

class LecturaRepository {
  final Box<LecturaTa> _lecturasBox = LocalStorageService().lecturasTaBox;

  // --- MÉTODOS CRUD ---

  /// Guarda un nuevo registro de tensión arterial.
  Future<void> saveLectura(LecturaTa lectura) async {
    await _lecturasBox.add(lectura);
  }

  /// Obtiene todos los registros, ordenados por fecha descendente.
  List<LecturaTa> getAllLecturas() {
    final allLecturas = _lecturasBox.values.toList();
    allLecturas.sort((a, b) => b.fecha.compareTo(a.fecha));
    return allLecturas;
  }

  /// Elimina un registro específico.
  Future<void> deleteLectura(LecturaTa lectura) async {
    await lectura.delete();
  }

  /// Obtiene estadísticas para reportes
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

  // --- GETTER PARA HIVE ---

  /// Getter para acceder a la Box de Hive (necesario para ValueListenableBuilder)
  Box<LecturaTa> get lecturasTaBox => _lecturasBox;

  // --- MÉTODOS PRIVADOS ---

  double _calcularPromedio(List<int> valores) {
    return valores.reduce((a, b) => a + b) / valores.length;
  }

  /// Escucha los cambios en los datos de la caja (útil para la reactividad de la UI)
  Stream<BoxEvent> get lecturasStream => _lecturasBox.watch();
}
