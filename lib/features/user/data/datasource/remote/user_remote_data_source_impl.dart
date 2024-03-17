import 'package:alt__wally/core/util/resource.dart';
import 'package:alt__wally/features/user/data/datasource/remote/user_remote_data_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final SupabaseClient supabaseClient;

  UserRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<Resource> getAllUsers() async {
    try {
      final users = await supabaseClient.from('users').select();

      return Resource.success(data: users);
    } catch (e) {
      return Resource.failure(errorMessage: e.toString());
    }
  }
}
