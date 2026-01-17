import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../models/doctor_model.dart';
import '../models/paginated_response.dart';

abstract class HomeRepository {
  Future<Either<Failure, PaginatedResponse<DoctorModel>>> getDoctors({
    required int pageNumber,
    int pageSize = 13,
  });
}
