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
  int? likes;
  int? views;
  int? downloads;
  final bool? wallOfTheMonth;
  String? blurHash;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;
  final UserEntity? user;
  final CategoryEntity? category;

  WallpaperEntity({
    this.blurHash,
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
    this.likes,
    this.views,
    this.downloads,
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
        likes,
        blurHash,
        views,
        downloads,
        user,
        category,
      ];

  WallpaperEntity copyWith({
    String? id,
    String? userId,
    String? categoryId,
    String? title,
    File? image,
    String? imageUrl,
    int? size,
    String? color,
    bool? wallOfTheMonth,
    int? height,
    int? width,
    bool? favourite,
    int? likes,
    String? blurHash,
    int? views,
    int? downloads,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    UserEntity? user,
    CategoryEntity? category,
  }) {
    return WallpaperEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      image: image ?? this.image,
      imageUrl: imageUrl ?? this.imageUrl,
      size: size ?? this.size,
      color: color ?? this.color,
      wallOfTheMonth: wallOfTheMonth ?? this.wallOfTheMonth,
      height: height ?? this.height,
      width: width ?? this.width,
      favourite: favourite ?? this.favourite,
      likes: likes ?? this.likes,
      blurHash: blurHash ?? this.blurHash,
      views: views ?? this.views,
      downloads: downloads ?? this.downloads,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
      category: category ?? this.category,
    );
  }
}
