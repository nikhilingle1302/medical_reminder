import 'package:medical_reminder/data/models/medicine_model.dart';
import 'package:medical_reminder/data/models/order_model.dart';
import 'package:medical_reminder/data/models/search_medicien.dart';
import 'package:medical_reminder/data/services/api_service.dart';
class PharmacyRepository {
  final ApiService _apiService;
  PharmacyRepository(this._apiService);

  Future<List<Medicine>> getMedicines() async =>
      await _apiService.getMedicines();

  Future<dynamic> createMedicine(Map<String, dynamic> body) async =>
      await _apiService.createMedicine(body);

  Future<dynamic> createStore(Map<String, dynamic> body) async =>
      await _apiService.createStore(body);

  Future<dynamic> addInventory(Map<String, dynamic> body) async =>
      await _apiService.addInventory(body);

  // ✅ Now actually fetches from API
  Future<List<OrderModel>> getOrders() async =>
      await _apiService.getOrders();

  Future<void> confirmOrder(int orderId) async =>
      await _apiService.confirmOrder(orderId);

  // ✅ New
  Future<List<SellerStoreModel>> getAllStores() async =>
      await _apiService.getSellerAllStores();
}