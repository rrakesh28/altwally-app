import 'package:alt__wally/core/util/resource.dart';
import 'package:alt__wally/features/wallpaper/data/datasource/remote/wallpaper_remote_data_source.dart';
import 'package:alt__wally/features/wallpaper/data/model/wallpaper_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WallpaperRemoteDataSourceImpl implements WallpaperRemoteDataSource {
  final SupabaseClient supabaseClient;

  WallpaperRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<Resource> addWallpaper(WallpaperModel wallpaper) async {
    print('wallpaper');
    print(wallpaper);
    try {
      final response =
          await supabaseClient.from('wallpapers').insert([wallpaper.toJson()]);

      if (response.error != null) {
        return Resource.failure(
            errorMessage:
                'Failed to add wallpaper: ${response.error!.message}');
      } else {
        return Resource.success(data: wallpaper);
      }
    } catch (e) {
      print(e);
      return Resource.failure(errorMessage: 'Failed to add wallpaper: $e');
    }
  }

  @override
  Future<Resource> getFavouriteWallpapers() async {
    try {
      final response = await supabaseClient
          .from('user_favorites')
          .select('wallpaper_id')
          .eq('user_id', supabaseClient.auth.currentUser?.id ?? '');

      final favoriteWallpaperIds = response as List<dynamic>;

      if (favoriteWallpaperIds.isEmpty) {
        return Resource.success(data: []);
      }

      final wallpaperIds = favoriteWallpaperIds
          .map((fav) => fav['wallpaper_id'] as int)
          .toList();

      final favoriteWallpapers = await supabaseClient
          .from('wallpapers')
          .select("wallpapers.*, user(*),category(*)")
          .inFilter('id', wallpaperIds);

      return Resource.success(data: favoriteWallpapers);
    } catch (e) {
      return Resource.failure(errorMessage: "Something went wrong");
    }
  }

  @override
  Future<Resource> getPopularWallpapers() {
    // TODO: implement getPopularWallpapers
    throw UnimplementedError();
  }

  @override
  Future<Resource> getRecentlyAddedWallpapers() async {
    try {
      final wallpapers = await supabaseClient.from('wallpapers').select();

      return Resource.success(data: wallpapers);
    } catch (e) {
      print(e);
      return Resource.failure(errorMessage: "Something went wrong");
    }
  }

  @override
  Future<Resource> getWallOfTheMonth() {
    // TODO: implement getWallOfTheMonth
    throw UnimplementedError();
  }

  @override
  Future<Resource> getWallpapersByCategory(categoryId) {
    // TODO: implement getWallpapersByCategory
    throw UnimplementedError();
  }

  @override
  Future<Resource> getWallpapersByUserId(userId) {
    // TODO: implement getWallpapersByUserId
    throw UnimplementedError();
  }

  @override
  Future<Resource> toggleFavouriteWallpaper(
      WallpaperModel wallpaper, String type) async {
    try {
      if (type == 'add') {
        final existingFavoriteResponse = await supabaseClient
            .from('user_favourites')
            .select()
            .eq('user_id', supabaseClient.auth.currentUser?.id ?? '')
            .eq('wallpaper_id', wallpaper.id!);
        if (existingFavoriteResponse.isNotEmpty) {
          return Resource.success(data: null);
        }
        await supabaseClient.from('user_favourites').upsert({
          'user_id': supabaseClient.auth.currentUser?.id ?? '',
          'wallpaper_id': wallpaper.id!
        });
      } else {
        await supabaseClient
            .from('user_favourites')
            .delete()
            .eq('user_id', supabaseClient.auth.currentUser?.id ?? '')
            .eq('wallpaper_id', wallpaper.id!);
      }
      return Resource.success(data: '');
    } catch (e) {
      print(e);
      return Resource.failure(errorMessage: 'Something went wrong');
    }
  }

  @override
  Future<Resource> getIdsNotInServer(List<String> localIds) async {
    try {
      final wallpapersTable = supabaseClient.from('wallpapers');

      final serverIdsData =
          await wallpapersTable.select('id').inFilter('id', localIds);

      List<String> serverIds = [];
      for (var row in serverIdsData) {
        serverIds.add(row['id']);
      }

      final List<String> idsNotInServer =
          localIds.where((id) => !serverIds.contains(id)).toList();

      return Resource.success(data: idsNotInServer);
    } catch (e) {
      return Resource.failure(errorMessage: 'Error: $e');
    }
  }

  @override
  Future<Resource> getUpdatedRecords(DateTime updatedAt) async {
    try {
      final categoriesTable = supabaseClient.from('wallpapers');

      final data = await categoriesTable
          .select()
          .gt('updated_at', updatedAt.toIso8601String());

      return Resource.success(data: data);
    } catch (e) {
      return Resource.failure(
          errorMessage: 'Failed to get updated records: $e');
    }
  }
}
