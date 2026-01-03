import 'package:get/get.dart';

import '../../data/models/api_models.dart';

import '../../data/repo/medical_repo.dart';


class MedicinesController extends GetxController {
  final MedicalRepository _repository = MedicalRepository();
  
  final medicines = <Medicine>[].obs;
  final filteredMedicines = <Medicine>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMedicines();
  }

  Future<void> fetchMedicines() async {
    try {
      isLoading.value = true;
      final data = await _repository.getMedicines();
      medicines.value = data;
      filteredMedicines.value = data;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void searchMedicines(String query) {
    searchQuery.value = query;
    
    if (query.isEmpty) {
      filteredMedicines.value = medicines;
    } else {
      filteredMedicines.value = medicines.where((medicine) {
        final nameLower = medicine.name.toLowerCase();
        final queryLower = query.toLowerCase();
        return nameLower.contains(queryLower);
      }).toList();
    }
  }

  void clearSearch() {
    searchQuery.value = '';
    filteredMedicines.value = medicines;
  }

  Future<void> refreshMedicines() async {
    await fetchMedicines();
  }
}
// class MedicinesController extends GetxController {
//   final medicines = [].obs;
//   final filteredMedicines = [].obs;
//   final isLoading = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchMedicines();
//   }

//   Future<void> fetchMedicines() async {
//     try {
//       isLoading.value = true;
//       // Fetch from repository
//       await Future.delayed(const Duration(seconds: 1));
//       filteredMedicines.value = medicines;
//     } catch (e) {
//       Get.snackbar('Error', e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void searchMedicines(String query) {
//     if (query.isEmpty) {
//       filteredMedicines.value = medicines;
//     } else {
//       filteredMedicines.value = medicines
//           .where((medicine) =>
//               medicine.name.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     }
//   }
// }