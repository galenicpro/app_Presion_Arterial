// lib/core/utils/validators.dart

class Validators {
  // Validación para presión sistólica
  static String? validateSistolica(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese la presión sistólica';
    }

    final sistolica = int.tryParse(value);
    if (sistolica == null) {
      return 'Ingrese un número válido';
    }

    if (sistolica < 70) {
      return 'Valor muy bajo (mínimo 70)';
    }

    if (sistolica > 250) {
      return 'Valor muy alto (máximo 250)';
    }

    return null;
  }

  // Validación para presión diastólica
  static String? validateDiastolica(String? value, {int? sistolica}) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese la presión diastólica';
    }

    final diastolica = int.tryParse(value);
    if (diastolica == null) {
      return 'Ingrese un número válido';
    }

    if (diastolica < 40) {
      return 'Valor muy bajo (mínimo 40)';
    }

    if (diastolica > 150) {
      return 'Valor muy alto (máximo 150)';
    }

    // Validación de consistencia con sistólica
    if (sistolica != null && diastolica > sistolica) {
      return 'La diastólica no puede ser mayor que la sistólica';
    }

    return null;
  }

  // Validación para pulso cardíaco
  static String? validatePulso(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese el pulso';
    }

    final pulso = int.tryParse(value);
    if (pulso == null) {
      return 'Ingrese un número válido';
    }

    if (pulso < 30) {
      return 'Valor muy bajo (mínimo 30)';
    }

    if (pulso > 200) {
      return 'Valor muy alto (máximo 200)';
    }

    return null;
  }

  // Validación para síntomas (opcional pero con longitud máxima)
  static String? validateSintomas(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Opcional
    }

    if (value.length > 200) {
      return 'Máximo 200 caracteres';
    }

    return null;
  }

  // Validación para notas (opcional)
  static String? validateNotas(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Opcional
    }

    if (value.length > 500) {
      return 'Máximo 500 caracteres';
    }

    return null;
  }

  // Validación para nombre (en futuras versiones con perfil)
  static String? validateNombre(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese su nombre';
    }

    if (value.length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }

    if (value.length > 50) {
      return 'El nombre es demasiado largo';
    }

    // Solo letras y espacios
    if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$').hasMatch(value)) {
      return 'Solo se permiten letras y espacios';
    }

    return null;
  }

  // Validación para edad
  static String? validateEdad(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese su edad';
    }

    final edad = int.tryParse(value);
    if (edad == null) {
      return 'Ingrese un número válido';
    }

    if (edad < 18) {
      return 'Debe ser mayor de 18 años';
    }

    if (edad > 120) {
      return 'Ingrese una edad válida';
    }

    return null;
  }

  // Validación para teléfono de emergencia
  static String? validateTelefono(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese un número de teléfono';
    }

    // Remover espacios y caracteres especiales
    final cleanNumber = value.replaceAll(RegExp(r'[^\d+]'), '');

    if (cleanNumber.length < 8) {
      return 'Número de teléfono demasiado corto';
    }

    if (cleanNumber.length > 15) {
      return 'Número de teléfono demasiado largo';
    }

    return null;
  }

  // Validación para email (en futuras versiones)
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Opcional para adultos mayores
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.a-zA-Z0-9.!#$%&"*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Ingrese un email válido';
    }

    return null;
  }

  // Validación combinada para presión arterial
  static String? validatePresionCompleta({
    required String? sistolica,
    required String? diastolica,
  }) {
    final errorSistolica = validateSistolica(sistolica);
    if (errorSistolica != null) return errorSistolica;

    final sistolicaNum = int.tryParse(sistolica!);
    final errorDiastolica = validateDiastolica(
      diastolica,
      sistolica: sistolicaNum,
    );
    if (errorDiastolica != null) return errorDiastolica;

    return null;
  }

  // Clasificación de presión arterial (retorna categoría y color)
  static Map<String, dynamic> clasificarPresion(int sistolica, int diastolica) {
    String categoria;
    String color;

    if (sistolica >= 180 || diastolica >= 120) {
      categoria = 'Crisis Hipertensiva';
      color = '#FF0000';
    } else if (sistolica >= 140 || diastolica >= 90) {
      categoria = 'Hipertensión Grado 1';
      color = '#FF9800';
    } else if (sistolica >= 130 || diastolica >= 85) {
      categoria = 'Presión Elevada';
      color = '#FFC107';
    } else if (sistolica >= 120 && diastolica < 80) {
      categoria = 'Normal';
      color = '#4CAF50';
    } else {
      categoria = 'Óptima';
      color = '#2E7D32';
    }

    return {
      'categoria': categoria,
      'color': color,
      'esCritica': categoria == 'Crisis Hipertensiva',
    };
  }

  // Verifica si los valores indican una emergencia
  static bool esEmergencia(int sistolica, int diastolica, int pulso) {
    return sistolica >= 180 ||
        diastolica >= 120 ||
        pulso >= 140 ||
        pulso <= 40 ||
        (sistolica <= 90 && diastolica <= 60);
  }
}
