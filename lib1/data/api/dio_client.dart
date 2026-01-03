
import '../../core/config/api_config.dart';

class DioClient {
  static Dio? _dio;

  static Dio get dio {
    if (_dio == null) {
      _dio = Dio(
        BaseOptions(
          baseUrl: ApiConfig.baseUrl,
          connectTimeout: ApiConfig.connectTimeout,
          receiveTimeout: ApiConfig.receiveTimeout,
          headers: ApiConfig.headers,
        ),
      );

      // Add interceptors
      _dio!.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            // Add auth token to headers
            final storage = GetStorage();
            final token = storage.read('access_token');
            if (token != null) {
              // Check if it's JWT or Token-based auth
              // For Django Token auth, use: Token <token>
              // For JWT auth, use: Bearer <token>
              if (token.length > 50 && !token.contains('.')) {
                // Likely Django Token Authentication
                options.headers['Authorization'] = 'Token $token';
              } else {
                // Likely JWT
                options.headers['Authorization'] = 'Bearer $token';
              }
            }
            print('REQUEST[${options.method}] => PATH: ${options.path}');
            return handler.next(options);
          },
          onResponse: (response, handler) {
            print(
                'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
            return handler.next(response);
          },
          onError: (DioException error, handler) async {
            print(
                'ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}');
            
            // Handle 401 Unauthorized - Token expired
            if (error.response?.statusCode == 401) {
              // Try to refresh token
              final refreshed = await _refreshToken();
              if (refreshed) {
                // Retry the request
                return handler.resolve(await _retry(error.requestOptions));
              }
            }
            
            return handler.next(error);
          },
        ),
      );

      // Add logging interceptor
      _dio!.interceptors.add(LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ));
    }
    return _dio!;
  }

  static Future<bool> _refreshToken() async {
    try {
      final storage = GetStorage();
      final refreshToken = storage.read('refresh_token');
      
      if (refreshToken == null) return false;

      final response = await Dio(BaseOptions(baseUrl: ApiConfig.baseUrl)).post(
        '/api/accounts/token/refresh/',
        data: {'refresh': refreshToken},
      );

      if (response.statusCode == 200) {
        storage.write('access_token', response.data['access']);
        return true;
      }
    } catch (e) {
      print('Token refresh failed: $e');
    }
    return false;
  }

  static Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );

    return dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  static void clearDio() {
    _dio = null;
  }
}
