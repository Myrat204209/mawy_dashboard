// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class AllKeysAdapter extends TypeAdapter<AllKeys> {
  @override
  final int typeId = 0;

  @override
  AllKeys read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AllKeys(
      keys: (fields[0] as Map).map(
        (dynamic k, dynamic v) => MapEntry(
          k as String,
          (v as Map).map(
            (dynamic k, dynamic v) =>
                MapEntry(k as String, (v as Map).cast<String, String>()),
          ),
        ),
      ),
    );
  }

  @override
  void write(BinaryWriter writer, AllKeys obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.keys);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AllKeysAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LoginsAdapter extends TypeAdapter<Logins> {
  @override
  final int typeId = 1;

  @override
  Logins read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Logins(
      logins: fields[0] as String,
      passwords: fields[1] as String,
      keys: fields[2] as String,
      check: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Logins obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.logins)
      ..writeByte(1)
      ..write(obj.passwords)
      ..writeByte(2)
      ..write(obj.keys)
      ..writeByte(3)
      ..write(obj.check);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NewsIdAdapter extends TypeAdapter<NewsId> {
  @override
  final int typeId = 2;

  @override
  NewsId read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NewsId(nCount: (fields[0] as List).cast<dynamic>());
  }

  @override
  void write(BinaryWriter writer, NewsId obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.nCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewsIdAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AuthCheckAdapter extends TypeAdapter<AuthCheck> {
  @override
  final int typeId = 3;

  @override
  AuthCheck read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AuthCheck(
      check: fields[0] as bool,
      logins: fields[1] as String,
      passwords: fields[2] as String,
      keys: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AuthCheck obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.check)
      ..writeByte(1)
      ..write(obj.logins)
      ..writeByte(2)
      ..write(obj.passwords)
      ..writeByte(3)
      ..write(obj.keys);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthCheckAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
