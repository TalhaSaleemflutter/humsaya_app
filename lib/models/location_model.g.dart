// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocationModelAdapter extends TypeAdapter<LocationModel> {
  @override
  final int typeId = 2;

  @override
  LocationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocationModel(
      neighborLocation: fields[0] as String,
      streetNumber: fields[1] as String,
      houseAddress: fields[2] as String,
      city: fields[3] as String,
      state: fields[4] as String,
      zipCode: fields[5] as String,
      country: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LocationModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.neighborLocation)
      ..writeByte(1)
      ..write(obj.streetNumber)
      ..writeByte(2)
      ..write(obj.houseAddress)
      ..writeByte(3)
      ..write(obj.city)
      ..writeByte(4)
      ..write(obj.state)
      ..writeByte(5)
      ..write(obj.zipCode)
      ..writeByte(6)
      ..write(obj.country);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
