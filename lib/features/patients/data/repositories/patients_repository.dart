import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../models/patients_response.dart';

abstract class PatientsRepository {
  Future<Either<Failure, PatientsResponse>> getPatients({
    required int pageNumber,
    required int pageSize,
    String? patientName,
  });

  Future<Either<Failure, Unit>> approveOrDisapprove({
    required int userId,
    required int role,
    required bool isApproved,
    String? adminNote,
  });
}

