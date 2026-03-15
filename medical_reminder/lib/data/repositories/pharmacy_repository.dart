import 'package:medical_reminder/data/models/medicine_model.dart';
import 'package:medical_reminder/data/services/api_service.dart';

class PharmacyRepository {
  final ApiService _apiService;

  PharmacyRepository(this._apiService);

  Future<List<Medicine>> getMedicines() async {
    return await _apiService.getMedicines();
  }

  Future<dynamic> createSellerMedicine(dynamic request) async {
    return await _apiService.createSellerMedicine(request);
  }

  Future<void> sellMedicine(int medicineId, int quantity) async {
    await _apiService.sellMedicine({
      "medicine_id": medicineId,
      "quantity": quantity,
    });
  }
}
