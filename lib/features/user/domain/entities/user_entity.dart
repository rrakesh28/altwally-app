import 'dart:io';

import 'package:alt__wally/features/user/data/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? uid;
  final String? name;
  final String? email;
  final DateTime? emailVerifiedAt;
  final String? role;
  final String? password;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;
  final File? profileImage;
  final File? bannerImage;
  final String? profileImageUrl;
  final String? bannerImageUrl;
  final String? token;

  const UserEntity({
    this.uid,
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

  factory UserEntity.fromUserModel(UserModel userModel) {
    return UserEntity(
      uid: userModel.uid,
      name: userModel.name,
      email: userModel.email,
      emailVerifiedAt: userModel.emailVerifiedAt,
      role: userModel.role,
      createdAt: userModel.createdAt,
      updatedAt: userModel.updatedAt,
      profileImage: userModel.profileImage,
      bannerImage: userModel.bannerImage,
      profileImageUrl: userModel.profileImageUrl,
      bannerImageUrl: userModel.bannerImageUrl,
      token: userModel.token,
    );
  }

  @override
  List<Object?> get props => [
        uid,
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
