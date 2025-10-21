// lib/core/utils/date_utils.dart

import 'package:flutter/material.dart';

class DateUtils {
  // Formatea una fecha a string legible para adultos mayores
  static String formatDate(DateTime date, {bool includeTime = true}) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(date.year, date.month, date.day);

    String dateText;
    if (dateToCheck == today) {
      dateText = 'Hoy';
    } else if (dateToCheck == yesterday) {
      dateText = 'Ayer';
    } else {
      dateText =
          '${_getDayName(date.weekday)}, '
          '${date.day} de ${_getMonthName(date.month)} '
          'de ${date.year}';
    }

    if (!includeTime) return dateText;

    final timeText = _formatTime(date);
    return '$dateText - $timeText';
  }

  // Formatea solo la hora
  static String formatTime(DateTime date) {
    return _formatTime(date);
  }

  // Formatea la hora en formato 12h (más familiar para adultos mayores)
  static String _formatTime(DateTime date) {
    final hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');

    if (hour == 0) {
      return '12:$minute a. m.';
    } else if (hour == 12) {
      return '12:$minute p. m.';
    } else if (hour < 12) {
      return '$hour:$minute a. m.';
    } else {
      return '${hour - 12}:$minute p. m.';
    }
  }

  // Obtiene el nombre del día en español
  static String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Lunes';
      case 2:
        return 'Martes';
      case 3:
        return 'Miércoles';
      case 4:
        return 'Jueves';
      case 5:
        return 'Viernes';
      case 6:
        return 'Sábado';
      case 7:
        return 'Domingo';
      default:
        return '';
    }
  }

  // Obtiene el nombre del mes en español
  static String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'enero';
      case 2:
        return 'febrero';
      case 3:
        return 'marzo';
      case 4:
        return 'abril';
      case 5:
        return 'mayo';
      case 6:
        return 'junio';
      case 7:
        return 'julio';
      case 8:
        return 'agosto';
      case 9:
        return 'septiembre';
      case 10:
        return 'octubre';
      case 11:
        return 'noviembre';
      case 12:
        return 'diciembre';
      default:
        return '';
    }
  }

  // Calcula la edad a partir de la fecha de nacimiento
  static int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  // Verifica si una fecha es hoy
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // Verifica si una fecha es esta semana
  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        date.isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  // Obtiene el primer día del mes
  static DateTime firstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  // Obtiene el último día del mes
  static DateTime lastDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }

  // Formatea fecha para nombres de archivo (PDF, etc.)
  static String formatDateForFile(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}'
        '${date.month.toString().padLeft(2, '0')}'
        '${date.year}';
  }

  // Convierte TimeOfDay a DateTime (combinando con fecha actual)
  static DateTime timeOfDayToDateTime(TimeOfDay time) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }

  // Diferencia en días entre dos fechas
  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }
}
