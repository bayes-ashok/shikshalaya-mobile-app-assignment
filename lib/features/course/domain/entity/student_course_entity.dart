import 'package:equatable/equatable.dart';

class StudentCourseEntity extends Equatable {
  final String courseId;
  final String title;
  final String instructorId;
  final String instructorName;
  final DateTime dateOfPurchase;
  final String image;
  final String id;

  const StudentCourseEntity({
    required this.courseId,
    required this.title,
    required this.instructorId,
    required this.instructorName,
    required this.dateOfPurchase,
    required this.image,
    required this.id,
  });

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
