import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_reminder/data/models/medicine_model.dart';
import 'package:medical_reminder/data/models/search_medicien.dart';
import 'package:medical_reminder/data/repositories/medicine_repository.dart';

class MedicineController extends GetxController {
  final MedicineRepository _medicineRepository;
  
  MedicineController(this._medicineRepository);
  
  final RxList<Medicine> medicines = <Medicine>[].obs;
  final RxBool isLoading = false.obs;
  
  // For creating new medicine
  final TextEditingController nameController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final Rx<DateTime?> selectedExpiryDate = Rx<DateTime?>(null);
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  
  @override
  void onInit() {
    super.onInit();
    //fetchMedicines();
  }
  
  Future<void> fetchMedicines() async {
    try {
      isLoading.value = true;
      final result = await _medicineRepository.getMedicines();
      medicines.assignAll(result);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch medicines',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
final RxList<SearchResultItem> searchResults = <SearchResultItem>[].obs;

Future<void> searchMedicine(String query) async {
  try {
    isLoading.value = true;

    final response = await _medicineRepository.searchMedicine(query);

    // searchResults.assignAll(
    //   response.map((e) => SearchMedicineModel.fromJson(e)).toList(),
    // );
    searchResults.assignAll(response);

  } catch (e) {
    Get.snackbar(
      'Error',
      'Search failed',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    isLoading.value = false;
  }
}

Future<void> createOrder(int medicineId, int quantity) async {
  try {
    final request = {
      "medicine": medicineId,
      "quantity": quantity,
    };

    final response = await _medicineRepository.createOrder(request);

    if (response != null) {
      Get.snackbar(
        "Success",
        "Order placed successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  } catch (e) {
    Get.snackbar("Error", "Order failed");
  }
}
  
  Future<void> createMedicine() async {
    try {
      if (nameController.text.isEmpty || 
          companyController.text.isEmpty || 
          stockController.text.isEmpty ||
         priceController.text.isEmpty ||categoryController.text.isEmpty ||
          selectedExpiryDate.value == null) {
        Get.snackbar(
          'Error',
          'Please fill all fields',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      
      isLoading.value = true;
      
      // final request = CreateMedicineRequest(
      //   name: nameController.text,
      //   company: companyController.text,
      //   stock: int.parse(stockController.text),
      //   expiry: '${selectedExpiryDate.value!.year}-${selectedExpiryDate.value!.month.toString().padLeft(2, '0')}-${selectedExpiryDate.value!.day.toString().padLeft(2, '0')}',
      // );
      final Map<String,dynamic> request = {
        "name": nameController.text,
        "company": companyController.text,        
        "stock": int.parse(stockController.text),
        "quantity": int.parse(stockController.text),
        "expiry_date": '${selectedExpiryDate.value!.year}-${selectedExpiryDate.value!.month.toString().padLeft(2, '0')}-${selectedExpiryDate.value!.day.toString().padLeft(2, '0')}',
        "category": categoryController.text,
        "price": int.parse(priceController.text),
      };
      
      final response = await _medicineRepository.createMedicine(request);
      if(response !=null){
      if (response['id']!=null || response.message?.contains('success') == true) {
        // Refresh medicines list
        await fetchMedicines();
        
        // Clear form
        nameController.clear();
        companyController.clear();
        stockController.clear();
        selectedExpiryDate.value = null;
        categoryController.clear();
        priceController.clear();
        Get.back();
        Get.snackbar(
          'Success',
          'Medicine added successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create medicine: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}