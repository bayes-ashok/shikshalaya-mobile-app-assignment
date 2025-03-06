import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable {
  final String? userId;
  final String fName;
  final String? image;
  final String phone;
  final String email;
  final String role;

  const UserProfileEntity({
    this.userId,
    required this.fName,
    this.image,
    required this.phone,
    required this.email,
    required this.role,
  });

  @override
  List<Object?> get props => [userId, fName, image, phone, email, role];
}
