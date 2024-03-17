import 'dart:io';

import 'package:alt__wally/features/category/domain/entities/category_entity.dart';
import 'package:alt__wally/features/category/domain/usecases/get_categories_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final GetCategoriesUseCase getCategoriesUseCase;

  CategoryCubit({
    required this.getCategoriesUseCase,
  }) : super(CategoryInitial());

  Future<void> getCategories({bool fetchFromRemote = false}) async {
    emit(CategoriesLoading());
    try {
      final resource = await getCategoriesUseCase.call(fetchFromRemote);
      if (resource.success) {
        emit(CategoriesLoaded(categories: resource.data));
      } else {
        emit(CategoriesLoadingFailed(errorMessage: resource.errorMessage));
      }
    } on SocketException catch (_) {
      emit(const CategoriesLoadingFailed(errorMessage: 'Login Failed'));
    } catch (e) {
      emit(const CategoriesLoadingFailed(errorMessage: "Login Failed"));
    }
  }
}
