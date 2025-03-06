import 'package:equatable/equatable.dart';

class LectureEntity extends Equatable {
  final String title;
  final String videoUrl;
  final String publicId;
  final bool freePreview;

  const LectureEntity({
    required this.title,
    required this.videoUrl,
    required this.publicId,
    required this.freePreview,
  });

  @override
  List<Object?> get props => [title, videoUrl, publicId, freePreview];
}

class StudentEntity extends Equatable {
  final String studentId;
  final String studentName;
  final String studentEmail;
  final String paidAmount;

  const StudentEntity({
    required this.studentId,
    required this.studentName,
    required this.studentEmail,
    required this.paidAmount,
  });

  @override
  List<Object?> get props => [studentId, studentName, studentEmail, paidAmount];
}

class CourseEntity extends Equatable {
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
  final double pricing;
  final String objectives;
  final List<StudentEntity> students;
  final List<LectureEntity> curriculum;
  final bool isPublished;

  const CourseEntity({
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
    isPublished
  ];
}
