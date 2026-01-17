import 'package:equatable/equatable.dart';

class LoginRequest extends Equatable {
  final String phoneNumber;
  final String password;
  final int role;

  const LoginRequest({
    required this.phoneNumber,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'password': password,
      'role': role,
    };
  }

  @override
  List<Object> get props => [phoneNumber, password, role];
}
