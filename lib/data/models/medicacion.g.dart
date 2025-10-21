// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicacion.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

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
      horarios: (fields[3] as List).cast<TimeOfDay>(),
      activa: fields[4] as bool,
      fechaInicio: fields[5] as DateTime,
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
      ..write(obj.horarios)
      ..writeByte(4)
      ..write(obj.activa)
      ..writeByte(5)
      ..write(obj.fechaInicio)
      ..writeByte(6)
      ..write(obj.instrucciones)
      ..writeByte(7)
      ..write(obj.viaAdministracion);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicacionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
