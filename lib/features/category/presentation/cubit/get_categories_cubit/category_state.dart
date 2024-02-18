part of 'category_cubit.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();
}

class CategoryInitial extends CategoryState {
  @override
  List<Object> get props => [];
}

class CategoriesLoading extends CategoryState {
  @override
  List<Object> get props => [];
}

class CategoriesLoaded extends CategoryState {
  final List<CategoryEntity> categories;

  const CategoriesLoaded({required this.categories});
  @override
  List<Object> get props => [categories];
}

class CategoriesLoadingFailed extends CategoryState {
  final String errorMessage;

  const CategoriesLoadingFailed({required this.errorMessage});

  @override
  List<Object> get props => [];
}
