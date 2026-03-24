import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final RxString selectedRole = AppConstants.patientRole.obs;
  
  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }
Future<void> checkLoginStatus() async {
  final token = _storage.read<String>(AppConstants.tokenKey);
  final storedUserId = _storage.read<int>('user_id');      // ✅ typed read
  final storedUsername = _storage.read<String>('username');
  final role = _storage.read<String>(AppConstants.roleKey);

  if (token != null && token.isNotEmpty && storedUserId != null) {
    isLoggedIn.value = true;
    authToken.value = token;
    userId.value = storedUserId;
    username.value = storedUsername ?? '';
    userRole.value = role ?? '';

    currentUser.value = User(
      id: storedUserId,
      username: storedUsername ?? '',
      role: role ?? '',
      email: '',
    );

    print('✅ User is logged in: ${currentUser.value?.username}, role: $role');
  } else {
    // ✅ Explicitly clear everything if storage is incomplete
    isLoggedIn.value = false;
    authToken.value = '';
    userId.value = 0;
    username.value = '';
    userRole.value = '';
    currentUser.value = null;
    print('❌ No valid session found');
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
Future<void> login({String? roleHint}) async {
  try {
    isLoading.value = true;

    final request = LoginRequest(
      username: usernameController.text.trim(),
      password: passwordController.text,
    );

    // ✅ Single endpoint now — role comes from API response
    final response = await _authRepository.login(request);

    await _handleLoginSuccess(response);

    Get.offAllNamed(AppPages.dashboard);

  } catch (e) {
    log("❌ Login error: $e");
    Get.snackbar(
      "Login Failed",
      "Invalid credentials or network error",
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    isLoading.value = false;
  }
}


Future<void> _handleLoginSuccess(LoginResponse response) async {
  await _storage.write(AppConstants.tokenKey, response.tokens.access);
  await _storage.write(AppConstants.refreshKey, response.tokens.refresh);
  await _storage.write('user_id', response.user.id);
  await _storage.write('username', response.user.username);
  await _storage.write(AppConstants.roleKey, response.user.role);

  authToken.value = response.tokens.access;
  userId.value = response.user.id;
  username.value = response.user.username;
  userRole.value = response.user.role;
  isLoggedIn.value = true;

  currentUser.value = User(
    id: response.user.id,
    username: response.user.username,
    email: response.user.email,
    role: response.user.role,
  );

  // ✅ Clear login form after successful login
  usernameController.clear();
  passwordController.clear();

  await _saveFcmToken();
}


// }
Future<void> register() async {
  try {
    if (usernameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'All fields are required',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    final request = RegisterRequest(
      username: usernameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      role: selectedRole.value,
    );

    log("📤 Register request: ${request.toJson()}");

    final response = await _authRepository.register(request);

    log("✅ Register response: user=${response.user.username}, role=${response.user.role}");

    // ✅ Use tokens from register response directly — no second login call needed
    await _storage.write(AppConstants.tokenKey, response.tokens.access);
    await _storage.write(AppConstants.refreshKey, response.tokens.refresh);
    await _storage.write('user_id', response.user.id);
    await _storage.write('username', response.user.username);
    await _storage.write(AppConstants.roleKey, response.user.role);

    authToken.value = response.tokens.access;
    userId.value = response.user.id;
    username.value = response.user.username;
    userRole.value = response.user.role;
    isLoggedIn.value = true;

    currentUser.value = User(
      id: response.user.id,
      username: response.user.username,
      email: response.user.email,
      role: response.user.role,
    );

    // ✅ Save FCM token after registration
    await _saveFcmToken();

    Get.snackbar('Success', 'Account created successfully',
        backgroundColor: Colors.green, colorText: Colors.white);

    Get.offAllNamed(AppPages.dashboard);

  } catch (e) {
    log("❌ Register error: $e");
    Get.snackbar('Registration Failed', e.toString(),
        backgroundColor: Colors.red, colorText: Colors.white);
  } finally {
    isLoading.value = false;
  }
}

Future<void> _saveFcmToken() async {
  try {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      await _authRepository.saveFcmToken({'fcm_token': fcmToken});
      log("✅ FCM token saved: $fcmToken");
    }
  } catch (e) {
    log("⚠️ FCM token save failed (non-critical): $e");
    // Don't throw — this should never block login
  }
}

  
 Future<void> logout() async {
  // ✅ Clear in-memory state FIRST before anything async
  isLoggedIn.value = false;
  authToken.value = '';
  userId.value = 0;
  username.value = '';
  userRole.value = '';
  currentUser.value = null;

  // ✅ Then clear storage
  await _storage.erase();

  // ✅ Clear text controllers so previous credentials don't linger
  usernameController.clear();
  passwordController.clear();
  confirmPasswordController.clear();
  emailController.clear();

  Get.offAllNamed('/');
}
  
  String? getToken() {
    return authToken.value.isNotEmpty ? authToken.value : null;
  }
  String getFormattedToken() {
  final token = getToken();
  return token != null ? 'Bearer $token' : '';
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

