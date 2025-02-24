// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LectureApiModel _$LectureApiModelFromJson(Map<String, dynamic> json) =>
    LectureApiModel(
      title: json['title'] as String,
      videoUrl: json['videoUrl'] as String,
      publicId: json['public_id'] as String,
      freePreview: json['freePreview'] as bool,
    );

Map<String, dynamic> _$LectureApiModelToJson(LectureApiModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'videoUrl': instance.videoUrl,
      'public_id': instance.publicId,
      'freePreview': instance.freePreview,
    };

StudentApiModel _$StudentApiModelFromJson(Map<String, dynamic> json) =>
    StudentApiModel(
      studentId: json['studentId'] as String,
      studentName: json['studentName'] as String,
      studentEmail: json['studentEmail'] as String,
      paidAmount: json['paidAmount'] as String,
    );

Map<String, dynamic> _$StudentApiModelToJson(StudentApiModel instance) =>
    <String, dynamic>{
      'studentId': instance.studentId,
      'studentName': instance.studentName,
      'studentEmail': instance.studentEmail,
      'paidAmount': instance.paidAmount,
    };

CourseApiModel _$CourseApiModelFromJson(Map<String, dynamic> json) =>
    CourseApiModel(
      courseId: json['_id'] as String?,
      instructorId: json['instructorId'] as String,
      instructorName: json['instructorName'] as String,
      date: DateTime.parse(json['date'] as String),
      title: json['title'] as String,
      category: json['category'] as String,
      level: json['level'] as String,
      primaryLanguage: json['primaryLanguage'] as String,
      subtitle: json['subtitle'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      welcomeMessage: json['welcomeMessage'] as String,
      pricing: (json['pricing'] as num?)?.toDouble() ?? 0.0,
      objectives: json['objectives'] as String,
      students: (json['students'] as List<dynamic>)
          .map((e) => StudentApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      curriculum: (json['curriculum'] as List<dynamic>)
          .map((e) => LectureApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      isPublished: json['isPublished'] as bool,
    );

Map<String, dynamic> _$CourseApiModelToJson(CourseApiModel instance) =>
    <String, dynamic>{
      '_id': instance.courseId,
      'instructorId': instance.instructorId,
      'instructorName': instance.instructorName,
      'date': instance.date.toIso8601String(),
      'title': instance.title,
      'category': instance.category,
      'level': instance.level,
      'primaryLanguage': instance.primaryLanguage,
      'subtitle': instance.subtitle,
      'description': instance.description,
      'image': instance.image,
      'welcomeMessage': instance.welcomeMessage,
      'pricing': instance.pricing,
      'objectives': instance.objectives,
      'students': instance.students,
      'curriculum': instance.curriculum,
      'isPublished': instance.isPublished,
    };
