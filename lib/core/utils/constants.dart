// lib/core/utils/constants.dart

import 'package:flutter/material.dart';

class AppConstants {
  // Versión de la aplicación
  static const String appVersion = '1.0.0';
  static const String appName = 'CardioCare';
  static const String appDescription =
      'Registro de presión arterial para adultos mayores';

  // Colores de la aplicación
  static const int primaryColorValue = 0xFF2196F3;
  static const int secondaryColorValue = 0xFF4CAF50;
  static const int dangerColorValue = 0xFFF44336;
  static const int warningColorValue = 0xFFFF9800;
  static const int successColorValue = 0xFF4CAF50;

  // Tamaños de fuente para accesibilidad
  static const double fontSizeSmall = 14.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeLarge = 18.0;
  static const double fontSizeExtraLarge = 20.0;
  static const double fontSizeTitle = 24.0;

  // Tamaños de botones para adultos mayores
  static const double buttonHeightSmall = 44.0;
  static const double buttonHeightMedium = 54.0;
  static const double buttonHeightLarge = 60.0;
  static const double buttonMinWidth = 200.0;

  // Espaciado consistente
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;

  // Bordes redondeados
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;

  // Tiempos y duraciones
  static const int snackBarDuration = 4000; // milisegundos
  static const int animationDuration = 300; // milisegundos
  static const int debounceTime = 500; // milisegundos para búsquedas

  // Límites de la aplicación
  static const int maxSistolica = 250;
  static const int minSistolica = 70;
  static const int maxDiastolica = 150;
  static const int minDiastolica = 40;
  static const int maxPulso = 200;
  static const int minPulso = 30;
  static const int maxSintomasLength = 200;
  static const int maxNotasLength = 500;

  // Categorías de presión arterial
  static const Map<String, String> categoriasPresion = {
    'OPTIMA': 'Óptima',
    'NORMAL': 'Normal',
    'ELEVADA': 'Presión Elevada',
    'HIPERTENSION_1': 'Hipertensión Grado 1',
    'HIPERTENSION_2': 'Hipertensión Grado 2',
    'CRISIS': 'Crisis Hipertensiva',
  };

  // Síntomas comunes predefinidos (para selección rápida)
  static const List<String> sintomasComunes = [
    'Dolor de cabeza',
    'Mareo',
    'Palpitaciones',
    'Visión borrosa',
    'Dolor en el pecho',
    'Dificultad para respirar',
    'Náuseas',
    'Fatiga',
    'Hemorragia nasal',
    'Ansiedad',
    'Zumbido en oídos',
    'Hinchazón en piernas',
  ];

  // Horarios sugeridos para toma de presión
  static const List<String> horariosSugeridos = [
    'Por la mañana (6:00 - 8:00)',
    'Mediodía (12:00 - 14:00)',
    'Tarde (16:00 - 18:00)',
    'Noche (20:00 - 22:00)',
    'Antes de medicamentos',
    'Después de medicamentos',
  ];

  // Mensajes educativos para adultos mayores
  static const List<String> mensajesEducativos = [
    'Tome su presión a la misma hora cada día',
    'Descanse 5 minutos antes de medir',
    'Mantenga el brazo a la altura del corazón',
    'No hable ni se mueva durante la medición',
    'Evite café, tabaco y ejercicio 30 min antes',
    'Use el mismo brazo para todas las mediciones',
    'Siéntese con la espalda recta y pies apoyados',
    'Registre siempre que sienta síntomas inusuales',
  ];

  // Nuevas constantes para medicación
  static const List<String> viasAdministracion = [
    'Oral',
    'Sublingual',
    'Tópica',
    'Inhalada',
    'Inyectable',
    'Oftálmica',
    'Ótica',
    'Nasal',
  ];

  static const List<String> diasSemana = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];

  // Horarios comunes como Map (en lugar de TimeOfDay para constantes)
  static const List<Map<String, int>> horariosComunes = [
    {'hour': 8, 'minute': 0},
    {'hour': 12, 'minute': 0},
    {'hour': 18, 'minute': 0},
    {'hour': 20, 'minute': 0},
  ];

  // Método para crear TimeOfDay desde constantes
  static TimeOfDay createTimeOfDay(int hour, int minute) {
    return TimeOfDay(hour: hour, minute: minute);
  }

  // Configuración de Hive
  static const String lecturasBoxName = 'lecturas_ta';
  static const String medicacionesBoxName = 'medicaciones';
  static const String configBoxName = 'app_config';
  static const int lecturasTypeId = 0;
  static const int medicacionesTypeId = 1;

  // Rutas de la aplicación
  static const String routeHome = '/';
  static const String routeRegistro = '/registro';
  static const String routeHistorial = '/historial';
  static const String routeConfiguracion = '/configuracion';
  static const String routeMedicaciones = '/medicaciones';

  // Números de emergencia (configurables)
  static const String numeroEmergenciaDefault = '911';
  static const String contactoEmergenciaDefault = '';

  // Configuración de notificaciones
  static const String recordatorioTomaKey = 'recordatorio_toma';
  static const String recordatorioMedicamentoKey = 'recordatorio_medicamento';

  // Textos para la UI
  static const String emptyStateTitle = 'Bienvenido a CardioCare';
  static const String emptyStateSubtitle =
      'Comienza a registrar tu presión arterial';
  static const String emptyStateInstruction =
      'Presiona el botón "+" para agregar tu primer registro';

  // Errores comunes
  static const String errorGuardarRegistro = 'Error al guardar el registro';
  static const String errorCargarRegistros = 'Error al cargar los registros';
  static const String errorEliminarRegistro = 'Error al eliminar el registro';
  static const String errorGenerarPDF = 'Error al generar el PDF';

  // Éxitos comunes
  static const String successRegistroGuardado =
      'Registro guardado exitosamente';
  static const String successRegistroEliminado =
      'Registro eliminado exitosamente';
  static const String successPDFGenerado = 'PDF generado exitosamente';
}

// Constantes específicas para el tema
class ThemeConstants {
  static const double appBarElevation = 2.0;
  static const double cardElevation = 2.0;
  static const double buttonElevation = 4.0;

  static const double iconSizeSmall = 20.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 28.0;

  static const double paddingScreen = 20.0;
  static const double paddingCard = 16.0;
}

// Constantes para accesibilidad
class AccessibilityConstants {
  static const double minTouchSize = 44.0;
  static const double recommendedTouchSize = 48.0;
  static const double textScaleFactor = 1.0;
}
