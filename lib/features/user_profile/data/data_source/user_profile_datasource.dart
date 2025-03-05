import 'package:dio/dio.dart';

import '../model/user_profile_api_model.dart';

abstract class UserProfileDataSource {
  Future<UserProfileApiModel> getUserProfile(String token);
  Future<UserProfileApiModel> updateUserProfile(String token, UserProfileApiModel user);
}
