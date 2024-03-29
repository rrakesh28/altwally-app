import 'package:alt__wally/features/wallpaper/data/remote/dto/wallpapers_dto.dart';
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int? id;
  final String? name;
  final String? email;
  final DateTime? emailVerifiedAt;
  final String? role;
  final String? password;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? profileImageUrl;
  final String? bannerImageUrl;
  final String? token;

  UserEntity({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.role,
    this.password,
    this.createdAt,
    this.updatedAt,
    this.profileImageUrl,
    this.bannerImageUrl,
    this.token,
  });

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

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['user']['id'],
      name: json['user']['name'],
      email: json['user']['email'],
      emailVerifiedAt: json['user']['email_verified_at'] != null
          ? DateTime.parse(json['user']['email_verified_at'])
          : null,
      password: json['user']['password'] ?? '',
      role: json['user']['role'],
      createdAt: DateTime.parse(json['user']['created_at']),
      updatedAt: DateTime.parse(json['user']['updated_at']),
      profileImageUrl: json['user']['profile_image_url'],
      bannerImageUrl: json['user']['banner_image_url'],
      token: json['token'] ?? '',
    );
  }

  factory UserEntity.fromUser(UserDto user) {
    return UserEntity(
      id: user.id,
      name: user.name,
      email: user.email,
      emailVerifiedAt: null,
      role: user.role,
      profileImageUrl: user.profileImageUrl,
      bannerImageUrl: user.bannerImageUrl,
      token: '',
    );
  }
}
