import 'package:alt__wally/features/wallpaper/domain/entities/wallpaper_entity.dart';
import 'package:equatable/equatable.dart';

abstract class GetFavouriteWallpapersState extends Equatable {
  const GetFavouriteWallpapersState();
}

class GetFavouriteWallpapersInitial extends GetFavouriteWallpapersState {
  @override
  List<Object> get props => [];
}

class GetFavouriteWallpapersLoaded extends GetFavouriteWallpapersState {
  final List<WallpaperEntity?> wallpapers;

  const GetFavouriteWallpapersLoaded({required this.wallpapers});

  @override
  List<Object> get props => [wallpapers];
}

class GetFavouriteWallpapersFailed extends GetFavouriteWallpapersState {
  @override
  List<Object> get props => [];
}
