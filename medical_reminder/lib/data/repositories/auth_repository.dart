import 'package:medical_reminder/data/models/auth_model.dart';
import 'package:medical_reminder/data/services/api_service.dart';

class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  Future<RegisterResponse> register(RegisterRequest request) async {
    return await _apiService.register(request);
  }
Future<LoginResponse> login(LoginRequest request) async {
    return await _apiService.login(request);
  }
  Future<LoginResponse> patientLogin(LoginRequest request) async {
    return await _apiService.login(request);
  }

  Future<LoginResponse> caretakerLogin(LoginRequest request) async {
    return await _apiService.caretakerLogin(request);
  }

  Future<LoginResponse> sellerLogin(LoginRequest request) async {
  return await _apiService.login(request);
}

  saveFcmToken(Map<String, String> map) {
    return _apiService.saveFcmToken(map);
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