import 'package:json_annotation/json_annotation.dart';

import '../model/course_api_model.dart';

part 'get_course_dto.g.dart';

@JsonSerializable()
class GetAllCourseDTO {
  final bool success;
  final int count;
  final List<CourseDTO> data;

  GetAllCourseDTO({
    required this.success,
    required this.count,
    required this.data,
  });

  factory GetAllCourseDTO.fromJson(Map<String, dynamic> json) =>
      _$GetAllCourseDTOFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllCourseDTOToJson(this);
}

@JsonSerializable()
class CourseDTO {
  final String instructorId;
  final String instructorName;
  final String date;
  final String title;
  final String category;
  final String level;
  final String primaryLanguage;
  final String subtitle;
  final String description;
  final String image;
  final String welcomeMessage;
  final double pricing;
  final String objectives;
  final List<StudentApiModel> students;
  final List<LectureApiModel> curriculum;
  final bool isPublished;

  CourseDTO({
    required this.instructorId,
    required this.instructorName,
    required this.date,
    required this.title,
    required this.category,
    required this.level,
    required this.primaryLanguage,
    required this.subtitle,
    required this.description,
    required this.image,
    required this.welcomeMessage,
    required this.pricing,
    required this.objectives,
    required this.students,
    required this.curriculum,
    required this.isPublished,
  });

  factory CourseDTO.fromJson(Map<String, dynamic> json) =>
      _$CourseDTOFromJson(json);

  Map<String, dynamic> toJson() => _$CourseDTOToJson(this);
}
