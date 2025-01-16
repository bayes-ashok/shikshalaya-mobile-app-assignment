import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? userId;
  final String fName;
  final String? image;
  final String phone;
  final String email;
  final String password;

  const AuthEntity({
    this.userId,
    required this.fName,
    this.image,
    required this.phone,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [userId, fName, image, phone, email, password];
}
