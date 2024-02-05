import 'package:alt__wally/core/constants/constants.dart';
import 'package:alt__wally/features/category/data/remote/category_dto.dart';
import 'package:alt__wally/features/wallpaper/data/remote/dto/wallpapers_dto.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

part 'category_api_service.g.dart';

@RestApi(baseUrl: baseUrl)
abstract class CategoryApiService {
  factory CategoryApiService(Dio dio) = _CategoryApiService;

  @Headers({
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  })
  @GET('/api/categories')
  Future<HttpResponse<List<CategoryDTO>>> getCategories({
    @Header('Authorization') String? authorizationHeader,
  });

  @Headers({
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  })
  @GET('/api/categories/{category}/wallpapers')
  Future<HttpResponse<WallpapersDto>> getWallpapers({
    @Header('Authorization') String? authorizationHeader,
    @Path('category') int? categoryId,
  });
}
