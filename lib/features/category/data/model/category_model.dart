import 'package:hive/hive.dart';
import 'package:alt__wally/features/category/domain/entities/category_entity.dart';

part 'category_model.g.dart';

@HiveType(typeId: 1)
class CategoryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? bannerImageUrl;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final DateTime updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    this.bannerImageUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
  })  : this.createdAt = createdAt,
        this.updatedAt = updatedAt;

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      name: map['name'],
      bannerImageUrl: map['banner_image_url'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      bannerImageUrl: bannerImageUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  String toString() {
    return 'CategoryModel(id: $id, name: $name, bannerImageUrl: $bannerImageUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
