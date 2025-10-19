// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lectura_ta.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

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
      fecha: fields[0] as DateTime,
      sistolica: fields[1] as int,
      diastolica: fields[2] as int,
      pulso: fields[3] as int,
      notas: fields[4] as String,
      tipoRegistro: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LecturaTa obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.fecha)
      ..writeByte(1)
      ..write(obj.sistolica)
      ..writeByte(2)
      ..write(obj.diastolica)
      ..writeByte(3)
      ..write(obj.pulso)
      ..writeByte(4)
      ..write(obj.notas)
      ..writeByte(5)
      ..write(obj.tipoRegistro);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LecturaTaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
