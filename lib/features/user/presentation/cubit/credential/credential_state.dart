part of 'credential_cubit.dart';

abstract class CredentialState extends Equatable {
  const CredentialState();
}

class CredentialInitial extends CredentialState {
  @override
  List<Object> get props => [];
}

class LoginLoading extends CredentialState {
  @override
  List<Object> get props => [];
}

class LoginSuccess extends CredentialState {
  @override
  List<Object> get props => [];
}

class LoginFailed extends CredentialState {
  final Map<String, dynamic>? validationErrors;
  final String errorMessage;

  const LoginFailed({this.validationErrors, required this.errorMessage});

  @override
  List<Object> get props => [validationErrors ?? const {}];
}

class RegisterLoading extends CredentialState {
  @override
  List<Object> get props => [];
}

class RegisterSuccess extends CredentialState {
  @override
  List<Object> get props => [];
}

class RegisterFailed extends CredentialState {
  final Map<String, dynamic>? validationErrors;
  final String errorMessage;

  const RegisterFailed({this.validationErrors, required this.errorMessage});

  @override
  List<Object> get props => [validationErrors ?? const {}];
}
