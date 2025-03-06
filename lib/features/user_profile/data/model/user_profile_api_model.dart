import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shikshalaya/features/user_profile/domain/entity/user_profile_entity.dart';

part 'user_profile_api_model.g.dart';

@JsonSerializable()
class UserProfileApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? userId;
  final String fName;
  final String? image;
  final String phone;
  final String email;
  final String role;

  const UserProfileApiModel({
    this.userId,
    required this.fName,
    this.image,
    required this.phone,
    required this.email,
    required this.role,
  });

  factory UserProfileApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileApiModelToJson(this);

  // Convert API Model to Domain Entity
  UserProfileEntity toEntity() {
    return UserProfileEntity(
      userId: userId,
      fName: fName,
      image: image,
      phone: phone,
      email: email,
      role: role,
    );
  }

  // Convert Domain Entity to API Model
  factory UserProfileApiModel.fromEntity(UserProfileEntity entity) {
    return UserProfileApiModel(
      userId: entity.userId,
      fName: entity.fName,
      image: entity.image,
      phone: entity.phone,
      email: entity.email,
      role: entity.role,
    );
  }

  @override
  List<Object?> get props => [userId, fName, image, phone, email, role];
}
