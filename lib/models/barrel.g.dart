// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barrel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BarrelAdapter extends TypeAdapter<Barrel> {
  @override
  final int typeId = 1;

  @override
  Barrel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Barrel(
      id: fields[0] as String,
      name: fields[1] as String,
      usage: fields[2] as String,
      currentLevel: fields[3] as double,
      maxLevel: fields[4] as double,
      createdAt: fields[5] as DateTime?,
      notes: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Barrel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.usage)
      ..writeByte(3)
      ..write(obj.currentLevel)
      ..writeByte(4)
      ..write(obj.maxLevel)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BarrelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
