import 'dart:io';

import 'package:dio/dio.dart';

import '../model/user_profile_api_model.dart';

abstract class UserProfileDataSource {
  Future<UserProfileApiModel> getUserProfile(String token);
  Future<String> updateUserProfile({
    required String token,
    required UserProfileApiModel user,
    required String currentPassword,
    String? newPassword,
    File? image,
  });
}
