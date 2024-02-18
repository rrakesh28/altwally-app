import 'dart:io';

import 'package:alt__wally/features/user/domain/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel extends UserEntity {
  UserModel(
      {required String name,
      required String email,
      String? uid,
      File? profileImage,
      String? profileImageUrl,
      File? bannerImage,
      String? bannerImageUrl,
      Timestamp? createdAt,
      Timestamp? updatedAt})
      : super(
            name: name,
            email: email,
            uid: uid,
            profileImage: profileImage,
            profileImageUrl: profileImageUrl,
            bannerImage: bannerImage,
            bannerImageUrl: bannerImageUrl,
            createdAt: createdAt,
            updatedAt: updatedAt);

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'],
      email: map['email'],
      profileImageUrl: map['profile_image_url'],
      bannerImageUrl: map['banner_image_url'],
      uid: map['uid'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    var snapshotMap = snapshot.data() as Map<String, dynamic>;

    return UserModel(
      name: snapshotMap['name'],
      email: snapshotMap['email'],
      profileImageUrl: snapshotMap['profile_image_url'],
      bannerImageUrl: snapshotMap['banner_image_url'],
      uid: snapshotMap['uid'],
      createdAt: snapshotMap['created_at'],
      updatedAt: snapshotMap['updated_at'],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "name": name,
      "email": email,
      "uid": uid,
      'profile_image_url': profileImageUrl,
      'banner_image_url': bannerImageUrl,
      'created_at': createdAt,
      'update_at': updatedAt,
    };
  }
}
