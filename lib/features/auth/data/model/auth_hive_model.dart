import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shikshalaya/app/constants/hive/hive_table_constant.dart';
import 'package:shikshalaya/features/auth/domain/entity/auth_entity.dart';

import 'package:uuid/uuid.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.studentTableId)
class AuthHiveModel extends Equatable {
  @HiveField(0)
  final String? studentId;
  @HiveField(1)
  final String fName;
  @HiveField(2)
  final String? image;
  @HiveField(3)
  final String phone;
  @HiveField(4)
  final String email;
  @HiveField(5)
  final String password;

  AuthHiveModel({
    String? studentId,
    required this.fName,
    this.image,
    required this.phone,
    required this.email,
    required this.password,
  }) : studentId = studentId ?? const Uuid().v4();

  // Initial Constructor
  const AuthHiveModel.initial()
      : studentId = '',
        fName = '',
        image = '',
        phone = '',
        email = '',
        password = '';

  // From Entity
  factory AuthHiveModel.fromEntity(AuthEntity entity) {
    return AuthHiveModel(
      studentId: entity.userId,
      fName: entity.fName,
      image: entity.image,
      phone: entity.phone,
      email: entity.email,
      password: entity.password,
    );
  }

  // To Entity
  AuthEntity toEntity() {
    return AuthEntity(
      userId: studentId,
      fName: fName,
      image: image,
      phone: phone,
      email: email,
      password: password,
    );
  }

  @override
  List<Object?> get props => [studentId, fName, image, email, password];
}
