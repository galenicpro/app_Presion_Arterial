import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/models/lectura_ta.dart';

class LocalStorageService {
  // Constante para el nombre de la colección (Box en Hive)
  static const String _lecturasTaBox = 'lecturas_ta';

  // Singleton para asegurar una única instancia
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  // Función de inicialización
  Future<void> init() async {
    // Inicializar Hive en la ruta correcta
    try {
      // Solo inicializa con el directorio si no es Web.
      if (!kIsWeb) {
        final appDocumentDir = await getApplicationDocumentsDirectory();
        await Hive.initFlutter(appDocumentDir.path);
      } else {
        await Hive.initFlutter();
      }

      // Registrar el TypeAdapter generado por `build_runner`
      if (!Hive.isAdapterRegistered(0)) {
        // 0 es el typeId de LecturaTa
        Hive.registerAdapter(LecturaTaAdapter());
      }

      // Abrir la "caja" de datos
      await Hive.openBox<LecturaTa>(_lecturasTaBox);
      debugPrint(
        'LocalStorageService inicializado y Box "lecturas_ta" abierto.',
      );
    } catch (e) {
      debugPrint('Error al inicializar LocalStorageService: $e');
      // Manejo de errores de inicialización
    }
  }

  // Getter para acceder a la caja de lecturas
  Box<LecturaTa> get lecturasTaBox => Hive.box<LecturaTa>(_lecturasTaBox);

  // Puedes añadir aquí métodos genéricos de CRUD si la app creciera
  // Ejem: Future<void> saveItem<T>(T item);
}
// No olvides ejecutar `flutter pub run build_runner build`
// para generar el adaptador de LecturaTa antes de usar este servicio.