import 'package:alt__wally/features/wallpaper/domain/entities/wallpaper_entity.dart';
import 'package:equatable/equatable.dart';

abstract class GetRecentlyAddedState extends Equatable {
  const GetRecentlyAddedState();

  GetRecentlyAddedState copyWith({List<WallpaperEntity?>? wallpapers});
}

class Initial extends GetRecentlyAddedState {
  @override
  List<Object> get props => [];

  @override
  GetRecentlyAddedState copyWith({List<WallpaperEntity?>? wallpapers}) {
    return Initial();
  }
}

class Loaded extends GetRecentlyAddedState {
  final List<WallpaperEntity?> wallpapers;

  const Loaded({required this.wallpapers});

  @override
  List<Object> get props => [wallpapers];

  @override
  GetRecentlyAddedState copyWith({List<WallpaperEntity?>? wallpapers}) {
    return Loaded(
      wallpapers: wallpapers ?? this.wallpapers,
    );
  }
}

class Failed extends GetRecentlyAddedState {
  @override
  List<Object> get props => [];

  @override
  GetRecentlyAddedState copyWith({List<WallpaperEntity?>? wallpapers}) {
    return Failed();
  }
}
