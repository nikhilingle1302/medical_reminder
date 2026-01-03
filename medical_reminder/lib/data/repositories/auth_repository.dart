import 'package:medical_reminder/data/models/auth_model.dart';
import 'package:medical_reminder/data/services/api_service.dart';


// In lib/data/repositories/auth_repository.dart
import 'package:medical_reminder/data/models/auth_model.dart';
import 'package:medical_reminder/data/services/api_service.dart';

class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  Future<User> register(RegisterRequest request) async {
    return await _apiService.register(request);
  }

  Future<LoginResponse> patientLogin(LoginRequest request) async {
    return await _apiService.patientLogin(request);
  }

  Future<LoginResponse> caretakerLogin(LoginRequest request) async {
    return await _apiService.caretakerLogin(request);
  }
}
// class AuthRepository {
//   final ApiService _apiService;

//   AuthRepository(this._apiService);

//   Future<AuthResponse> register(RegisterRequest request) async {
//     return await _apiService.register(request);
//   }

//   Future<AuthResponse> patientLogin(LoginRequest request) async {
//     return await _apiService.patientLogin(request);
//   }

//   Future<AuthResponse> caretakerLogin(LoginRequest request) async {
//     return await _apiService.caretakerLogin(request);
//   }
// }