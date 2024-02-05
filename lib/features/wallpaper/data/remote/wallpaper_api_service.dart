import 'dart:io';

import 'package:alt__wally/core/constants/constants.dart';
import 'package:alt__wally/features/wallpaper/data/remote/dto/wallpapers_dto.dart';
import 'package:alt__wally/features/wallpaper/data/remote/wallpaper_dto.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

part 'wallpaper_api_service.g.dart';

@RestApi(baseUrl: baseUrl)
abstract class WallpaperApiService {
  factory WallpaperApiService(Dio dio) = _WallpaperApiService;

  @Headers({
    'Content-Type': 'multipart/form-data',
    'Accept': 'application/json',
  })
  @MultiPart()
  @POST('/api/wallpaper/store')
  Future<HttpResponse<WallpaperDTO>> addWallpaper(
    @Header('Authorization') String? authorizationHeader,
    @Part() int? categoryId,
    @Part() String? title,
    @Part() File image,
    @Part() int? size,
    @Part() int? height,
    @Part() int? width,
  );

  @Headers({
    'Accept': 'application/json',
  })
  @GET('/api/wallpaper/{user_id}/user')
  Future<HttpResponse<WallpapersDto>> getWallpapersByUserId(
    @Header('Authorization') String? authorizationHeader,
    @Path('user_id') int? userId,
  );

  @Headers({
    'Accept': 'application/json',
  })
  @GET('/api/wallpaper/wall-of-month')
  Future<HttpResponse<WallpapersDto>> getWallOfTheMonth(
    @Header('Authorization') String? authorizationHeader,
  );

  @Headers({
    'Accept': 'application/json',
  })
  @GET('/api/wallpaper/favourites')
  Future<HttpResponse<WallpapersDto>> getFavouriteWallpapers(
    @Header('Authorization') String? authorizationHeader,
  );

  @Headers({
    'Accept': 'application/json',
  })
  @POST('/api/wallpaper/favourites/{wallpaper}/toggle')
  Future<HttpResponse<WallpaperDTO>> toggleFavouriteWallpaper(
    @Header('Authorization') String? authorizationHeader,
    @Path('wallpaper') int? wallpaperId,
  );
}
