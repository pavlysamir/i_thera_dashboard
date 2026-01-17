import 'package:dio/dio.dart';
import 'package:i_thera_dashboard/core/cashe/cache_helper.dart';
import 'package:i_thera_dashboard/core/cashe/cashe_constance.dart';

class ApiInterceptor extends Interceptor {
  ApiInterceptor();
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token =
        await CacheHelper.getSecureData(key: CacheConstants.token) ?? '';
    if (token != '') {
      options.headers['Authorization'] = 'Bearer $token';
    }
    //  else {
    //   const String username = '11236180';
    //   const String password = '60-dayfreetrial';
    //   final String basicAuth =
    //       'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    //   options.headers['Authorization'] = basicAuth;
    // }

    options.headers['Content-Type'] = 'application/json';
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Check for token expiration in the www-authenticate header
      if (err.response?.headers.value('www-authenticate') != null &&
          err.response!.headers
              .value('www-authenticate')!
              .contains('invalid_token')) {
        // Token is expired, navigate to login screen
        // navigatorKey.currentState?.pushReplacementNamed();
        CacheHelper.deleteAllSecureData();
        await CacheHelper.delete(key: CacheConstants.userId);

        await CacheHelper.delete(key: CacheConstants.userImage);
        // NavigationService().navigateAndRemoveUntil(Routes.welcomeScreen);
      }
    }
    super.onError(err, handler);
  }
}
