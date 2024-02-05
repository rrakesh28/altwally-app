import 'dart:io';

import 'package:alt__wally/features/category/domain/entities/category_entity.dart';
import 'package:alt__wally/features/user/domain/entities/user_entity.dart';
import 'package:alt__wally/features/wallpaper/data/remote/dto/wallpapers_dto.dart';
import 'package:equatable/equatable.dart';

class WallpaperEntity extends Equatable {
  final int? id;
  final int? userId;
  final int? categoryId;
  final String? title;
  final File? image;
  final String? imageUrl;
  final int? size;
  final String? color;
  final int? height;
  final int? width;
  bool? favourite;
  final UserEntity? user;
  final CategoryEntity? category;

  WallpaperEntity({
    this.id,
    this.userId,
    this.categoryId,
    this.title,
    this.image,
    this.imageUrl,
    this.size,
    this.color,
    this.height,
    this.width,
    this.favourite,
    this.user,
    this.category,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        categoryId,
        title,
        image,
        imageUrl,
        size,
        color,
        height,
        width,
        favourite,
        user,
        category,
      ];

  factory WallpaperEntity.fromWallpaper(WallpaperDataDto wallpaper) {
    return WallpaperEntity(
      id: wallpaper.id,
      userId: wallpaper.userId,
      categoryId: wallpaper.categoryId,
      title: wallpaper.title,
      imageUrl: wallpaper.imageUrl,
      size: wallpaper.size,
      color: '',
      height: wallpaper.height,
      width: wallpaper.width,
      favourite: wallpaper.favourite,
      user: UserEntity.fromUser(
          wallpaper.user), // Assuming you have a fromUser method in UserEntity
      category: CategoryEntity.fromCategory(wallpaper.category),
    );
  }
}
