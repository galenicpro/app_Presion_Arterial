// lib/core/utils/logger.dart

import 'dart:developer' as developer;

class AppLogger {
  static void info(String message, {String? tag}) {
    developer.log('ℹ️ $message', name: tag ?? 'AppLogger');
  }

  static void debug(String message, {String? tag}) {
    developer.log('🐛 $message', name: tag ?? 'AppLogger');
  }

  static void warning(String message, {String? tag}) {
    developer.log('⚠️ $message', name: tag ?? 'AppLogger');
  }

  static void error(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    developer.log(
      '❌ $message\nError: $error\nStack: $stackTrace',
      name: tag ?? 'AppLogger',
      level: 1000, // Nivel de error
    );
  }

  static void success(String message, {String? tag}) {
    developer.log('✅ $message', name: tag ?? 'AppLogger');
  }
}
