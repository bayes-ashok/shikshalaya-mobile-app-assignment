import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shikshalaya/features/auth/domain/entity/auth_entity.dart';

part 'auth_api_model.g.dart';

@JsonSerializable()
class AuthApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? studentId;
  final String fName;
  final String? image;
  final String phone;
  final String email;
  final String? password;

  const AuthApiModel({
    this.studentId,
    required this.fName,
    this.image,
    required this.phone,
    required this.email,
    this.password,
  });

  factory AuthApiModel.fromJson(Map<String, dynamic> json) =>
      _$AuthApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthApiModelToJson(this);

  // To Entity
  AuthEntity toEntity() {
    return AuthEntity(
      userId: studentId,
      fName: fName,
      image: image,
      phone: phone,
      email: email,
      password: password ?? '',
    );
  }

  // From Entity
  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      fName: entity.fName,
      image: entity.image,
      phone: entity.phone,
      email: entity.email,
      password: entity.password,
    );
  }

  @override
  List<Object?> get props => [studentId, fName, image, phone, email, password];
}
