class AppConstants {
  // Base URL
  static const String baseUrl = 'https://reminder-90sm.onrender.com';
  
  // Storage keys
  static const String tokenKey = 'access_token';
  static const String userKey = 'user_data';
  static const String roleKey = 'user_role';
  
  // Roles
   
  static const String patientRole = 'patient';
  static const String caretakerRole = 'caretaker';
  static const String sellerRole = 'seller';

  // static const String tokenKey = 'auth_token';
  // static const String roleKey = 'user_role';
  
  // API Endpoints
  static const String register = '/api/accounts/register/';
  static const String patientLogin = '/api/accounts/patient/login/';
  static const String caretakerLogin = '/api/accounts/caretaker/login/';
  static const String medicines = '/api/pharmacy/medicines/';
  static const String reminders = '/api/reminders/';
}
class ApiConfig {
  // Base URL
  static const String baseUrl = 'https://reminder-90sm.onrender.com';
  
  // API Endpoints - Updated to match your backend
  static const String register = '/api/accounts/register/';
  static const String login = '/api/accounts/login/'; // Single login endpoint
  static const String medicines = '/api/pharmacy/medicines/';
  static const String saveMedicine = '/api/pharmacy/medicines/save/';
  static const String reminders = '/api/reminders/';
  static const String dueReminders = '/api/reminders/due/';
  
  // Timeout durations
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Headers
  static Map<String, dynamic> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };


}