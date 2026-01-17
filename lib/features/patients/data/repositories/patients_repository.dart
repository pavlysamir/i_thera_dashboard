import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../models/patients_response.dart';

abstract class PatientsRepository {
  Future<Either<Failure, PatientsResponse>> getPatients({
    required int pageNumber,
    required int pageSize,
  });
}

