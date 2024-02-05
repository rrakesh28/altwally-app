import 'package:alt__wally/features/wallpaper/domain/entities/wallpaper_entity.dart';
import 'package:equatable/equatable.dart';

abstract class WallOfTheMonthState extends Equatable {
  const WallOfTheMonthState();
}

class WallOfTheMonthInitial extends WallOfTheMonthState {
  @override
  List<Object> get props => [];
}

class WallOfTheMonthLoaded extends WallOfTheMonthState {
  final List<WallpaperEntity?> wallpapers;

  const WallOfTheMonthLoaded({required this.wallpapers});

  @override
  List<Object> get props => [wallpapers];
}

class WallOfTheMonthLoadingFailed extends WallOfTheMonthState {
  @override
  List<Object> get props => [];
}
