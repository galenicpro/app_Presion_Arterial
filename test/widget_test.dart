// test/widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presion_arterial_gemini/main.dart';

void main() {
  group('Tests Básicos de CardioCare', () {
    testWidgets('App starts and shows CardioCare title', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const CardioCareApp());
      expect(find.text('CardioCare'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('Empty state shows welcome message when no records', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const CardioCareApp());
      expect(find.text('Bienvenido a CardioCare'), findsOneWidget);
      expect(
        find.text('Comienza a registrar tu presión arterial'),
        findsOneWidget,
      );
    });
  });

  group('Test para Navegar entre Pantallas', () {
    testWidgets('Navigate to RegistroScreen from FAB', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const CardioCareApp());

      // Tap en el FAB para navegar a RegistroScreen
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Verificar que estamos en RegistroScreen
      expect(find.text('Nuevo Registro'), findsOneWidget);
      expect(find.text('Registro de Presión Arterial'), findsOneWidget);
    });

    testWidgets('Navigate back from RegistroScreen', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const CardioCareApp());

      // Ir a RegistroScreen
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Volver con el botón de back
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Verificar que estamos de vuelta en HomeScreen
      expect(find.text('CardioCare'), findsOneWidget);
    });
  });

  group('Test para Agregar Registro de Presión Arterial', () {
    testWidgets('Add blood pressure record with valid data', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const CardioCareApp());

      // Navegar a RegistroScreen
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Llenar el formulario
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Sistólica (SYS)'),
        '120',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Diastólica (DIA)'),
        '80',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Pulso (PUL)'),
        '70',
      );

      // Guardar el registro
      await tester.tap(find.text('GUARDAR REGISTRO'));
      await tester.pumpAndSettle();

      // Verificar que volvimos a HomeScreen y el registro se muestra
      expect(find.text('CardioCare'), findsOneWidget);
      expect(find.text('120/80 mmHg'), findsOneWidget);
      expect(find.text('70 bpm'), findsOneWidget);
    });

    testWidgets('Add record with symptoms', (WidgetTester tester) async {
      await tester.pumpWidget(const CardioCareApp());

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Llenar datos básicos
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Sistólica (SYS)'),
        '130',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Diastólica (DIA)'),
        '85',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Pulso (PUL)'),
        '75',
      );

      // Agregar síntomas
      await tester.enterText(
        find.widgetWithText(
          TextFormField,
          'Describa cualquier síntoma que esté experimentando...',
        ),
        'Dolor de cabeza leve',
      );

      await tester.tap(find.text('GUARDAR REGISTRO'));
      await tester.pumpAndSettle();

      // Verificar que el registro con síntomas se muestra
      expect(find.text('130/85 mmHg'), findsOneWidget);
      expect(find.text('Dolor de cabeza leve'), findsOneWidget);
    });
  });

  group('Test para Eliminar Registros', () {
    testWidgets('Delete blood pressure record with swipe', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const CardioCareApp());

      // Primero agregar un registro para poder eliminarlo
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Sistólica (SYS)'),
        '140',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Diastólica (DIA)'),
        '90',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Pulso (PUL)'),
        '80',
      );
      await tester.tap(find.text('GUARDAR REGISTRO'));
      await tester.pumpAndSettle();

      // Verificar que el registro existe
      expect(find.text('140/90 mmHg'), findsOneWidget);

      // Hacer swipe para eliminar (Dismissible)
      await tester.drag(find.text('140/90 mmHg'), const Offset(-500, 0));
      await tester.pumpAndSettle();

      // Confirmar eliminación en el diálogo
      await tester.tap(find.text('Eliminar'));
      await tester.pumpAndSettle();

      // Verificar que el registro fue eliminado
      expect(find.text('140/90 mmHg'), findsNothing);
    });

    testWidgets('Cancel delete operation', (WidgetTester tester) async {
      await tester.pumpWidget(const CardioCareApp());

      // Agregar registro
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Sistólica (SYS)'),
        '150',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Diastólica (DIA)'),
        '95',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Pulso (PUL)'),
        '85',
      );
      await tester.tap(find.text('GUARDAR REGISTRO'));
      await tester.pumpAndSettle();

      // Hacer swipe para eliminar
      await tester.drag(find.text('150/95 mmHg'), const Offset(-500, 0));
      await tester.pumpAndSettle();

      // Cancelar eliminación
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      // Verificar que el registro sigue existiendo
      expect(find.text('150/95 mmHg'), findsOneWidget);
    });
  });

  group('Test para Generar PDF', () {
    testWidgets('Generate PDF from historial', (WidgetTester tester) async {
      await tester.pumpWidget(const CardioCareApp());

      // Agregar algunos registros primero
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.widgetWithText(TextFormField, 'Sistólica (SYS)'),
          '${120 + i}',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Diastólica (DIA)'),
          '${80 + i}',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Pulso (PUL)'),
          '${70 + i}',
        );
        await tester.tap(find.text('GUARDAR REGISTRO'));
        await tester.pumpAndSettle();
      }

      // Generar PDF desde el botón en el AppBar
      await tester.tap(find.byIcon(Icons.picture_as_pdf));
      await tester.pumpAndSettle();

      // Verificar que se muestra el mensaje de éxito
      expect(find.text('PDF generado exitosamente'), findsOneWidget);
    });

    testWidgets('Show message when no records for PDF', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const CardioCareApp());

      // Intentar generar PDF sin registros
      await tester.tap(find.byIcon(Icons.picture_as_pdf));
      await tester.pumpAndSettle();

      // Verificar mensaje de no hay registros
      expect(find.text('No hay registros para exportar'), findsOneWidget);
    });
  });

  group('Test de Validaciones de Formulario', () {
    testWidgets('Show error for invalid systolic pressure', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const CardioCareApp());

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Ingresar valor inválido
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Sistólica (SYS)'),
        '50',
      ); // Muy bajo
      await tester.tap(find.text('GUARDAR REGISTRO'));
      await tester.pump();

      // Verificar que muestra error de validación
      expect(find.text('Valor muy bajo'), findsOneWidget);
    });

    testWidgets('Show error for invalid diastolic pressure', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const CardioCareApp());

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Ingresar valor inválido
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Diastólica (DIA)'),
        '200',
      ); // Muy alto
      await tester.tap(find.text('GUARDAR REGISTRO'));
      await tester.pump();

      // Verificar que muestra error de validación
      expect(find.text('Valor muy alto'), findsOneWidget);
    });
  });

  group('Test de Botón de Emergencia', () {
    testWidgets('Emergency button shows dialog', (WidgetTester tester) async {
      await tester.pumpWidget(const CardioCareApp());

      // Tocar el botón de emergencia
      await tester.tap(find.text('EMERGENCIA'));
      await tester.pumpAndSettle();

      // Verificar que se muestra el diálogo de emergencia
      expect(find.text('Llamada de Emergencia'), findsOneWidget);
      expect(find.text('¿Llamar a contacto de emergencia?'), findsOneWidget);
    });
  });
}
