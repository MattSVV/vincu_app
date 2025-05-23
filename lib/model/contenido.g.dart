// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contenido.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContenidoAdapter extends TypeAdapter<Contenido> {
  @override
  final int typeId = 3;

  @override
  Contenido read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Contenido(
      fields[0] as int,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as Departamento,
      fields[5] as Pantalla,
    );
  }

  @override
  void write(BinaryWriter writer, Contenido obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.idContenido)
      ..writeByte(1)
      ..write(obj.tituloContenido)
      ..writeByte(2)
      ..write(obj.subtituloContenido)
      ..writeByte(3)
      ..write(obj.descripcionContenido)
      ..writeByte(4)
      ..write(obj.departamento)
      ..writeByte(5)
      ..write(obj.pantalla);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContenidoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
