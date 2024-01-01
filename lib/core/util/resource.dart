import 'package:dio/dio.dart';

class Resource {
  final bool success;
  final String errorMessage;
  final dynamic data;
  final Map<String, dynamic>? validationErrors;
  final DioException? dioException;

  Resource(
      {required this.success,
      required this.errorMessage,
      this.dioException,
      this.data,
      this.validationErrors});

  factory Resource.success({required dynamic data}) {
    return Resource(
        success: true, data: data, errorMessage: '', dioException: null);
  }

  factory Resource.failure(
      {required String errorMessage,
      Map<String, dynamic>? validationErrors,
      DioException? dioException}) {
    return Resource(
        success: false,
        errorMessage: errorMessage,
        validationErrors: validationErrors,
        dioException: dioException);
  }
}
