import 'package:alt__wally/features/category/data/remote/category_dto.dart';
import 'package:alt__wally/features/user/data/remote/user_dto.dart';

class WallpaperDTO {
  final Wallpaper wallpaper;

  WallpaperDTO({required this.wallpaper});

  factory WallpaperDTO.fromJson(Map<String, dynamic> json) {
    return WallpaperDTO(
      wallpaper: Wallpaper.fromJson(json['wallpaper']),
    );
  }
}

class Wallpaper {
  final int? id;
  final int? userId;
  final int? categoryId;
  final String? title;
  final String? imageUrl;
  final int? size;
  final String? color;
  final int? height;
  final int? width;
  final bool? favourite;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final User? user;
  final CategoryDTO? category;

  Wallpaper(
      {this.id,
      this.userId,
      this.categoryId,
      this.title,
      this.imageUrl,
      this.size,
      this.color,
      this.height,
      this.favourite,
      this.width,
      this.createdAt,
      this.updatedAt,
      this.user,
      this.category});

  factory Wallpaper.fromJson(Map<String, dynamic> json) {
    return Wallpaper(
      id: json['id'],
      userId: json['user_id'],
      categoryId: int.parse(json['category_id']),
      title: json['title'],
      imageUrl: json['image_url'],
      size: int.parse(json['size']),
      color: json['color'],
      height: int.parse(json['height']),
      width: int.parse(json['width']),
      favourite: json['favourite'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      category: json['category'] != null
          ? CategoryDTO.fromJson(json['category'])
          : null,
    );
  }
}
