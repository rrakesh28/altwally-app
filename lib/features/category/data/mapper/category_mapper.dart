import 'package:alt__wally/features/category/data/remote/category_dto.dart';
import 'package:alt__wally/features/category/domain/entities/category_entity.dart';

CategoryEntity categoryDtoToCategoryEntity(CategoryDTO categoryDto) {
  return CategoryEntity(
    id: categoryDto.id,
    name: categoryDto.name,
    bannerImageUrl: categoryDto.bannerImageUrl,
    type: categoryDto.type,
    createdAt: categoryDto.createdAt,
    updatedAt: categoryDto.updatedAt,
  );
}
