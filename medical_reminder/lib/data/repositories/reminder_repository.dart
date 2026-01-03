import 'package:medical_reminder/data/models/reminder_model.dart';
import 'package:medical_reminder/data/models/medicine_model.dart';
import 'package:medical_reminder/data/services/api_service.dart';
import 'package:medical_reminder/presentation/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:medical_reminder/data/models/reminder_model.dart';
import 'package:medical_reminder/data/models/medicine_model.dart';
import 'package:medical_reminder/data/services/api_service.dart';

class ReminderRepository {
  final ApiService _apiService;

  ReminderRepository(this._apiService);

 Future<ReminderResponse> getReminders() async {
  return await _apiService.getReminders();
}

  Future<List<Medicine>> getMedicines() async {
    return await _apiService.getMedicines();
  }

  Future<dynamic> createReminder(dynamic request) async {
    return await _apiService.createReminder(request);
  }

  Future<dynamic> markReminderTaken(int id) async {
   
    return await _apiService.markReminderTaken(id);
  }
    Future<dynamic> getDueReminders() async {
    // final token = _authController.getToken();
    // if (token == null) throw Exception('No authentication token');
    
    //return await _apiService.getDueReminders('Token $token');
    return await _apiService.getDueReminders();
  }
  
}
// class ReminderRepository {
//   final ApiService _apiService;
//   final AuthController _authController = Get.find();

//   ReminderRepository(this._apiService);

//   Future<List<Reminder>> getReminders() async {
//     final token = _authController.getToken();
//     if (token == null) throw Exception('No authentication token');
    
//     return await _apiService.getReminders('Token $token');
//   }

//   Future<List<Medicine>> getMedicines() async {
//     final token = _authController.getToken();
//     if (token == null) throw Exception('No authentication token');
    
//     return await _apiService.getMedicines('Token $token');
//   }

//   Future<ApiResponse> createReminder(CreateReminderRequest request) async {
//     final token = _authController.getToken();
//     if (token == null) throw Exception('No authentication token');
    
//     return await _apiService.createReminder('Token $token', request);
//   }

//   Future<ApiResponse> markReminderTaken(int id) async {
//     final token = _authController.getToken();
//     if (token == null) throw Exception('No authentication token');
    
//     return await _apiService.markReminderTaken('Token $token', id);
//   }

//   Future<DueRemindersResponse> getDueReminders() async {
//     final token = _authController.getToken();
//     if (token == null) throw Exception('No authentication token');
    
//     return await _apiService.getDueReminders('Token $token');
//   }
// }