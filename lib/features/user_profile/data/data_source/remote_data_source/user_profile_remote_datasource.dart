import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shikshalaya/app/constants/api_endpoints.dart';
import 'package:shikshalaya/features/user_profile/data/data_source/user_profile_datasource.dart';

import '../../../../../core/error/failure.dart';
import '../../model/user_profile_api_model.dart';

class UserProfileRemoteDataSourceImpl implements UserProfileDataSource {
  final Dio dio;
  UserProfileRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserProfileApiModel> getUserProfile(String token) async {
    try {
      Response response = await dio.get(
        ApiEndpoints.authCheck,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );
      print(response.statusCode);
      if (response.statusCode == 200 && response.data["success"] == true) {
        final userData = response.data["data"]["user"];
        print(userData);
        return UserProfileApiModel.fromJson(userData);
      } else {
        throw Exception(response.data['message'] ?? "Failed to fetch user profile");
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? "Failed to fetch user profile");
    } catch (e) {
      throw Exception("An unexpected error occurred");
    }
  }

  @override
  Future<String> updateUserProfile({
    required String token,
    required UserProfileApiModel user,
    required String currentPassword,
    String? newPassword,
    File? image,
  }) async {
    try {
      print("CHECK HERE");
      Map<String, dynamic> data = {
        "fName": user.fName,
        "phone": user.phone,
        "image": user.image ?? "",
        "password": newPassword ?? "",
        "currentPassword": currentPassword,
      };

      Response response = await dio.put(
        ApiEndpoints.updateProfile,
        data: data,
        options: Options(headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        }),
      );

      if (response.statusCode == 200) {
        return response.data['message'];
      } else {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? "Failed to update profile");
    }
  }
}