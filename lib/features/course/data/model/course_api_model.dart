import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entity/course_entity.dart';

part 'course_api_model.g.dart';

@JsonSerializable()
class LectureApiModel extends Equatable {
  final String title;
  final String videoUrl;
  @JsonKey(name: 'public_id')
  final String publicId;
  final bool freePreview;

  const LectureApiModel({
    required this.title,
    required this.videoUrl,
    required this.publicId,
    required this.freePreview,
  });

  factory LectureApiModel.fromJson(Map<String, dynamic> json) =>
      _$LectureApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$LectureApiModelToJson(this);

  LectureEntity toEntity() {
    return LectureEntity(
      title: title,
      videoUrl: videoUrl,
      publicId: publicId,
      freePreview: freePreview,
    );
  }

  factory LectureApiModel.fromEntity(LectureEntity entity) {
    return LectureApiModel(
      title: entity.title,
      videoUrl: entity.videoUrl,
      publicId: entity.publicId,
      freePreview: entity.freePreview,
    );
  }

  @override
  List<Object?> get props => [title, videoUrl, publicId, freePreview];
}

@JsonSerializable()
class StudentApiModel extends Equatable {
  @JsonKey(name: 'studentId')
  final String studentId;
  final String studentName;
  final String studentEmail;
  final String paidAmount;

  const StudentApiModel({
    required this.studentId,
    required this.studentName,
    required this.studentEmail,
    required this.paidAmount,
  });

  factory StudentApiModel.fromJson(Map<String, dynamic> json) =>
      _$StudentApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentApiModelToJson(this);

  StudentEntity toEntity() {
    return StudentEntity(
      studentId: studentId,
      studentName: studentName,
      studentEmail: studentEmail,
      paidAmount: paidAmount,
    );
  }

  factory StudentApiModel.fromEntity(StudentEntity entity) {
    return StudentApiModel(
      studentId: entity.studentId,
      studentName: entity.studentName,
      studentEmail: entity.studentEmail,
      paidAmount: entity.paidAmount,
    );
  }

  @override
  List<Object?> get props => [studentId, studentName, studentEmail, paidAmount];
}

@JsonSerializable()
class CourseApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String courseId;
  final String instructorId;
  final String instructorName;
  final DateTime date;
  final String title;
  final String category;
  final String level;
  final String primaryLanguage;
  final String subtitle;
  final String description;
  final String image;
  final String welcomeMessage;
  @JsonKey(defaultValue: 0.0)
  final double pricing;
  final String objectives;
  final List<StudentApiModel> students;
  final List<LectureApiModel> curriculum;
  final bool isPublished;

  const CourseApiModel({
    required this.courseId,
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

  factory CourseApiModel.fromJson(Map<String, dynamic> json) =>
      _$CourseApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$CourseApiModelToJson(this);

  CourseEntity toEntity() {
    return CourseEntity(
      courseId: courseId,
      instructorId: instructorId,
      instructorName:instructorName,
      date: date,
      title: title,
      category: category,
      level: level,
      primaryLanguage: primaryLanguage,
      subtitle: subtitle,
      description: description,
      image: image,
      welcomeMessage: welcomeMessage,
      pricing: pricing,
      objectives: objectives,
      students: students.map((student) => student.toEntity()).toList(),
      curriculum: curriculum.map((lecture) => lecture.toEntity()).toList(),
      isPublished: isPublished,
    );
  }

  // Helper method to convert a list of CourseApiModels to a list of CourseEntities
  static List<CourseEntity> toEntityList(List<CourseApiModel> apiModels) {
    return apiModels.map((apiModel) => apiModel.toEntity()).toList();
  }

  factory CourseApiModel.fromEntity(CourseEntity entity) {
    return CourseApiModel(
      courseId: entity.courseId,
      instructorId: entity.instructorId,
      instructorName: entity.instructorName,
      date: entity.date,
      title: entity.title,
      category: entity.category,
      level: entity.level,
      primaryLanguage: entity.primaryLanguage,
      subtitle: entity.subtitle,
      description: entity.description,
      image: entity.image,
      welcomeMessage: entity.welcomeMessage,
      pricing: entity.pricing,
      objectives: entity.objectives,
      students: entity.students
          .map((student) => StudentApiModel.fromEntity(student))
          .toList(),
      curriculum: entity.curriculum
          .map((lecture) => LectureApiModel.fromEntity(lecture))
          .toList(),
      isPublished: entity.isPublished,
    );
  }

  @override
  List<Object?> get props => [
    courseId,
    instructorId,
    instructorName,
    date,
    title,
    category,
    level,
    primaryLanguage,
    subtitle,
    description,
    image,
    welcomeMessage,
    pricing,
    objectives,
    students,
    curriculum,
    isPublished,
  ];
}
