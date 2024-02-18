import 'package:alt__wally/features/wallpaper/domain/entities/wallpaper_entity.dart';
import 'package:equatable/equatable.dart';

abstract class GetRecentlyAddedState extends Equatable {
  const GetRecentlyAddedState();
}

class Initial extends GetRecentlyAddedState {
  @override
  List<Object> get props => [];
}

class Loaded extends GetRecentlyAddedState {
  final List<WallpaperEntity?> wallpapers;

  const Loaded({required this.wallpapers});

  @override
  List<Object> get props => [wallpapers];
}

class Failed extends GetRecentlyAddedState {
  @override
  List<Object> get props => [];
}
