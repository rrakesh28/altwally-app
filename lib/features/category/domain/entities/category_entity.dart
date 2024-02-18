import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String? id;
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
}
