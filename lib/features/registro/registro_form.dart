// lib/features/registro/registro_form.dart

import 'package:flutter/material.dart';
import '../../data/models/lectura_ta.dart';
import '../../data/repositories/lectura_repository.dart';

class RegistroForm {
  // Controladores de texto
  final TextEditingController sistolicaController = TextEditingController();
  final TextEditingController diastolicaController = TextEditingController();
  final TextEditingController pulsoController = TextEditingController();
  final TextEditingController sintomasController = TextEditingController();

  // Fecha y hora
  final ValueNotifier<DateTime> fecha = ValueNotifier<DateTime>(DateTime.now());
  final ValueNotifier<TimeOfDay> hora = ValueNotifier<TimeOfDay>(
    TimeOfDay.now(),
  );

  // Clasificación de presión
  final ValueNotifier<String> pressureClassification = ValueNotifier<String>(
    '',
  );

  final LecturaRepository _repository = LecturaRepository();

  // Validaciones
  String? validateSistolica(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese la presión sistólica';
    }

    final sistolica = int.tryParse(value);
    if (sistolica == null) {
      return 'Ingrese un número válido';
    }

    if (sistolica < 70 || sistolica > 250) {
      return 'Valor fuera de rango (70-250)';
    }

    return null;
  }

  String? validateDiastolica(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese la presión diastólica';
    }

    final diastolica = int.tryParse(value);
    if (diastolica == null) {
      return 'Ingrese un número válido';
    }

    if (diastolica < 40 || diastolica > 150) {
      return 'Valor fuera de rango (40-150)';
    }

    // Validación adicional: diastólica no puede ser mayor que sistólica
    final sistolica = int.tryParse(sistolicaController.text);
    if (sistolica != null && diastolica > sistolica) {
      return 'La diastólica no puede ser mayor que la sistólica';
    }

    return null;
  }

  String? validatePulso(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese el pulso';
    }

    final pulso = int.tryParse(value);
    if (pulso == null) {
      return 'Ingrese un número válido';
    }

    if (pulso < 30 || pulso > 200) {
      return 'Valor fuera de rango (30-200)';
    }

    return null;
  }

  // Actualizar clasificación de presión
  void updatePressureClassification(int sistolica, int diastolica) {
    pressureClassification.value = _clasificarPresion(sistolica, diastolica);
  }

  String _clasificarPresion(int sistolica, int diastolica) {
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

  // Formatear hora para mostrar
  String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'a. m.' : 'p. m.';
    return '$hour:$minute $period';
  }

  // Guardar registro
  Future<void> saveRegistro() async {
    // Combinar fecha y hora
    final fechaHora = DateTime(
      fecha.value.year,
      fecha.value.month,
      fecha.value.day,
      hora.value.hour,
      hora.value.minute,
    );

    // Crear modelo
    final lectura = LecturaTa(
      sistolica: int.parse(sistolicaController.text),
      diastolica: int.parse(diastolicaController.text),
      pulso: int.parse(pulsoController.text),
      fecha: fechaHora,
      sintomas: sintomasController.text.isNotEmpty
          ? sintomasController.text
          : null,
    );

    // Guardar en repositorio
    await _repository.saveLectura(lectura);
  }

  // Verificar si hay cambios sin guardar
  bool hasUnsavedChanges() {
    return sistolicaController.text.isNotEmpty ||
        diastolicaController.text.isNotEmpty ||
        pulsoController.text.isNotEmpty ||
        sintomasController.text.isNotEmpty;
  }

  // Limpiar recursos
  void dispose() {
    sistolicaController.dispose();
    diastolicaController.dispose();
    pulsoController.dispose();
    sintomasController.dispose();
    fecha.dispose();
    hora.dispose();
    pressureClassification.dispose();
  }

  // Cargar datos existentes (para edición futura)
  void loadLectura(LecturaTa lectura) {
    sistolicaController.text = lectura.sistolica.toString();
    diastolicaController.text = lectura.diastolica.toString();
    pulsoController.text = lectura.pulso.toString();
    fecha.value = lectura.fecha;
    hora.value = TimeOfDay.fromDateTime(lectura.fecha);
    sintomasController.text = lectura.sintomas ?? '';

    updatePressureClassification(lectura.sistolica, lectura.diastolica);
  }
}
