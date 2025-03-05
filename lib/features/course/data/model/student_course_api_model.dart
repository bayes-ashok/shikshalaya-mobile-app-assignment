import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entity/student_course_entity.dart';

part 'student_course_api_model.g.dart';

@JsonSerializable()
class StudentCourseApiModel extends Equatable {
  @JsonKey(name: 'courseId')
  final String courseId;

  final String title;

  final String instructorId;

  final String instructorName;

  final DateTime dateOfPurchase;

  @JsonKey(name: 'courseImage')
  final String image;

  @JsonKey(name: '_id')
  final String id;

  const StudentCourseApiModel({
    required this.courseId,
    required this.title,
    required this.instructorId,
    required this.instructorName,
    required this.dateOfPurchase,
    required this.image,
    required this.id,
  });

  factory StudentCourseApiModel.fromJson(Map<String, dynamic> json) => _$StudentCourseApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentCourseApiModelToJson(this);

  StudentCourseEntity toEntity() {
    return StudentCourseEntity(
      courseId: courseId,
      title: title,
      instructorId: instructorId,
      instructorName: instructorName,
      dateOfPurchase: dateOfPurchase,
      image: image,
      id: id,
    );
  }

  factory StudentCourseApiModel.fromEntity(StudentCourseEntity entity) {
    return StudentCourseApiModel(
      courseId: entity.courseId,
      title: entity.title,
      instructorId: entity.instructorId,
      instructorName: entity.instructorName,
      dateOfPurchase: entity.dateOfPurchase,
      image: entity.image,
      id: entity.id,
    );
  }

  @override
  List<Object?> get props => [
    courseId,
    title,
    instructorId,
    instructorName,
    dateOfPurchase,
    image,
    id,
  ];
}
