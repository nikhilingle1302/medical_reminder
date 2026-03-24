import 'package:medical_reminder/data/models/medicine_model.dart';
import 'package:medical_reminder/data/models/order_model.dart';
import 'package:medical_reminder/data/models/search_medicien.dart';
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

    Future<List<SearchResultItem>> searchMedicine(String query) async {
   
    return await _apiService.searchMedicine(query);
  }

// Future<dynamic> createOrder(Map<String, dynamic> request) {
//   return _apiService.createOrder(request);
// }

Future<dynamic> confirmOrder(int orderId) {
  return _apiService.confirmOrder(orderId);
}

  Future<dynamic> createMedicine(dynamic request) async {
    final token = _authController.getFormattedToken();
    return await _apiService.createMedicine( request);
  }
  Future<List<OrderModel>> getMyOrders() async =>
    await _apiService.getOrders();

Future<Map<String, dynamic>> createOrder(Map<String, dynamic> body) async =>
    await _apiService.createOrder(body);
  
}