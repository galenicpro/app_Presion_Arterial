// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/services/local_storage_service.dart';
import 'core/theme/app_theme.dart';
import 'features/home/home_screen.dart';

void main() async {
  // Asegura que los bindings de Flutter estén inicializados
  WidgetsFlutterBinding.ensureInitialized();

  // Configuración inicial para adultos mayores
  await _setupForElderlyUsers();

  runApp(const CardioCareApp());
}

class CardioCareApp extends StatelessWidget {
  const CardioCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CardioCare - Grupo Hogar Salud',
      debugShowCheckedModeBanner: false,
      // Tema accesible para adultos mayores
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,

      // Configuración local para fechas en español
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'), // Español como idioma principal
      ],
      locale: const Locale('es', 'ES'),

      // Características de accesibilidad
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // Texto sin escalado para evitar problemas de layout
            textScaleFactor: 1.0,
          ),
          child: child!,
        );
      },

      home: const HomeScreen(),
    );
  }
}

// --- Configuración inicial optimizada para adultos mayores ---

Future<void> _setupForElderlyUsers() async {
  // 1. Inicializar almacenamiento local
  await LocalStorageService().init();

  // 2. Configurar orientación (solo portrait para simplificar)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // 3. Configurar UI overlays (barra de estado y navegación)
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // 4. Prevenir capturas de pantalla si es necesario (para privacidad)
  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  // ]);
  // Para habilitar: await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
}

// --- Widget de carga inicial mejorado ---

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo de la aplicación
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.favorite,
                color: AppTheme.primaryColor,
                size: 60,
              ),
            ),
            const SizedBox(height: 32),
            // Texto de carga con fuente grande
            const Text(
              'CardioCare',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Grupo Hogar Salud',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 48),
            // Indicador de carga accesible
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3,
            ),
            const SizedBox(height: 20),
            const Text(
              'Cargando...',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
// Puedes personalizar aún más este SplashScreen
// para que se adapte a las necesidades de tus usuarios.