import 'package:hive/hive.dart';

part 'user_model.g.dart'; // Include this line to enable code generation

@HiveType(typeId: 0) // Add HiveType annotation with a unique typeId
class UserModel extends HiveObject {
  @HiveField(0) // Add HiveField annotation for each field
  final String name;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String? id;

  @HiveField(3)
  final String? profileImageUrl;

  @HiveField(4)
  final String? bannerImageUrl;

  @HiveField(5)
  final DateTime? createdAt;

  @HiveField(6)
  final DateTime? updatedAt;

  UserModel({
    required this.name,
    required this.email,
    this.id,
    this.profileImageUrl,
    this.bannerImageUrl,
    this.createdAt,
    this.updatedAt,
  });

  // You can keep the factory constructor for deserialization
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'],
      email: map['email'],
      profileImageUrl: map['profile_image_url'],
      bannerImageUrl: map['banner_image_url'],
      id: map['id'],
      createdAt:
          map['created_at'] != null ? (map['created_at']).toDate() : null,
      updatedAt:
          map['updated_at'] != null ? (map['updated_at']).toDate() : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'profile_image_url': profileImageUrl,
      'banner_image_url': bannerImageUrl,
      'id': id,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
