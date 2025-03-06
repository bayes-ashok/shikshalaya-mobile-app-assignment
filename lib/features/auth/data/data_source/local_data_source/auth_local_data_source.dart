import 'dart:io';

import 'package:shikshalaya/core/network/hive_service.dart';
import 'package:shikshalaya/features/auth/data/data_source/auth_data_sorce.dart';
import 'package:shikshalaya/features/auth/data/model/auth_hive_model.dart';
import 'package:shikshalaya/features/auth/domain/entity/auth_entity.dart';

class AuthLocalDataSource implements IAuthDataSource {
  final HiveService _hiveService;

  AuthLocalDataSource(this._hiveService);

  @override
  Future<AuthEntity> getCurrentUser() {
    return Future.value(AuthEntity(
      userId: "1",
      fName: "",
      image: null,
      phone: "",
      email: "",
      password: "",
    ));
  }

  @override
  Future<String> loginStudent(String email, String password) async {
    try {
      await _hiveService.login(email, password);
      return Future.value("Success");
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<void> registerStudent(AuthEntity student) async {
    try {
      final authHiveModel = AuthHiveModel.fromEntity(student);

      await _hiveService.register(authHiveModel);
      return Future.value();
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<String> uploadProfilePicture(File file) {
    throw UnimplementedError();
  }
}
