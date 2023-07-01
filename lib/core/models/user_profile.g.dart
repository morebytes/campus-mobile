// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileModelAdapter extends TypeAdapter<UserProfileModel> {
  @override
  final int typeId = 2;

  @override
  UserProfileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfileModel(
      disabledLots: (fields[0] as List?)?.cast<String>(),
      disabledOccuspaceLocations: (fields[1] as List?)?.cast<String?>(),
      subscribedTopics: (fields[2] as List?)?.cast<String?>(),
      disabledParkingSpots: (fields[8] as List?)?.cast<String?>(),
      disabledParkingLots: (fields[9] as List?)?.cast<String?>(),
      disabledStops: (fields[5] as List?)?.cast<int?>(),
      surveyCompletion: (fields[6] as List?)?.cast<String>(),
      disabledVentilationLocations: (fields[7] as List?)?.cast<String?>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserProfileModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.disabledLots)
      ..writeByte(1)
      ..write(obj.disabledOccuspaceLocations)
      ..writeByte(2)
      ..write(obj.subscribedTopics)
      ..writeByte(8)
      ..write(obj.disabledParkingSpots)
      ..writeByte(9)
      ..write(obj.disabledParkingLots)
      ..writeByte(5)
      ..write(obj.disabledStops)
      ..writeByte(6)
      ..write(obj.surveyCompletion)
      ..writeByte(7)
      ..write(obj.disabledVentilationLocations);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
