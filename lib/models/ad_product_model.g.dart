// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ad_product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AdModelAdapter extends TypeAdapter<AdModel> {
  @override
  final int typeId = 1;

  @override
  AdModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AdModel(
      uid: fields[0] as String,
      addId: fields[1] as String,
      title: fields[2] as String,
      description: fields[3] as String,
      price: fields[4] as double,
      condition: fields[5] as String,
      location: fields[6] as String,
      listOfImages: (fields[7] as List).cast<String>(),
      brandName: fields[8] as String,
      createdAt: fields[9] as DateTime,
      isActive: fields[10] as bool,
      categoryId: fields[11] as String,
      servicePaymentType: fields[12] as String,
      websiteUrl: fields[13] as String,
      discountPrice: fields[14] as double,
      isSold: fields[15] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AdModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.addId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.condition)
      ..writeByte(6)
      ..write(obj.location)
      ..writeByte(7)
      ..write(obj.listOfImages)
      ..writeByte(8)
      ..write(obj.brandName)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.isActive)
      ..writeByte(11)
      ..write(obj.categoryId)
      ..writeByte(12)
      ..write(obj.servicePaymentType)
      ..writeByte(13)
      ..write(obj.websiteUrl)
      ..writeByte(14)
      ..write(obj.discountPrice)
      ..writeByte(15)
      ..write(obj.isSold);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
