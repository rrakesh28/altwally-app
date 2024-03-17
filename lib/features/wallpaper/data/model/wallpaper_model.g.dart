// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallpaper_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WallpaperModelAdapter extends TypeAdapter<WallpaperModel> {
  @override
  final int typeId = 2;

  @override
  WallpaperModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WallpaperModel(
      id: fields[0] as String?,
      userId: fields[1] as String?,
      categoryId: fields[2] as String?,
      title: fields[3] as String?,
      imageUrl: fields[4] as String?,
      size: fields[5] as int?,
      height: fields[6] as int?,
      width: fields[7] as int?,
      wallOfTheMonth: fields[8] as bool?,
      favourite: fields[9] == null ? false : fields[9] as bool?,
      likes: fields[10] as int?,
      views: fields[11] as int?,
      downloads: fields[12] as int?,
      blurHash: fields[13] as String?,
      createdAt: fields[14] as DateTime,
      updatedAt: fields[15] as DateTime,
      user: fields[16] as UserModel?,
      category: fields[17] as CategoryModel?,
    );
  }

  @override
  void write(BinaryWriter writer, WallpaperModel obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.categoryId)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.imageUrl)
      ..writeByte(5)
      ..write(obj.size)
      ..writeByte(6)
      ..write(obj.height)
      ..writeByte(7)
      ..write(obj.width)
      ..writeByte(8)
      ..write(obj.wallOfTheMonth)
      ..writeByte(9)
      ..write(obj.favourite)
      ..writeByte(10)
      ..write(obj.likes)
      ..writeByte(11)
      ..write(obj.views)
      ..writeByte(12)
      ..write(obj.downloads)
      ..writeByte(13)
      ..write(obj.blurHash)
      ..writeByte(14)
      ..write(obj.createdAt)
      ..writeByte(15)
      ..write(obj.updatedAt)
      ..writeByte(16)
      ..write(obj.user)
      ..writeByte(17)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WallpaperModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
