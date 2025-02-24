// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_course_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllCourseDTO _$GetAllCourseDTOFromJson(Map<String, dynamic> json) =>
    GetAllCourseDTO(
      success: json['success'] as bool,
      count: (json['count'] as num).toInt(),
      data: (json['data'] as List<dynamic>)
          .map((e) => CourseDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetAllCourseDTOToJson(GetAllCourseDTO instance) =>
    <String, dynamic>{
      'success': instance.success,
      'count': instance.count,
      'data': instance.data,
    };

CourseDTO _$CourseDTOFromJson(Map<String, dynamic> json) => CourseDTO(
      instructorId: json['instructorId'] as String,
      instructorName: json['instructorName'] as String,
      date: json['date'] as String,
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

Map<String, dynamic> _$CourseDTOToJson(CourseDTO instance) => <String, dynamic>{
      'instructorId': instance.instructorId,
      'instructorName': instance.instructorName,
      'date': instance.date,
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
