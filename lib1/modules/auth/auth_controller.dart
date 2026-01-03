
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../data/models/api_models.dart';

import '../../data/repo/medical_repo.dart';

import '../../core/routes/app_routes.dart';

class AuthController extends GetxController {
  final MedicalRepository _repository = MedicalRepository();
  final storage = GetStorage();
  
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final selectedRole = 'patient'.obs;
  
  @override
  void onInit() {
    super.onInit();
  }
  
  void checkLoginStatus() {
    final token = storage.read('access_token');
    final role = storage.read('user_role');
    
    if (token != null && role != null) {
      Get.offAllNamed(AppRoutes.HOME);
    } else {
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }
  
  Future<void> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter username and password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }
    
    try {
      isLoading.value = true;
      
      final request = LoginRequest(username: username, password: password);
      // Use the single login endpoint (not patientLogin)
      final response = await _repository.patientLogin(request);
      
      print('API Response: token=${response.token}, userId=${response.userId}, username=${response.username}, role=${response.role}');
      
      // Save token and user info
      storage.write('access_token', response.token);
      storage.write('user_id', response.userId);
      storage.write('username', response.username);
      storage.write('user_role', response.role);
      
      // The role comes directly from the API response
      print('Logged in as: ${response.role}'); // Will print "patient" or "caretaker"
      
      Get.snackbar(
        'Success',
        'Login successful as ${response.role}!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      
      await Future.delayed(const Duration(milliseconds: 500));
      Get.offAllNamed(AppRoutes.HOME);
      
    } catch (e) {
      print('Login Error: $e');
      Get.snackbar(
        'Login Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> register(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all required fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    try {
      isLoading.value = true;
      
      final request = RegisterRequest(
        username: username,
        password: password,
        role: selectedRole.value,
      );
      
      await _repository.register(request);
      
      Get.snackbar(
        'Success',
        'Registration successful! Please login.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      await Future.delayed(const Duration(milliseconds: 500));
      Get.offNamed(AppRoutes.LOGIN);
      
    } catch (e) {
      Get.snackbar(
        'Registration Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  void logout() {
    storage.erase();
    Get.offAllNamed(AppRoutes.LOGIN);
    Get.snackbar(
      'Logged Out',
      'You have been logged out successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }
  
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
  
  void setRole(String role) {
    selectedRole.value = role;
  }
  
  String get userRole => storage.read('user_role') ?? 'patient';
  bool get isPatient => userRole == 'patient';
  bool get isCaretaker => userRole == 'caretaker';
}
// class AuthController extends GetxController {
//   final MedicalRepository _repository = MedicalRepository();
//   final storage = GetStorage();
  
//   final isLoading = false.obs;
//   final isPasswordVisible = false.obs;
//   final selectedRole = 'patient'.obs;
  
//   @override
//   void onInit() {
//     super.onInit();
//     checkLoginStatus();
//   }
  
//   void checkLoginStatus() {
//     final token = storage.read('access_token');
//     final role = storage.read('user_role');
    
//     if (token != null && role != null) {
//       // User is logged in, navigate to home
//       Future.delayed(const Duration(seconds: 2), () {
//         Get.offAllNamed(AppRoutes.HOME);
//       });
//     } else {
//       // Navigate to login
//       Future.delayed(const Duration(seconds: 2), () {
//         Get.offAllNamed(AppRoutes.LOGIN);
//       });
//     }
//   }
  
//   Future<void> login(String username, String password) async {
//     if (username.isEmpty || password.isEmpty) {
//       Get.snackbar(
//         'Error',
//         'Please enter username and password',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return;
//     }
    
//     try {
//       isLoading.value = true;
      
//       final request = LoginRequest(username: username, password: password);
//       LoginResponse response;
      
//       if (selectedRole.value == 'patient') {
//         response = await _repository.patientLogin(request);
//       } else {
//         response = await _repository.caretakerLogin(request);
//       }
      
//       // Save tokens and user info
//       if (response.access != null) {
//         storage.write('access_token', response.access);
//         storage.write('refresh_token', response.refresh);
//         storage.write('user_role', selectedRole.value);
//         storage.write('username', username);
        
//         if (response.user != null) {
//           storage.write('user_id', response.user!.id);
//         }
        
//         Get.snackbar(
//           'Success',
//           'Login successful!',
//           snackPosition: SnackPosition.BOTTOM,
//         );
        
//         Get.offAllNamed(AppRoutes.HOME);
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Login Failed',
//         e.toString(),
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
  
//   Future<void> register(String username, String password, String email) async {
//     if (username.isEmpty || password.isEmpty) {
//       Get.snackbar(
//         'Error',
//         'Please fill all required fields',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return;
//     }
    
//     try {
//       isLoading.value = true;
      
//       final request = RegisterRequest(
//         username: username,
//         password: password,
//         role: selectedRole.value,
//         email: email.isEmpty ? null : email,
//       );
      
//       await _repository.register(request);
      
//       Get.snackbar(
//         'Success',
//         'Registration successful! Please login.',
//         snackPosition: SnackPosition.BOTTOM,
//       );
      
//       Get.back();
//     } catch (e) {
//       Get.snackbar(
//         'Registration Failed',
//         e.toString(),
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
  
//   void logout() {
//     storage.erase();
//     Get.offAllNamed(AppRoutes.LOGIN);
//   }
  
//   void togglePasswordVisibility() {
//     isPasswordVisible.value = !isPasswordVisible.value;
//   }
  
//   void setRole(String role) {
//     selectedRole.value = role;
//   }
// }