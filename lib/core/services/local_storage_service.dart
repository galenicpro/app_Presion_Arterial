// lib/core/services/local_storage_service.dart

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import '../../data/models/lectura_ta.dart';
import '../../data/models/medicacion.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  late Box<LecturaTa> _lecturasBox;
  late Box<Medicacion> _medicacionesBox;
  late Box<dynamic> _configBox;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Box<LecturaTa> get lecturasTaBox => _lecturasBox;
  Box<Medicacion> get medicacionesBox => _medicacionesBox;
  Box<dynamic> get configBox => _configBox;

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      final appDocumentDir = await path_provider
          .getApplicationDocumentsDirectory();
      Hive.init(appDocumentDir.path);

      // Registrar adaptadores
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(LecturaTaAdapter());
      }
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(MedicacionAdapter());
      }

      _lecturasBox = await Hive.openBox<LecturaTa>('lecturas_ta');
      _medicacionesBox = await Hive.openBox<Medicacion>('medicaciones');
      _configBox = await Hive.openBox('app_config');

      _isInitialized = true;
      debugPrint('✅ LocalStorageService inicializado');
    } catch (e) {
      debugPrint('❌ Error inicializando LocalStorageService: $e');
      rethrow;
    }
  }

  // --- MÉTODOS PARA MEDICACIONES ---

  /// Guarda una nueva medicación
  Future<void> guardarMedicacion(Medicacion medicacion) async {
    _checkInitialization();
    try {
      await _medicacionesBox.add(medicacion);
      debugPrint('💊 Medicación guardada: ${medicacion.nombre}');
    } catch (e) {
      debugPrint('❌ Error guardando medicación: $e');
      rethrow;
    }
  }

  /// Obtiene todas las medicaciones
  List<Medicacion> getTodasMedicaciones() {
    _checkInitialization();
    return _medicacionesBox.values.toList();
  }

  /// Obtiene todas las medicaciones activas
  List<Medicacion> getMedicacionesActivas() {
    _checkInitialization();
    return _medicacionesBox.values.where((med) => med.activa).toList()
      ..sort((a, b) => a.nombre.compareTo(b.nombre));
  }

  /// Obtiene medicaciones pendientes para hoy
  List<Medicacion> getMedicacionesPendientesHoy() {
    _checkInitialization();
    // CORREGIDO: Removida la variable 'ahora' no utilizada
    return getMedicacionesActivas().where((med) {
      if (!med.esHoy) return false;
      final proximoHorario = med.proximoHorarioHoy;
      return proximoHorario != null;
    }).toList();
  }

  /// Elimina una medicación
  Future<void> eliminarMedicacion(Medicacion medicacion) async {
    _checkInitialization();
    try {
      await medicacion.delete();
      debugPrint('🗑️ Medicación eliminada: ${medicacion.nombre}');
    } catch (e) {
      debugPrint('❌ Error eliminando medicación: $e');
      rethrow;
    }
  }

  /// Actualiza una medicación existente
  Future<void> actualizarMedicacion(Medicacion medicacion) async {
    _checkInitialization();
    try {
      await medicacion.save();
      debugPrint('✏️ Medicación actualizada: ${medicacion.nombre}');
    } catch (e) {
      debugPrint('❌ Error actualizando medicación: $e');
      rethrow;
    }
  }

  // --- MÉTODOS PARA LECTURAS (existente) ---
  Future<void> guardarLectura(LecturaTa lectura) async {
    _checkInitialization();
    await _lecturasBox.add(lectura);
    debugPrint('💾 Lectura guardada: ${lectura.presionFormateada}');
  }

  List<LecturaTa> getTodasLecturas() {
    _checkInitialization();
    final lecturas = _lecturasBox.values.toList();
    lecturas.sort((a, b) => b.fecha.compareTo(a.fecha));
    return lecturas;
  }

  Future<void> eliminarLectura(LecturaTa lectura) async {
    _checkInitialization();
    await lectura.delete();
    debugPrint('🗑️ Lectura eliminada');
  }

  // --- MÉTODOS PARA CONFIGURACIÓN ---
  Future<void> setConfig(String key, dynamic value) async {
    _checkInitialization();
    await _configBox.put(key, value);
  }

  dynamic getConfig(String key, {dynamic defaultValue}) {
    _checkInitialization();
    return _configBox.get(key, defaultValue: defaultValue);
  }

  // --- VERIFICACIONES ---
  void _checkInitialization() {
    if (!_isInitialized) {
      throw Exception(
        'LocalStorageService no inicializado. Llama a init() primero.',
      );
    }
  }

  Future<void> close() async {
    if (!_isInitialized) return;
    await _lecturasBox.close();
    await _medicacionesBox.close();
    await _configBox.close();
    _isInitialized = false;
    debugPrint('🔒 LocalStorageService cerrado');
  }
}
