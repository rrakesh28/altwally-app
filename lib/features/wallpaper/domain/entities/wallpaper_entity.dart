import 'dart:io';

import 'package:alt__wally/features/category/domain/entities/category_entity.dart';
import 'package:alt__wally/features/user/domain/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class WallpaperEntity extends Equatable {
  final String? id;
  final String? userId;
  final String? categoryId;
  final String? title;
  final File? image;
  final String? imageUrl;
  final int? size;
  final String? color;
  final int? height;
  final int? width;
  bool? favourite;
  final bool? wallOfTheMonth;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;
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
    this.wallOfTheMonth,
    this.height,
    this.width,
    this.favourite,
    this.createdAt,
    this.updatedAt,
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
        wallOfTheMonth,
        height,
        width,
        favourite,
        user,
        category,
      ];
}
