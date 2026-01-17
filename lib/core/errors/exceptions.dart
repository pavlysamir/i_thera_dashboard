import 'package:dio/dio.dart';
import 'package:i_thera_dashboard/core/errors/error_model.dart';

class ServerException implements Exception {
  final ErrorModel? errModel;

  ServerException({this.errModel});
}

void handleDioExceptions(DioException? e) {
  final responseData = e?.response?.data;
  final errorModel = ErrorModel.fromJson(
    responseData is Map<String, dynamic> ? responseData : null,
  );

  switch (e?.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.badCertificate:
    case DioExceptionType.cancel:
    case DioExceptionType.connectionError:
    case DioExceptionType.unknown:
      throw ServerException(errModel: errorModel);

    case DioExceptionType.badResponse:
      final statusCode = e?.response?.statusCode;

      if (statusCode != null &&
          [400, 401, 403, 404, 409, 422, 504].contains(statusCode)) {
        throw ServerException(errModel: errorModel);
      } else {
        throw ServerException(
          errModel: ErrorModel(
            errorMessage: 'Unexpected server response',
            errors: [
              'Unexpected server response with status code: $statusCode',
            ],
          ),
        );
      }

    default:
      throw ServerException(
        errModel: ErrorModel(
          errorMessage: 'Unknown Dio error occurred',
          errors: ['Unknown Dio error'],
        ),
      );
  }
}
