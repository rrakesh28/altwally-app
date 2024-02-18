import 'package:alt__wally/core/util/resource.dart';
import 'package:alt__wally/features/category/data/model/category_model.dart';
import 'package:alt__wally/features/category/domain/repository/category_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final FirebaseFirestore firestore;

  CategoryRepositoryImpl({required this.firestore});

  @override
  Future<Resource> getCategories() async {
    try {
      final categoriesCollection = firestore.collection("categories");

      final querySnapshot = await categoriesCollection.get();

      List<CategoryModel> categories = [];

      querySnapshot.docs.forEach((document) {
        var categoryData = document.data();
        var category = CategoryModel(
          id: document.id,
          name: categoryData['name'],
          type: categoryData['type'],
          bannerImageUrl: categoryData['banner_image_url'],
        );
        categories.add(category);
      });

      return Resource.success(data: categories);
    } catch (e) {
      return Resource.failure(errorMessage: "Something went wrong");
    }
  }
}
