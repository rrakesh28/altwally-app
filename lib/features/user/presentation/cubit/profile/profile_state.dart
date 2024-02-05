import 'package:alt__wally/features/user/domain/entities/user_entity.dart';
import 'package:alt__wally/features/wallpaper/domain/entities/wallpaper_entity.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  @override
  List<Object> get props => [];
}

class ProfileLoaded extends ProfileState {
  final UserEntity? user;
  final List<WallpaperEntity?> wallpapers;

  ProfileLoaded({required this.wallpapers, required this.user});

  @override
  List<Object> get props => [wallpapers];
}

class ProfileLoadingFailed extends ProfileState {
  @override
  List<Object> get props => [];
}
