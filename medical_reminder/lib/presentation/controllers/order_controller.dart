import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_reminder/data/models/order_model.dart';
import 'package:medical_reminder/data/repositories/medicine_repository.dart';

class OrderController extends GetxController {
  final MedicineRepository _repository;
  OrderController(this._repository);

  final RxBool isLoading = false.obs;
  final RxList<OrderModel> myOrders = <OrderModel>[].obs;
  final TextEditingController quantityController =
      TextEditingController(text: "1");

  @override
  void onInit() {
    super.onInit();
    fetchMyOrders();
  }

  // ✅ Fetch patient's order history
  Future<void> fetchMyOrders() async {
    try {
      isLoading.value = true;
      myOrders.assignAll(await _repository.getMyOrders());
    } catch (e) {
      Get.snackbar("Error", "Failed to load orders",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> placeOrder({
    required int medicineId,
    required int storeId,
  }) async {
    try {
      isLoading.value = true;

      final qty = int.tryParse(quantityController.text.trim()) ?? 1;
      if (qty <= 0) {
        Get.snackbar("Error", "Enter a valid quantity",
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      final request = {
        "medicine": medicineId,
        "store": storeId,
        "quantity": qty,
      };

      await _repository.createOrder(request);

      quantityController.text = "1"; // reset

      Get.snackbar("Success", "Order placed successfully!",
          backgroundColor: Colors.green, colorText: Colors.white);

      // ✅ Refresh order list then go to history
      await fetchMyOrders();
      Get.offNamed('/order-history');

    } catch (e) {
      Get.snackbar("Error", "Order failed: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}