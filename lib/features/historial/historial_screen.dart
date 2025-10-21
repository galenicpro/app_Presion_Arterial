// lib/features/historial/historial_screen.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/lectura_ta.dart';
import '../../data/repositories/lectura_repository.dart';
import '../home/widgets/registro_list_item.dart';
import 'widgets/export_pdf_button.dart';

class HistorialScreen extends StatefulWidget {
  const HistorialScreen({super.key});

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  final LecturaRepository _repository = LecturaRepository();
  DateTimeRange? _selectedDateRange;
  String _selectedCategory = 'Todas';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Historial Completo',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: const [ExportPdfButton()],
      ),
      body: Column(
        children: [
          // Filtros simplificados
          _buildFilterSection(),

          // Lista de registros
          Expanded(
            child: ValueListenableBuilder<Box<LecturaTa>>(
              valueListenable: _repository.lecturasTaBox.listenable(),
              builder: (context, box, widget) {
                final lecturas = _applyFilters(_repository.getAllLecturas());

                if (lecturas.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: lecturas.length,
                  itemBuilder: (context, index) {
                    final lectura = lecturas[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: RegistroListItem(lectura: lectura),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filtros',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Filtro por categoría
              Expanded(
                child: DropdownButtonFormField<String>(
                  // CORREGIDO: Cambiado 'value' por 'initialValue'
                  initialValue: _selectedCategory,
                  items:
                      [
                        'Todas',
                        'Óptima',
                        'Normal',
                        'Presión Elevada',
                        'Hipertensión Grado 1',
                        'Crisis Hipertensiva',
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Categoría',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Botón para limpiar filtros
              ElevatedButton(
                onPressed: _clearFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black87,
                ),
                child: const Text('Limpiar'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Información de filtros aplicados
          if (_selectedCategory != 'Todas')
            Text(
              'Mostrando: $_selectedCategory',
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue[700],
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'No hay registros',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            'Los registros aparecerán aquí',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Volver al Inicio'),
          ),
        ],
      ),
    );
  }

  List<LecturaTa> _applyFilters(List<LecturaTa> lecturas) {
    var filtered = lecturas;

    // Filtro por fecha (si hay rango seleccionado)
    if (_selectedDateRange != null) {
      filtered = filtered.where((lectura) {
        return lectura.fecha.isAfter(_selectedDateRange!.start) &&
            lectura.fecha.isBefore(_selectedDateRange!.end);
      }).toList();
    }

    // Filtro por categoría
    if (_selectedCategory != 'Todas') {
      filtered = filtered.where((lectura) {
        return lectura.categoriaPresion == _selectedCategory;
      }).toList();
    }

    return filtered;
  }

  // CORREGIDO: Eliminados métodos no utilizados
  // void _onDateRangeChanged(DateTimeRange? range) {
  //   setState(() {
  //     _selectedDateRange = range;
  //   });
  // }

  // void _onCategoryChanged(String category) {
  //   setState(() {
  //     _selectedCategory = category;
  //   });
  // }

  void _clearFilters() {
    setState(() {
      _selectedDateRange = null;
      _selectedCategory = 'Todas';
    });
  }
}
