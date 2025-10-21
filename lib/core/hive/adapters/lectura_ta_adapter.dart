// lib/core/hive/adapters/lectura_ta_adapter.dart

import 'package:hive/hive.dart';
import '../../../data/models/lectura_ta.dart';

class LecturaTaAdapter extends TypeAdapter<LecturaTa> {
  @override
  final int typeId = 0;

  @override
  LecturaTa read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return LecturaTa(
      fecha: DateTime.parse(fields[0] as String),
      sistolica: fields[1] as int,
      diastolica: fields[2] as int,
      pulso: fields[3] as int,
      sintomas: fields[4] as String?,
      notas: fields[5] as String?,
      tipoRegistro: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LecturaTa obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.fecha.toIso8601String())
      ..writeByte(1)
      ..write(obj.sistolica)
      ..writeByte(2)
      ..write(obj.diastolica)
      ..writeByte(3)
      ..write(obj.pulso)
      ..writeByte(4)
      ..write(obj.sintomas)
      ..writeByte(5)
      ..write(obj.notas)
      ..writeByte(6)
      ..write(obj.tipoRegistro);
  }
}
