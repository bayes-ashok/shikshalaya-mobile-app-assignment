// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthApiModel _$AuthApiModelFromJson(Map<String, dynamic> json) => AuthApiModel(
      studentId: json['_id'] as String?,
      fName: json['fName'] as String,
      image: json['image'] as String?,
      phone: json['phone'] as String,
      email: json['email'] as String,
      password: json['password'] as String?,
    );

Map<String, dynamic> _$AuthApiModelToJson(AuthApiModel instance) =>
    <String, dynamic>{
      '_id': instance.studentId,
      'fName': instance.fName,
      'image': instance.image,
      'phone': instance.phone,
      'email': instance.email,
      'password': instance.password,
    };
