import 'package:alt__wally/features/wallpaper/data/remote/dto/wallpapers_dto.dart';
import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final int? id;
  final String? name;
  final String? bannerImageUrl;
  final String? type;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CategoryEntity({
    this.id,
    this.name,
    this.type,
    this.bannerImageUrl,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        bannerImageUrl,
        type,
        createdAt,
        updatedAt,
      ];

  factory CategoryEntity.fromJson(Map<String, dynamic> json) {
    return CategoryEntity(
      id: json['category']['id'],
      name: json['category']['name'],
      bannerImageUrl: json['category']['banner_image_url'],
      createdAt: DateTime.parse(json['user']['created_at']),
      updatedAt: DateTime.parse(json['user']['updated_at']),
    );
  }

  factory CategoryEntity.fromCategory(CategoryDto category) {
    return CategoryEntity(
      id: category.id,
      name: category.name,
      bannerImageUrl: category.bannerImageUrl,
      createdAt: null,
      updatedAt: null,
      type: '',
    );
  }
}
