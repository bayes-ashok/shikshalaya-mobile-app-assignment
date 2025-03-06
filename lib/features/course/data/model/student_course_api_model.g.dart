// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_course_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentCourseApiModel _$StudentCourseApiModelFromJson(
        Map<String, dynamic> json) =>
    StudentCourseApiModel(
      courseId: json['courseId'] as String,
      title: json['title'] as String,
      instructorId: json['instructorId'] as String,
      instructorName: json['instructorName'] as String,
      dateOfPurchase: DateTime.parse(json['dateOfPurchase'] as String),
      image: json['courseImage'] as String,
      id: json['_id'] as String,
    );

Map<String, dynamic> _$StudentCourseApiModelToJson(
        StudentCourseApiModel instance) =>
    <String, dynamic>{
      'courseId': instance.courseId,
      'title': instance.title,
      'instructorId': instance.instructorId,
      'instructorName': instance.instructorName,
      'dateOfPurchase': instance.dateOfPurchase.toIso8601String(),
      'courseImage': instance.image,
      '_id': instance.id,
    };
