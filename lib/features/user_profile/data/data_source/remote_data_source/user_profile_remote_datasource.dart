import 'package:dio/dio.dart';
import 'package:shikshalaya/features/user_profile/data/data_source/user_profile_datasource.dart';

import '../../model/user_profile_api_model.dart';

class UserProfileRemoteDataSourceImpl implements UserProfileDataSource {
  final Dio dio;
  final String baseUrl = "http://10.0.2.2:8000/auth/check-auth"; // Direct API Call

  UserProfileRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserProfileApiModel> getUserProfile(String token) async {
    try {
      Response response = await dio.get(
        baseUrl,
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
  Future<UserProfileApiModel> updateUserProfile(String token, UserProfileApiModel user) {
    // TODO: implement updateUserProfile
    throw UnimplementedError();
  }
}