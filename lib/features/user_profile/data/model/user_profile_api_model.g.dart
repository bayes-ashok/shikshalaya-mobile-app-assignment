// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileApiModel _$UserProfileApiModelFromJson(Map<String, dynamic> json) =>
    UserProfileApiModel(
      userId: json['_id'] as String?,
      fName: json['fName'] as String,
      image: json['image'] as String?,
      phone: json['phone'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$UserProfileApiModelToJson(
        UserProfileApiModel instance) =>
    <String, dynamic>{
      '_id': instance.userId,
      'fName': instance.fName,
      'image': instance.image,
      'phone': instance.phone,
      'email': instance.email,
      'role': instance.role,
    };
