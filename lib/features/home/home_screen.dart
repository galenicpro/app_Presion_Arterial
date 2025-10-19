// lib/features/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/lectura_ta.dart';
import '../../data/repositories/lectura_repository.dart';
import '../registro/registro_screen.dart';
import 'widgets/registro_list_item.dart';
import 'widgets/empty_state.dart';
import 'widgets/blood_pressure_chart.dart';
import 'widgets/quick_stats_card.dart';
import 'widgets/emergency_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LecturaRepository _repository = LecturaRepository();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _navigateToRegistro() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const RegistroScreen()));
  }

  void _showDeleteConfirmation(LecturaTa lectura) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '¿Eliminar registro?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Esta acción no se puede deshacer.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar', style: TextStyle(fontSize: 16)),
            ),
            TextButton(
              onPressed: () {
                _repository.deleteLectura(lectura);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Registro eliminado'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text(
                'Eliminar',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _exportToPDF() {
    // Implementar exportación a PDF
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Generando PDF...')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CardioCare',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[700],
        elevation: 2,
        actions: [
          // Botón de exportar PDF
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, size: 28),
            onPressed: _exportToPDF,
            tooltip: 'Generar PDF',
          ),
          // Logo del grupo
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Image.asset(
              'assets/images/logo_min.png',
              height: 32,
              width: 32,
            ),
          ),
        ],
      ),

      // Botón flotante grande y accesible
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 16, right: 16),
        child: FloatingActionButton.extended(
          onPressed: _navigateToRegistro,
          backgroundColor: Colors.blue[700],
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add, size: 28),
          label: const Text(
            'NUEVO REGISTRO',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          elevation: 4,
        ),
      ),

      body: StreamBuilder<BoxEvent>(
        stream: _repository.lecturasStream,
        builder: (context, snapshot) {
          final List<LecturaTa> lecturas = _repository.getAllLecturas();

          if (lecturas.isEmpty) {
            return const EmptyState();
          }

          final estadisticas = _repository.getEstadisticas();
          final ultimaLectura = lecturas.first;

          return Column(
            children: [
              // Banner de estado actual (si hay lecturas recientes)
              if (lecturas.isNotEmpty) _buildCurrentStatusBanner(ultimaLectura),

              // Contenido desplazable
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    // Tarjeta de estadísticas rápidas
                    QuickStatsCard(estadisticas: estadisticas),

                    const SizedBox(height: 20),

                    // Gráfico de presión arterial
                    BloodPressureChart(lecturas: lecturas),

                    const SizedBox(height: 24),

                    // Título del historial
                    _buildHistorialTitle(),

                    const SizedBox(height: 16),

                    // Lista de registros
                    ..._buildRegistrosList(lecturas),

                    const SizedBox(height: 80), // Espacio para el FAB
                  ],
                ),
              ),
            ],
          );
        },
      ),

      // Botón de emergencia en la barra inferior
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildCurrentStatusBanner(LecturaTa ultimaLectura) {
    final categoria = _repository.clasificarPresion(
      ultimaLectura.sistolica,
      ultimaLectura.diastolica,
    );

    Color backgroundColor;
    IconData icon;

    switch (categoria) {
      case 'Crisis Hipertensiva':
        backgroundColor = Colors.red;
        icon = Icons.warning;
        break;
      case 'Hipertensión Grado 1':
        backgroundColor = Colors.orange;
        icon = Icons.error_outline;
        break;
      case 'Presión Elevada':
        backgroundColor = Colors.yellow[700]!;
        icon = Icons.info_outline;
        break;
      default:
        backgroundColor = Colors.green;
        icon = Icons.check_circle;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      color: backgroundColor.withAlpha((0.9 * 255).round()),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estado Actual: $categoria',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Última lectura: ${ultimaLectura.sistolica}/${ultimaLectura.diastolica} mmHg',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorialTitle() {
    return const Row(
      children: [
        Icon(Icons.history, size: 24, color: Colors.blueAccent),
        SizedBox(width: 8),
        Text(
          'Historial de Registros',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildRegistrosList(List<LecturaTa> lecturas) {
    return lecturas.map((lectura) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Dismissible(
          key: ValueKey(lectura.key),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            _showDeleteConfirmation(lectura);
            return false; // No dismiss automáticamente, esperar confirmación
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(
              Icons.delete_forever,
              color: Colors.white,
              size: 32,
            ),
          ),
          child: RegistroListItem(
            lectura: lectura,
            onTap: () {
              //  Implementar edición de registro
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Función de edición en desarrollo'),
                ),
              );
            },
          ),
        ),
      );
    }).toList();
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            // obtener negro con 10% de opacidad (equivalente a Colors.black.withOpacity(0.1))
            color: Colors.black.withAlpha((0.1 * 255).round()),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: EmergencyButton(
              onPressed: () {
                // Implementar llamada de emergencia
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Llamada de Emergencia'),
                    content: const Text('¿Llamar a contacto de emergencia?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // Implementar llamada
                        },
                        child: const Text('Llamar'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
