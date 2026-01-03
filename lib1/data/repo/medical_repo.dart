import 'package:dio/dio.dart';

import '../api/api_client.dart';
import '../api/dio_client.dart';
import '../models/api_models.dart';


class MedicalRepository {
  late final ApiClient _apiClient;

  MedicalRepository() {
    _apiClient = ApiClient(DioClient.dio);
  }

  // Auth Methods
  Future<User> register(RegisterRequest request) async {
    try {
      return await _apiClient.register(request);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<LoginResponse> patientLogin(LoginRequest request) async {
    try {
      return await _apiClient.patientLogin(request);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<LoginResponse> caretakerLogin(LoginRequest request) async {
    try {
      return await _apiClient.caretakerLogin(request);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Medicine Methods
  Future<List<Medicine>> getMedicines() async {
    try {
      return await _apiClient.getMedicines();
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Reminder Methods
  Future<List<Reminder>> getReminders() async {
    try {
      return await _apiClient.getReminders();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Reminder> createReminder(CreateReminderRequest request) async {
    try {
      return await _apiClient.createReminder(request);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Reminder> updateReminder(
      int id, CreateReminderRequest request) async {
    try {
      return await _apiClient.updateReminder(id, request);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteReminder(int id) async {
    try {
      return await _apiClient.deleteReminder(id);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Reminder> markReminderTaken(int id) async {
    try {
      return await _apiClient.markReminderTaken(id);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // FCM Methods
  Future<void> saveFcmToken(String token) async {
    try {
      return await _apiClient.saveFcmToken({'token': token});
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> testFcm() async {
    try {
      return await _apiClient.testFcm();
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Error Handler
  String _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Connection timeout. Please check your internet connection.';
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final message = error.response?.data['message'] ??
              error.response?.data['detail'] ??
              'Server error occurred';
          
          switch (statusCode) {
            case 400:
              return 'Bad request: $message';
            case 401:
              return 'Unauthorized. Please login again.';
            case 403:
              return 'Access forbidden: $message';
            case 404:
              return 'Resource not found: $message';
            case 500:
              return 'Internal server error. Please try again later.';
            default:
              return message;
          }
        case DioExceptionType.cancel:
          return 'Request cancelled';
        case DioExceptionType.unknown:
          return 'Network error. Please check your connection.';
        default:
          return 'An unexpected error occurred';
      }
    }
    return error.toString();
  }
}