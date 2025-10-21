// lib/core/hive/hive_config.dart
import 'package:hive/hive.dart';
import '../utils/logger.dart'; // Importar tu logger existente

class HiveConfig {
  static Future<void> initialize() async {
    // La inicialización ahora se hace en LocalStorageService
    // Este archivo se mantiene para futuras expansiones
  }

  static Future<void> close() async {
    await Hive.close();
  }

  static Future<void> deleteBox(String boxName) async {
    try {
      await Hive.deleteBoxFromDisk(boxName);
      AppLogger.success('Box $boxName eliminada del disco', tag: 'HiveConfig');
    } catch (e) {
      AppLogger.error(
        'Error eliminando box $boxName',
        error: e,
        tag: 'HiveConfig',
      );
    }
  }

  static Future<void> deleteAllBoxes() async {
    try {
      await Hive.deleteFromDisk();
      AppLogger.success(
        'Todas las boxes eliminadas del disco',
        tag: 'HiveConfig',
      );
    } catch (e) {
      AppLogger.error(
        'Error eliminando todas las boxes',
        error: e,
        tag: 'HiveConfig',
      );
    }
  }
}
