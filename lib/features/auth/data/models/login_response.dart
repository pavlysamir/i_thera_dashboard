import 'package:equatable/equatable.dart';

class LoginResponse extends Equatable {
  final String token;
  // Add other fields if necessary based on actual API response

  const LoginResponse({required this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null && json['data']['token'] != null) {
      return LoginResponse(
        token: json['data']['token'],
      );
    } else {
      // Fallback or handle error if structure differs
      return const LoginResponse(token: '');
    }
  }

  @override
  List<Object> get props => [token];
}
