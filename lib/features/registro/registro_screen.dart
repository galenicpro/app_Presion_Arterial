// lib/features/registro/registro_screen.dart

import 'package:flutter/material.dart';
import 'registro_form.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  final RegistroForm _form = RegistroForm();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nuevo Registro',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[700],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 28),
          onPressed: () => _showExitConfirmation(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título principal
                const Text(
                  'Registro de Presión Arterial',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Complete los siguientes datos para registrar su presión arterial',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 32),

                // Campos de presión arterial
                _buildPressureSection(),
                const SizedBox(height: 24),

                // Campo de pulso
                _buildPulseSection(),
                const SizedBox(height: 24),

                // Fecha y hora
                _buildDateTimeSection(),
                const SizedBox(height: 24),

                // Síntomas
                _buildSymptomsSection(),
                const SizedBox(height: 40),

                // Botón de guardar
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPressureSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.favorite, color: Colors.red, size: 24),
                SizedBox(width: 8),
                Text(
                  'Presión Arterial',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                // Sistólica
                Expanded(
                  child: _buildNumberField(
                    label: 'Sistólica (SYS)',
                    hintText: '120',
                    unit: 'mmHg',
                    controller: _form.sistolicaController,
                    validator: _form.validateSistolica,
                    onChanged: (value) => _updatePressureClassification(),
                  ),
                ),
                const SizedBox(width: 16),
                // Separador
                const Text(
                  '/',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 16),
                // Diastólica
                Expanded(
                  child: _buildNumberField(
                    label: 'Diastólica (DIA)',
                    hintText: '80',
                    unit: 'mmHg',
                    controller: _form.diastolicaController,
                    validator: _form.validateDiastolica,
                    onChanged: (value) => _updatePressureClassification(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Clasificación de presión
            ValueListenableBuilder<String>(
              valueListenable: _form.pressureClassification,
              builder: (context, classification, child) {
                if (classification.isEmpty) return const SizedBox();
                return Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getClassificationColor(
                      classification,
                    ).withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _getClassificationColor(classification),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getClassificationIcon(classification),
                        size: 16,
                        color: _getClassificationColor(classification),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        classification,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: _getClassificationColor(classification),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPulseSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.monitor_heart, color: Colors.green, size: 24),
                SizedBox(width: 8),
                Text(
                  'Frecuencia Cardíaca',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildNumberField(
              label: 'Pulso (PUL)',
              hintText: '70',
              unit: 'bpm',
              controller: _form.pulsoController,
              validator: _form.validatePulso,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.blue, size: 24),
                SizedBox(width: 8),
                Text(
                  'Fecha y Hora',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildDateField()),
                const SizedBox(width: 16),
                Expanded(child: _buildTimeField()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSymptomsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.warning_amber, color: Colors.orange, size: 24),
                SizedBox(width: 8),
                Text(
                  'Síntomas (Opcional)',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Ej: Dolor de cabeza, mareo, palpitaciones...',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _form.sintomasController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText:
                    'Describa cualquier síntoma que esté experimentando...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberField({
    required String label,
    required String hintText,
    required String unit,
    required TextEditingController controller,
    required String? Function(String?) validator,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                validator: validator,
                onChanged: onChanged,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              unit,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fecha',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDate(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                ValueListenableBuilder<DateTime>(
                  valueListenable: _form.fecha,
                  builder: (context, fecha, child) {
                    return Text(
                      '${fecha.day}/${fecha.month}/${fecha.year}',
                      style: const TextStyle(fontSize: 16),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hora',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectTime(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                ValueListenableBuilder<TimeOfDay>(
                  valueListenable: _form.hora,
                  builder: (context, hora, child) {
                    return Text(
                      _form.formatTimeOfDay(hora),
                      style: const TextStyle(fontSize: 16),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: _saveRegistro,
        icon: const Icon(Icons.save, size: 24),
        label: const Text(
          'GUARDAR REGISTRO',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[700],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _form.fecha.value,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('es', 'ES'),
    );
    if (picked != null) {
      _form.fecha.value = picked;
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _form.hora.value,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );
    if (picked != null) {
      _form.hora.value = picked;
    }
  }

  void _updatePressureClassification() {
    final sistolica = int.tryParse(_form.sistolicaController.text);
    final diastolica = int.tryParse(_form.diastolicaController.text);

    if (sistolica != null && diastolica != null) {
      _form.updatePressureClassification(sistolica, diastolica);
    }
  }

  void _saveRegistro() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _form.saveRegistro();
        if (mounted) {
          Navigator.of(context).pop(true); // Retornar éxito
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al guardar: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _showExitConfirmation(BuildContext context) {
    if (_form.hasUnsavedChanges()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('¿Salir sin guardar?'),
          content: const Text(
            'Tiene cambios sin guardar. ¿Está seguro de que desea salir?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar diálogo
                Navigator.of(context).pop(); // Cerrar pantalla
              },
              child: const Text('Salir', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  Color _getClassificationColor(String classification) {
    switch (classification) {
      case 'Crisis Hipertensiva':
        return Colors.red;
      case 'Hipertensión Grado 1':
        return Colors.orange;
      case 'Presión Elevada':
        return Colors.yellow.shade700;
      case 'Normal':
        return Colors.green;
      case 'Óptima':
        return Colors.green.shade800;
      default:
        return Colors.grey;
    }
  }

  IconData _getClassificationIcon(String classification) {
    switch (classification) {
      case 'Crisis Hipertensiva':
        return Icons.warning;
      case 'Hipertensión Grado 1':
        return Icons.error_outline;
      case 'Presión Elevada':
        return Icons.info_outline;
      default:
        return Icons.check_circle;
    }
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }
}
