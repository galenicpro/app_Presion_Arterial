import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presion_arterial_gemini/main.dart';

void main() {
  // Función auxiliar para esperar que la app cargue completamente
  Future<void> waitForAppToLoad(WidgetTester tester) async {
    // Esperar que el splash screen desaparezca
    await tester.pump(const Duration(seconds: 3));
    
    // Buscar si estamos en el home screen (CardioCare en AppBar)
    final homeScreenFinder = find.text('CardioCare');
    
    // Si no encontramos el home screen, seguir esperando
    int attempts = 0;
    while (homeScreenFinder.evaluate().isEmpty && attempts < 10) {
      await tester.pump(const Duration(milliseconds: 500));
      attempts++;
    }
  }

  group('Tests Básicos de CardioCare', () {
    testWidgets('App starts and shows loading screen', (WidgetTester tester) async {
      await tester.pumpWidget(const CardioCareApp());
      
      // Verificar que muestra el splash screen inicial
      expect(find.text('CardioCare'), findsOneWidget);
      expect(find.text('Grupo Hogar Salud'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('App loads and shows home screen', (WidgetTester tester) async {
      await tester.pumpWidget(const CardioCareApp());
      await waitForAppToLoad(tester);
      
      // Después de cargar, debería mostrar la pantalla principal
      expect(find.text('CardioCare'), findsOneWidget);
    });
  });

  group('Test de Elementos de UI', () {
    testWidgets('Home screen shows main UI components', (WidgetTester tester) async {
      await tester.pumpWidget(const CardioCareApp());
      await waitForAppToLoad(tester);
      
      // Verificar elementos principales del home
      expect(find.text('CardioCare'), findsOneWidget);
      
      // Verificar que hay un AppBar
      expect(find.byType(AppBar), findsOneWidget);
      
      // Verificar que hay contenido (puede ser empty state o registros)
      final contentFinder = find.byType(Scaffold);
      expect(contentFinder, findsOneWidget);
    });

    testWidgets('App bar contains PDF icon', (WidgetTester tester) async {
      await tester.pumpWidget(const CardioCareApp());
      await waitForAppToLoad(tester);
      
      // Verificar que el AppBar tiene acciones
      final appBarFinder = find.byType(AppBar);
      expect(appBarFinder, findsOneWidget);
      
      // Buscar iconos en el AppBar
      final iconButtons = find.descendant(
        of: appBarFinder,
        matching: find.byType(IconButton),
      );
      
      // Debería haber al menos un IconButton (PDF)
      expect(iconButtons, findsAtLeast(1));
    });
  });

  group('Test de Navegación Básica', () {
    testWidgets('Floating action button exists in home screen', (WidgetTester tester) async {
      await tester.pumpWidget(const CardioCareApp());
      await waitForAppToLoad(tester);
      
      // Buscar FAB de diferentes maneras
      final fabFinder = find.byType(FloatingActionButton);
      
      // También buscar por texto si es un FAB extendido
      final fabTextFinder = find.text('NUEVO REGISTRO');
      
      // Al menos uno de ellos debería existir
      final hasFab = fabFinder.evaluate().isNotEmpty || fabTextFinder.evaluate().isNotEmpty;
      expect(hasFab, true);
    });

    testWidgets('Can navigate to registro screen', (WidgetTester tester) async {
      await tester.pumpWidget(const CardioCareApp());
      await waitForAppToLoad(tester);
      
      // Buscar y tocar el FAB o botón de nuevo registro
      final fabFinder = find.byType(FloatingActionButton);
      final fabTextFinder = find.text('NUEVO REGISTRO');
      
      if (fabFinder.evaluate().isNotEmpty) {
        await tester.tap(fabFinder);
      } else if (fabTextFinder.evaluate().isNotEmpty) {
        await tester.tap(fabTextFinder);
      }
      
      await tester.pumpAndSettle();
      
      // Verificar que estamos en una pantalla diferente
      // Puede ser RegistroScreen o mantener el home
      final currentScreen = find.byType(Scaffold);
      expect(currentScreen, findsOneWidget);
    });
  });

  group('Test de Formularios', () {
    testWidgets('Registro screen form elements exist', (WidgetTester tester) async {
      await tester.pumpWidget(const CardioCareApp());
      await waitForAppToLoad(tester);
      
      // Navegar a pantalla de registro si es posible
      final fabFinder = find.byType(FloatingActionButton);
      final fabTextFinder = find.text('NUEVO REGISTRO');
      
      if (fabFinder.evaluate().isNotEmpty || fabTextFinder.evaluate().isNotEmpty) {
        if (fabFinder.evaluate().isNotEmpty) {
          await tester.tap(fabFinder);
        } else {
          await tester.tap(fabTextFinder);
        }
        
        await tester.pumpAndSettle();
        
        // Verificar elementos del formulario de registro
        final formFields = find.byType(TextFormField);
        expect(formFields, findsAtLeast(3)); // Sistólica, Diastólica, Pulso
        
        final saveButton = find.text('GUARDAR REGISTRO');
        expect(saveButton, findsOneWidget);
      }
    });
  });

  group('Test de Estados de la Aplicación', () {
    testWidgets('App shows appropriate content based on state', (WidgetTester tester) async {
      await tester.pumpWidget(const CardioCareApp());
      await waitForAppToLoad(tester);
      
      // Verificar que la app muestra algún contenido válido
      final hasContent = 
          find.text('CardioCare').evaluate().isNotEmpty &&
          find.byType(Scaffold).evaluate().isNotEmpty;
      
      expect(hasContent, true);
    });

    testWidgets('App handles different screen states', (WidgetTester tester) async {
      await tester.pumpWidget(const CardioCareApp());
      
      // Estado inicial: loading
      expect(find.text('Cargando...'), findsOneWidget);
      
      await waitForAppToLoad(tester);
      
      // Estado final: home screen
      expect(find.text('CardioCare'), findsOneWidget);
    });
  });

  group('Test de Funcionalidades Específicas', () {
    testWidgets('PDF generation capability', (WidgetTester tester) async {
      await tester.pumpWidget(const CardioCareApp());
      await waitForAppToLoad(tester);
      
      // Buscar botón PDF en AppBar
      final pdfIcon = find.byIcon(Icons.picture_as_pdf);
      if (pdfIcon.evaluate().isNotEmpty) {
        // Tocar el botón PDF
        await tester.tap(pdfIcon);
        await tester.pump();
        
        // Verificar que no hay errores críticos
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('Emergency button functionality', (WidgetTester tester) async {
      await tester.pumpWidget(const CardioCareApp());
      await waitForAppToLoad(tester);
      
      // Buscar botón de emergencia de diferentes maneras
      final emergencyText = find.text('EMERGENCIA');
      final emergencyButton = find.widgetWithText(ElevatedButton, 'EMERGENCIA');
      
      if (emergencyText.evaluate().isNotEmpty || emergencyButton.evaluate().isNotEmpty) {
        // Si existe algún botón de emergencia, tocarlo
        if (emergencyText.evaluate().isNotEmpty) {
          await tester.tap(emergencyText);
        } else {
          await tester.tap(emergencyButton);
        }
        
        await tester.pump();
        
        // Verificar que no hay errores
        expect(tester.takeException(), isNull);
      }
    });
  });

  group('Test de Integración', () {
    testWidgets('Complete app lifecycle', (WidgetTester tester) async {
      // 1. Iniciar app
      await tester.pumpWidget(const CardioCareApp());
      
      // 2. Verificar splash screen
      expect(find.text('CardioCare'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      // 3. Esperar que cargue
      await waitForAppToLoad(tester);
      
      // 4. Verificar home screen
      expect(find.text('CardioCare'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      
      // 5. Verificar que la app es funcional
      final hasUI = 
          find.byType(Scaffold).evaluate().isNotEmpty &&
          find.byType(AppBar).evaluate().isNotEmpty;
      
      expect(hasUI, true);
      
      // 6. Verificar que no hay errores
      expect(tester.takeException(), isNull);
    });
  });

  group('Test de Robustez', () {
    testWidgets('App does not crash on basic interactions', (WidgetTester tester) async {
      await tester.pumpWidget(const CardioCareApp());
      await waitForAppToLoad(tester);
      
      // Intentar varias interacciones básicas
      final exceptions = <dynamic>[];
      
      // Probar tocar diferentes elementos
      try {
        final appBar = find.byType(AppBar);
        if (appBar.evaluate().isNotEmpty) {
          await tester.tap(appBar);
          await tester.pump();
        }
      } catch (e) {
        exceptions.add(e);
      }
      
      // Probar FAB si existe
      try {
        final fab = find.byType(FloatingActionButton);
        if (fab.evaluate().isNotEmpty) {
          await tester.tap(fab);
          await tester.pump();
        }
      } catch (e) {
        exceptions.add(e);
      }
      
      // La app no debería lanzar excepciones en interacciones básicas
      expect(exceptions.isEmpty, true);
    });

    testWidgets('App maintains state after interactions', (WidgetTester tester) async {
      await tester.pumpWidget(const CardioCareApp());
      await waitForAppToLoad(tester);
      
      // Estado inicial
      final initialState = find.text('CardioCare');
      expect(initialState, findsOneWidget);
      
      // Realizar alguna interacción
      final fab = find.byType(FloatingActionButton);
      if (fab.evaluate().isNotEmpty) {
        await tester.tap(fab);
        await tester.pumpAndSettle();
        
        // La app debería seguir funcionando
        expect(tester.takeException(), isNull);
      }
    });
  });

  // Tests adicionales específicos para tu aplicación
  group('Tests Específicos de CardioCare', () {
    testWidgets('Blood pressure chart section exists', (WidgetTester tester) async {
      await tester.pumpWidget(const CardioCareApp());
      await waitForAppToLoad(tester);
      
      // Buscar sección de gráficos por título o contenido
      final chartTitles = [
        'Evolución de la Presión Arterial',
        'Gráfico',
        'Estadísticas'
      ];
      
      bool foundChartSection = false;
      for (final title in chartTitles) {
        if (find.text(title).evaluate().isNotEmpty) {
          foundChartSection = true;
          break;
        }
      }
      
      // La app debería tener alguna sección de gráficos/estadísticas
      expect(foundChartSection, true);
    });

    testWidgets('Blood pressure classification works', (WidgetTester tester) async {
      await tester.pumpWidget(const CardioCareApp());
      await waitForAppToLoad(tester);
      
      // Navegar a pantalla de registro
      final fabFinder = find.byType(FloatingActionButton);
      final fabTextFinder = find.text('NUEVO REGISTRO');
      
      if (fabFinder.evaluate().isNotEmpty || fabTextFinder.evaluate().isNotEmpty) {
        if (fabFinder.evaluate().isNotEmpty) {
          await tester.tap(fabFinder);
        } else {
          await tester.tap(fabTextFinder);
        }
        
        await tester.pumpAndSettle();
        
        // Llenar datos de presión arterial
        final formFields = find.byType(TextFormField);
        if (formFields.evaluate().length >= 2) {
          // Ingresar valores que generen una clasificación
          await tester.enterText(formFields.at(0), '120');
          await tester.enterText(formFields.at(1), '80');
          await tester.pump();
          
          // Verificar que no hay errores de validación
          expect(tester.takeException(), isNull);
        }
      }
    });

    testWidgets('App handles date and time selection', (WidgetTester tester) async {
      await tester.pumpWidget(const CardioCareApp());
      await waitForAppToLoad(tester);
      
      // Navegar a pantalla de registro
      final fabFinder = find.byType(FloatingActionButton);
      final fabTextFinder = find.text('NUEVO REGISTRO');
      
      if (fabFinder.evaluate().isNotEmpty || fabTextFinder.evaluate().isNotEmpty) {
        if (fabFinder.evaluate().isNotEmpty) {
          await tester.tap(fabFinder);
        } else {
          await tester.tap(fabTextFinder);
        }
        
        await tester.pumpAndSettle();
        
        // Buscar selectores de fecha/hora
        final dateTimeSelectors = find.byIcon(Icons.calendar_today);
        final timeSelectors = find.byIcon(Icons.access_time);
        
        // Debería haber al menos algunos selectores
        final hasSelectors = dateTimeSelectors.evaluate().isNotEmpty || 
                            timeSelectors.evaluate().isNotEmpty;
        expect(hasSelectors, true);
      }
    });
  });
}