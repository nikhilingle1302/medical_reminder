import 'package:medical_reminder/data/models/medicine_model.dart';
import 'package:medical_reminder/data/services/api_service.dart';
import 'package:medical_reminder/presentation/controllers/auth_controller.dart';
import 'package:get/get.dart';

class MedicineRepository {
  final ApiService _apiService;
  final AuthController _authController = Get.find<AuthController>();

  MedicineRepository(this._apiService);

  Future<List<Medicine>> getMedicines() async {
    final token = _authController.getFormattedToken();
    return await _apiService.getMedicines();
  }

  Future<dynamic> createMedicine(dynamic request) async {
    final token = _authController.getFormattedToken();
    return await _apiService.createMedicine( request);
  }
}