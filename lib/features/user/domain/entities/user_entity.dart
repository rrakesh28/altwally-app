import 'dart:io';

import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? id;
  final String? name;
  final String? email;
  final DateTime? emailVerifiedAt;
  final String? role;
  final String? password;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final File? profileImage;
  final File? bannerImage;
  final String? profileImageUrl;
  final String? bannerImageUrl;
  final String? token;

  const UserEntity({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.role,
    this.password,
    this.createdAt,
    this.updatedAt,
    this.profileImage,
    this.bannerImage,
    this.profileImageUrl,
    this.bannerImageUrl,
    this.token,
  });

  factory UserEntity.fromJson(Map<String, dynamic> map) {
    return UserEntity(
      name: map['name'],
      email: map['email'],
      profileImageUrl: map['profile_image_url'],
      bannerImageUrl: map['banner_image_url'],
      id: map['id'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        emailVerifiedAt,
        role,
        createdAt,
        updatedAt,
        profileImageUrl,
        bannerImageUrl,
        token,
      ];
}
