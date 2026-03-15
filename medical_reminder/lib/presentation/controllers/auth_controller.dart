import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:medical_reminder/core/constants/app_constants.dart';
import 'package:medical_reminder/core/routes/app_pages.dart';
import 'package:medical_reminder/data/repositories/auth_repository.dart';
import 'package:medical_reminder/data/models/auth_model.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository;
  final _storage = GetStorage();
  
  AuthController(this._authRepository);
  
  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;
  final RxString authToken = RxString('');
  final RxInt userId = RxInt(0);
  final RxString username = RxString('');
  final RxString userRole = RxString('');
  final Rx<User?> currentUser = Rx<User?>(null);
  // final medicineController = Get.find<MedicineController>();
  // final reminderController = Get.find<ReminderController>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final RxString selectedRole = AppConstants.patientRole.obs;
  
  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }
    Future<void> checkLoginStatus() async {
    print('📦 Storage check:');
    print('Token: ${_storage.read(AppConstants.tokenKey)}');
    print('User ID: ${_storage.read('user_id')}');
    print('Username: ${_storage.read('username')}');
    print('Role: ${_storage.read(AppConstants.roleKey)}');
    
    final token = _storage.read(AppConstants.tokenKey);
    final storedUserId = _storage.read('user_id');
    final storedUsername = _storage.read('username');
    final role = _storage.read(AppConstants.roleKey);
    
    if (token != null && storedUserId != null) {
      isLoggedIn.value = true;
      authToken.value = token;
      userId.value = storedUserId;
      username.value = storedUsername ?? '';
      userRole.value = role ?? '';
      
      currentUser.value = User(
        id: storedUserId,
        username: storedUsername ?? '',
        role: role ?? '',
      );
      
      print('✅ User is logged in: ${currentUser.value?.username}');
    } else {
      print('❌ No user found in storage');
      isLoggedIn.value = false;
    }
  }
//  void checkLoginStatus() {
//   print('📦 Storage check:');
//   print('Token: ${_storage.read(AppConstants.tokenKey)}');
//   print('User ID: ${_storage.read('user_id')}');
//   print('Username: ${_storage.read('username')}');
//   print('Role: ${_storage.read(AppConstants.roleKey)}');
//   final token = _storage.read(AppConstants.tokenKey);
//   final userId = _storage.read('user_id');
//   final username = _storage.read('username');
//   final role = _storage.read(AppConstants.roleKey);
  
//   if (token != null && userId != null) {
//     isLoggedIn.value = true;
//     authToken.value = token;
//     this.userId.value = userId;
//     this.username.value = username ?? '';
//     userRole.value = role ?? '';
    
//     // ✅ CRITICAL: Set currentUser from storage
//     currentUser.value = User(
//       id: userId,
//       username: username ?? '',
//       role: role ?? '',
//     );
//   }
// }
  
//   Future<void> login({required bool isPatient}) async {
//   try {
//     isLoading.value = true;
    
//     final request = LoginRequest(
//       username: usernameController.text.trim(),
//       password: passwordController.text,
//     );
    
//     print('🔐 Login request: ${request.toJson()}');
    
//     final response = isPatient
//         ? await _authRepository.patientLogin(request)
//         : await _authRepository.caretakerLogin(request);
    
//     print('✅ Login response: ${response.toJson()}');
//     currentUser.value = User(
//       id:response.userId,
//       username: response.username,
//       role: response.role
//     );
//     // Save token and user data
//     await _storage.write(AppConstants.tokenKey, response.token);
//     await _storage.write('user_id', response.userId);
//     await _storage.write('username', response.username);
//     await _storage.write(AppConstants.roleKey, response.role);
    
//     authToken.value = response.token;
//     userId.value = response.userId;
//     username.value = response.username;
//     userRole.value = response.role;
//     isLoggedIn.value = true;
    
//     // Clear controllers
//     usernameController.clear();
//     passwordController.clear();
//     // medicineController.fetchMedicines();
//     // reminderController.fetchReminders();
//     Get.offAllNamed('/dashboard');
    
//   } catch (e) {
//     print('❌ Login error: $e');
//     Get.snackbar(
//       'Login Failed',
//       'Invalid credentials or network error',
//       backgroundColor: Colors.red,
//       colorText: Colors.white,
//     );
//   } finally {
//     isLoading.value = false;
//   }
Future<void> login({required String role}) async {
  try {
    isLoading.value = true;

    final request = LoginRequest(
      username: usernameController.text.trim(),
      password: passwordController.text,
    );

    late LoginResponse response;

    if (role == AppConstants.patientRole) {
      response = await _authRepository.patientLogin(request);
    } else if (role == AppConstants.caretakerRole) {
      response = await _authRepository.caretakerLogin(request);
    } else {
      response = await _authRepository.sellerLogin(request);
    }

    await _handleLoginSuccess(response);

    Get.offAllNamed(AppPages.dashboard);

  } catch (e) {
    Get.snackbar("Login Failed", "Invalid credentials or network error");
    log(e.toString());
  } finally {
    isLoading.value = false;
  }
}

Future<void> _handleLoginSuccess(LoginResponse response) async {
  await _storage.write(AppConstants.tokenKey, response.token);
  await _storage.write('user_id', response.userId);
  await _storage.write('username', response.username);
  await _storage.write(AppConstants.roleKey, response.role);

  authToken.value = response.token;
  userId.value = response.userId;
  username.value = response.username;
  userRole.value = response.role;
  isLoggedIn.value = true;
}

// }
  Future<void> register() async {
    try {
      if (passwordController.text != confirmPasswordController.text) {
        Get.snackbar(
          'Error',
          'Passwords do not match',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      
      isLoading.value = true;
      
      final request = RegisterRequest(
        username: usernameController.text.trim(),
        password: passwordController.text,
        role: selectedRole.value,
      );
      log("register request: ${request.toJson()}");
      final response = await _authRepository.register(request);
      currentUser.value = User(
                id: response.id,
                username: response.username,
                role: response.role,
       );
      // After successful registration, auto login
      await login(role: selectedRole.value);
      
    } catch (e) {
      log("register error: ${e.toString()}");
      Get.snackbar(
        'Registration Failed',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> logout() async {
    await _storage.erase();
    isLoggedIn.value = false;
    authToken.value = '';
    userId.value = 0;
    username.value = '';
    userRole.value = '';
    Get.offAllNamed('/');
  }
  
  String? getToken() {
    return authToken.value.isNotEmpty ? authToken.value : null;
  }
  
  String getFormattedToken() {
    final token = getToken();
    return token != null ? 'Token $token' : '';
  }
  
  bool isPatient() {
    return userRole.value == AppConstants.patientRole;
  }
  
  bool isCaretaker() {
    return userRole.value == AppConstants.caretakerRole;
  }
  
  String? getFirebaseUserId() {
    // Generate a simple Firebase ID from user data
    if (userId.value > 0) {
      return 'user_${userId.value}_${username.value}';
    }
    return null;
  }
}

