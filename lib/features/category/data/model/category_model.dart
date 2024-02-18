import 'package:alt__wally/features/category/domain/entities/category_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel extends CategoryEntity {
  CategoryModel({
    required String id,
    required String name,
    String? bannerImageUrl,
    String? type,
  }) : super(name: name, id: id, type: type, bannerImageUrl: bannerImageUrl);

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      name: map['name'],
      bannerImageUrl: map['banner_image_url'],
      type: map['type'],
    );
  }

  factory CategoryModel.fromSnapshot(DocumentSnapshot snapshot) {
    var snapshotMap = snapshot.data() as Map<String, dynamic>;
    return CategoryModel.fromMap(snapshotMap);
  }

  Map<String, dynamic> toDocument() {
    return {
      "id": id,
      "name": name,
      "banner_image_url": bannerImageUrl,
      'type': type,
    };
  }
}
