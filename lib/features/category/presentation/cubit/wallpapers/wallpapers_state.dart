import 'package:alt__wally/features/wallpaper/domain/entities/wallpaper_entity.dart';
import 'package:equatable/equatable.dart';

abstract class WallPapersState extends Equatable {
  const WallPapersState();
}

class WallpapersInitial extends WallPapersState {
  @override
  List<Object> get props => [];
}

class WallpapersLoaded extends WallPapersState {
  final List<WallpaperEntity?> wallpapers;

  const WallpapersLoaded({required this.wallpapers});

  @override
  List<Object> get props => [wallpapers];
}

class WallpapersLoadingFailed extends WallPapersState {
  @override
  List<Object> get props => [];
}
