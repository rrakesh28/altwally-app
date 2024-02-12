import 'package:equatable/equatable.dart';

abstract class UpdateUserState extends Equatable {
  const UpdateUserState();
}

class UpdateUserInitial extends UpdateUserState {
  @override
  List<Object> get props => [];
}

class UpdateUserLoading extends UpdateUserState {
  @override
  List<Object> get props => [];
}

class UpdateUserSuccess extends UpdateUserState {
  @override
  List<Object> get props => [];
}

class UpdateUserFailed extends UpdateUserState {
  final Map<String, dynamic>? validationErrors;
  final String errorMessage;

  const UpdateUserFailed({this.validationErrors, required this.errorMessage});

  @override
  List<Object> get props => [validationErrors ?? const {}];
}
