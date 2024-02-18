import 'package:alt__wally/features/wallpaper/domain/entities/wallpaper_entity.dart';
import 'package:equatable/equatable.dart';

abstract class GetPopularWallpapersState extends Equatable {
  const GetPopularWallpapersState();
}

class PopularInitial extends GetPopularWallpapersState {
  @override
  List<Object> get props => [];
}

class PopularLoaded extends GetPopularWallpapersState {
  final List<WallpaperEntity?> wallpapers;

  const PopularLoaded({required this.wallpapers});

  @override
  List<Object> get props => [wallpapers];
}

class PopularFailed extends GetPopularWallpapersState {
  @override
  List<Object> get props => [];
}
