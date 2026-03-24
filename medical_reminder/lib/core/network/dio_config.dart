import 'package:dio/dio.dart';


import 'package:get_storage/get_storage.dart';
import 'package:medical_reminder/core/constants/app_constants.dart';



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
            final storage = GetStorage();
            final token = storage.read(AppConstants.tokenKey);

            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }

            print('REQUEST[${options.method}] => PATH: ${options.path}');
            print('Headers: ${options.headers}');
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

// class DioConfig {
//   static Dio createDio() {
//     final dio = Dio(BaseOptions(
//       baseUrl: 'https://reminder-90sm.onrender.com',
//       connectTimeout: const Duration(seconds: 30),
//       receiveTimeout: const Duration(seconds: 30),
//       sendTimeout: const Duration(seconds: 30),
//     ));
    
//     // Add interceptors
//     dio.interceptors.add(InterceptorsWrapper(
//       onRequest: (options, handler) async {
//         // Add authorization token if available
//         final authController = Get.find<AuthController>();
//         final token = authController.getToken();
//          _printRequestDetails(options);
//         if (token != null) {
//           options.headers['Authorization'] = 'Token $token';
//         }
        
//         // Add content type
//         options.headers['Content-Type'] = 'application/json';
        
//         return handler.next(options);
//       },
//       onError: (error, handler) {
//         // Handle common errors
//         if (error.response?.statusCode == 401) {
//           // Token expired, logout user
//           Get.find<AuthController>().logout();
//           Get.snackbar(
//             'Session Expired',
//             'Please login again',
//             backgroundColor: Colors.red,
//             colorText: Colors.white,
//           );
//         }
//         return handler.next(error);
//       },
//     ));
    
//     return dio;
//   }
//     static void _printRequestDetails(RequestOptions options) {
//     print('\n══════════════════════════════════════════════════════════');
//     print('🚀 HTTP REQUEST');
//     print('══════════════════════════════════════════════════════════');
//     print('📤 Method: ${options.method}');
//     print('🔗 URL: ${options.baseUrl}${options.path}');
//     print('📋 Headers:');
//     options.headers.forEach((key, value) {
//       print('   $key: $value');
//     });
    
//     if (options.data != null) {
//       print('📦 Request Body:');
//       if (options.data is Map) {
//         print('   ${_formatJson(options.data)}');
//       } else if (options.data) {
//         print('   FormData with fields: ${options.data.fields}');
//       } else {
//         print('   ${options.data}');
//       }
//     }
    
//     if (options.queryParameters.isNotEmpty) {
//       print('🔍 Query Parameters:');
//       options.queryParameters.forEach((key, value) {
//         print('   $key: $value');
//       });
//     }
//     print('══════════════════════════════════════════════════════════\n');
//   }
//     static void _printResponseDetails(dynamic response) {
//     print('\n══════════════════════════════════════════════════════════');
//     print('✅ HTTP RESPONSE');
//     print('══════════════════════════════════════════════════════════');
//     print('📥 Status: ${response.statusCode} ${response.statusMessage}');
//     print('🔗 URL: ${response.requestOptions.baseUrl}${response.requestOptions.path}');
//     print('📋 Response Headers:');
//     response.headers.forEach((key, value) {
//       print('   $key: $value');
//     });
    
//     if (response.data != null) {
//       print('📦 Response Body:');
//       if (response.data is Map) {
//         print('   ${_formatJson(response.data)}');
//       } else if (response.data is List) {
//         print('   List with ${response.data.length} items');
//         if (response.data.isNotEmpty && response.data.length <= 5) {
//           response.data.asMap().forEach((index, item) {
//             print('   [$index]: ${_formatJson(item)}');
//           });
//         }
//       } else {
//         print('   ${response.data}');
//       }
//     }
//     print('══════════════════════════════════════════════════════════\n');
//   }

//   static String _formatJson(dynamic data) {
//     try {
//       if (data is Map) {
//         final buffer = StringBuffer();
//         buffer.writeln('{');
//         data.forEach((key, value) {
//           buffer.writeln('  "$key": "$value",');
//         });
//         buffer.write('}');
//         return buffer.toString();
//       }
//       return data.toString();
//     } catch (e) {
//       return data.toString();
//     }
//   }

 

// }