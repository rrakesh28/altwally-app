part of 'add_wallpaper_cubit.dart';

abstract class AddWallpaperState extends Equatable {
  const AddWallpaperState();
}

class AddWallpaperInitial extends AddWallpaperState {
  @override
  List<Object> get props => [];
}

class AddWallpaperLoading extends AddWallpaperState {
  @override
  List<Object> get props => [];
}

class AddWallpaperSuccess extends AddWallpaperState {
  @override
  List<Object> get props => [];
}

class AddWallpaperFailed extends AddWallpaperState {
  final Map<String, dynamic>? validationErrors;
  final String errorMessage;

  const AddWallpaperFailed({required this.errorMessage, this.validationErrors});

  @override
  List<Object> get props => [];
}
