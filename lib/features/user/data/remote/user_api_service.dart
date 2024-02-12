import 'dart:io';

import 'package:alt__wally/core/constants/constants.dart';
import 'package:alt__wally/features/user/data/remote/rest_response.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:alt__wally/features/user/data/remote/user_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'user_api_service.g.dart';

@RestApi(baseUrl: baseUrl)
abstract class UserApiService {
  factory UserApiService(Dio dio) = _UserApiService;

  @Headers({
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer {jwt}',
  })
  @POST('/api/forgot-password')
  Future<HttpResponse<ResetResponse>> forgotPassword({
    @Field("email") String? email,
  });

  @Headers({
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  })
  @POST('/api/register')
  Future<HttpResponse<UserDTO>> register({
    @Field("name") String? name,
    @Field("email") String? email,
    @Field("password") String? password,
  });

  @Headers({
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer {jwt}',
  })
  @POST('/api/login')
  Future<HttpResponse<UserDTO>> login({
    @Field("email") String? email,
    @Field("password") String? password,
  });

  @Headers({
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  })
  @GET('/api/user/{id}/show')
  Future<HttpResponse<UserDTO>> getUser({
    @Path("id") int? userId,
    @Header('Authorization') String? authorizationHeader,
  });

  @Headers({
    'Content-Type': 'multipart/form-data',
    'Accept': 'application/json',
  })
  @MultiPart()
  @POST('/api/user/update')
  Future<HttpResponse<UserDTO>> updateUser(
    @Header('Authorization') String? authorizationHeader,
    @Part() String name,
    @Part() String email,
    @Part() String? password,
  );
}
