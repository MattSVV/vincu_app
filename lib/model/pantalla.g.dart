// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pantalla.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PantallaAdapter extends TypeAdapter<Pantalla> {
  @override
  final int typeId = 1;

  @override
  Pantalla read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Pantalla(
      idPantalla: fields[0] as int,
      nombrePantalla: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Pantalla obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.idPantalla)
      ..writeByte(1)
      ..write(obj.nombrePantalla);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PantallaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
