import 'dart:io';

import 'package:alt__wally/features/category/data/model/category_model.dart';
import 'package:alt__wally/features/user/data/model/user_model.dart';
import 'package:alt__wally/features/wallpaper/domain/entities/wallpaper_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: must_be_immutable
class WallpaperModel extends WallpaperEntity {
  @override
  // ignore: overridden_fields
  final UserModel? user;
  @override
  // ignore: overridden_fields
  final CategoryModel? category;

  WallpaperModel({
    String? id,
    String? userId,
    String? categoryId,
    String? title,
    File? image,
    String? imageUrl,
    int? size,
    int? height,
    int? width,
    bool? wallOfTheMonth,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    bool? favourite,
    int? likes,
    int? views,
    int? downloads,
    String? blurHash,
    this.user,
    this.category,
  }) : super(
            id: id,
            userId: userId,
            categoryId: categoryId,
            title: title,
            imageUrl: imageUrl,
            size: size,
            wallOfTheMonth: wallOfTheMonth,
            height: height,
            width: width,
            likes: likes,
            downloads: downloads,
            views: views,
            blurHash: blurHash,
            createdAt: createdAt,
            updatedAt: updatedAt,
            favourite: favourite);

  factory WallpaperModel.fromSnapshot(DocumentSnapshot snapshot) {
    var snapshotMap = snapshot.data() as Map<String, dynamic>;
    return WallpaperModel(
      id: snapshotMap['id'],
      userId: snapshotMap['user_id'],
      categoryId: snapshotMap['category_id'],
      title: snapshotMap['title'],
      imageUrl: snapshotMap['image_url'],
      size: snapshotMap['size'],
      height: snapshotMap['height'],
      width: snapshotMap['width'],
      wallOfTheMonth: snapshotMap['wall_of_the_month'],
      blurHash: snapshotMap['blur_hash'],
      createdAt: snapshotMap['created_at'],
      updatedAt: snapshotMap['updated_at'],
      user: UserModel.fromMap(snapshotMap['user']),
      category: CategoryModel.fromMap(snapshotMap['category']),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "id": id,
      "user_id": userId,
      "category_id": categoryId,
      "title": title,
      "image_url": imageUrl,
      "size": size,
      "height": height,
      "width": width,
      "wall_of_the_month": wallOfTheMonth,
      "blur_hash": blurHash,
      "created_at": createdAt,
      "updated_at": updatedAt,
      "user": user?.toDocument(), // Assuming UserModel has a toMap method
      "category":
          category?.toDocument(), // Assuming CategoryModel has a toMap method
    };
  }
}
