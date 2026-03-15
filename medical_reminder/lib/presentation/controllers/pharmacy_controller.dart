import 'dart:developer';

import 'package:get/get.dart';
import 'package:medical_reminder/data/models/medicine_model.dart';
import 'package:medical_reminder/data/repositories/pharmacy_repository.dart';

class PharmacyController extends GetxController {
  final PharmacyRepository _repository;

  PharmacyController(this._repository);

  RxList<Medicine> medicines = <Medicine>[].obs;
  RxBool isLoading = false.obs;

  Future<void> fetchMedicines() async {
    try {
      isLoading.value = true;
      final data = await _repository.getMedicines();
      medicines.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch medicines");
    } finally {
      isLoading.value = false;
    }
  }

  Future<dynamic> addSellerMedicine( dynamic request) async {
    try {
      await _repository.createSellerMedicine(request);
      fetchMedicines();
      Get.snackbar("Success", "Medicine added");
    } catch (e) {
      //Get.snackbar("Error", "Failed to add medicine");
      log(e.toString());
    }
  }

  Future<void> sellMedicine(int id, int quantity) async {
    try {
      await _repository.sellMedicine(id, quantity);
      fetchMedicines();
      Get.snackbar("Success", "Sale recorded");
    } catch (e) {
      //Get.snackbar("Error", "Sale failed");

      
    }
  }
}

