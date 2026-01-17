import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';

abstract class AuthRepository {
  Future<Either<Failure, LoginResponse>> login(LoginRequest request);
}
