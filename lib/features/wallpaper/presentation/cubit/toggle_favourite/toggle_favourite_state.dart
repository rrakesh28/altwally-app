import 'package:equatable/equatable.dart';

abstract class ToggleFavouriteWallpaperState extends Equatable {
  const ToggleFavouriteWallpaperState();
}

class ToggleFavouriteWallpaperInitial extends ToggleFavouriteWallpaperState {
  @override
  List<Object> get props => [];
}

class ToggleFavouriteWallpaperSuccessful extends ToggleFavouriteWallpaperState {
  @override
  List<Object> get props => [];
}

class ToggleFavouriteWallpaperFailed extends ToggleFavouriteWallpaperState {
  @override
  List<Object> get props => [];
}
