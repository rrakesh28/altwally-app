import 'package:alt__wally/features/wallpaper/domain/entities/wallpaper_entity.dart';
import 'package:equatable/equatable.dart';

abstract class GetWallpapersState extends Equatable {
  const GetWallpapersState();
}

class Initial extends GetWallpapersState {
  @override
  List<Object> get props => [];
}

class Loaded extends GetWallpapersState {
  final List<WallpaperEntity?> wallpapers;

  const Loaded({required this.wallpapers});

  @override
  List<Object> get props => [wallpapers];
}

class Failed extends GetWallpapersState {
  @override
  List<Object> get props => [];
}
