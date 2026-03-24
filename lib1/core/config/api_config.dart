class ApiConfig {
  // Base URL
  static const String baseUrl = 'https://pharmeasy-5ba3.onrender.com';
  
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