import 'package:alt__wally/features/wallpaper/domain/entities/wallpaper_entity.dart';
import 'package:hive/hive.dart';
import 'package:alt__wally/features/category/data/model/category_model.dart';
import 'package:alt__wally/features/user/data/model/user_model.dart';

part 'wallpaper_model.g.dart';

@HiveType(typeId: 2)
class WallpaperModel extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? userId;

  @HiveField(2)
  String? categoryId;

  @HiveField(3)
  String? title;

  @HiveField(4)
  String? imageUrl;

  @HiveField(5)
  int? size;

  @HiveField(6)
  int? height;

  @HiveField(7)
  int? width;

  @HiveField(8)
  bool? wallOfTheMonth;

  @HiveField(9, defaultValue: false)
  bool? favourite;

  @HiveField(10)
  int? likes;

  @HiveField(11)
  int? views;

  @HiveField(12)
  int? downloads;

  @HiveField(13)
  String? blurHash;

  @HiveField(14)
  DateTime createdAt;

  @HiveField(15)
  DateTime updatedAt;

  @HiveField(16)
  UserModel? user;

  @HiveField(17)
  CategoryModel? category;

  WallpaperModel({
    this.id,
    this.userId,
    this.categoryId,
    this.title,
    this.imageUrl,
    this.size,
    this.height,
    this.width,
    this.wallOfTheMonth,
    this.favourite,
    this.likes,
    this.views,
    this.downloads,
    this.blurHash,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.category,
  });

  WallpaperModel copyWith({
    String? id,
    String? userId,
    String? categoryId,
    String? title,
    String? imageUrl,
    int? size,
    int? height,
    int? width,
    bool? wallOfTheMonth,
    bool? favourite,
    int? likes,
    int? views,
    int? downloads,
    String? blurHash,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserModel? user,
    CategoryModel? category,
  }) {
    return WallpaperModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      size: size ?? this.size,
      height: height ?? this.height,
      width: width ?? this.width,
      wallOfTheMonth: wallOfTheMonth ?? this.wallOfTheMonth,
      favourite: favourite ?? this.favourite,
      likes: likes ?? this.likes,
      views: views ?? this.views,
      downloads: downloads ?? this.downloads,
      blurHash: blurHash ?? this.blurHash,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
      category: category ?? this.category,
    );
  }

  WallpaperModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        userId = map['user_id'],
        categoryId = map['category_id'],
        title = map['title'],
        imageUrl = map['image_url'],
        size = map['size'],
        height = map['height'],
        width = map['width'],
        wallOfTheMonth = map['wall_of_the_month'],
        favourite = map['favourite'],
        likes = map['likes'],
        views = map['views'],
        downloads = map['downloads'],
        blurHash = map['blur_hash'],
        createdAt = DateTime.parse(map['created_at']),
        updatedAt = DateTime.parse(map['updated_at']);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'category_id': categoryId,
      'title': title,
      'image_url': imageUrl,
      'size': size,
      'height': height,
      'width': width,
      'favourite': favourite,
      'wall_of_the_month': wallOfTheMonth,
      'likes': likes,
      'views': views,
      'downloads': downloads,
      'blur_hash': blurHash,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory WallpaperModel.fromWallpaperEntity(WallpaperEntity wallpaperEntity) {
    return WallpaperModel(
      id: wallpaperEntity.id,
      userId: wallpaperEntity.userId,
      categoryId: wallpaperEntity.categoryId,
      title: wallpaperEntity.title,
      imageUrl: wallpaperEntity.imageUrl,
      size: wallpaperEntity.size,
      height: wallpaperEntity.height,
      width: wallpaperEntity.width,
      wallOfTheMonth: wallpaperEntity.wallOfTheMonth,
      favourite: wallpaperEntity.favourite,
      likes: wallpaperEntity.likes,
      views: wallpaperEntity.views,
      downloads: wallpaperEntity.downloads,
      blurHash: wallpaperEntity.blurHash,
      createdAt: wallpaperEntity.createdAt!,
      updatedAt: wallpaperEntity.updatedAt!,
    );
  }
  WallpaperEntity toEntity() {
    return WallpaperEntity(
      id: id,
      userId: userId,
      categoryId: categoryId,
      title: title,
      imageUrl: imageUrl,
      size: size,
      height: height,
      width: width,
      wallOfTheMonth: wallOfTheMonth,
      favourite: favourite,
      likes: likes,
      views: views,
      downloads: downloads,
      blurHash: blurHash,
      createdAt: createdAt,
      updatedAt: updatedAt,
      category: category?.toEntity(),
    );
  }
}
