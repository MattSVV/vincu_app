// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archivo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ArchivoAdapter extends TypeAdapter<Archivo> {
  @override
  final int typeId = 4;

  @override
  Archivo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Archivo(
      fields[0] as int,
      fields[1] as String,
      fields[2] as String,
      fields[3] as Departamento,
    );
  }

  @override
  void write(BinaryWriter writer, Archivo obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.idArchivo)
      ..writeByte(1)
      ..write(obj.tituloArchivo)
      ..writeByte(2)
      ..write(obj.urlArchivo)
      ..writeByte(3)
      ..write(obj.departamentoArchivo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArchivoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
