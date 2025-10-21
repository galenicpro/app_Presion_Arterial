// lib/core/hive/adapters/medicacion_adapter.dart

import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import '../../../data/models/medicacion.dart';

class MedicacionAdapter extends TypeAdapter<Medicacion> {
  @override
  final int typeId = 1;

  @override
  Medicacion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return Medicacion(
      nombre: fields[0] as String,
      dosis: fields[1] as String,
      dias: (fields[2] as List).cast<int>(),
      horarios: _readHorarios(fields[3] as List),
      activa: fields[4] as bool,
      fechaInicio: DateTime.parse(fields[5] as String),
      instrucciones: fields[6] as String?,
      viaAdministracion: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Medicacion obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.nombre)
      ..writeByte(1)
      ..write(obj.dosis)
      ..writeByte(2)
      ..write(obj.dias)
      ..writeByte(3)
      ..write(_writeHorarios(obj.horarios))
      ..writeByte(4)
      ..write(obj.activa)
      ..writeByte(5)
      ..write(obj.fechaInicio.toIso8601String())
      ..writeByte(6)
      ..write(obj.instrucciones)
      ..writeByte(7)
      ..write(obj.viaAdministracion);
  }

  List<String> _writeHorarios(List<TimeOfDay> horarios) {
    return horarios.map((h) => '${h.hour}:${h.minute}').toList();
  }

  List<TimeOfDay> _readHorarios(List<dynamic> horariosData) {
    return horariosData.map((h) {
      final parts = (h as String).split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }).toList();
  }
}
