import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_reminder/data/models/medicine_model.dart';
import 'package:medical_reminder/data/models/search_medicien.dart';
import 'package:medical_reminder/data/repositories/pharmacy_repository.dart';

import '../../data/models/order_model.dart';
class PharmacyController extends GetxController {
  final PharmacyRepository _repo;
  PharmacyController(this._repo);

  RxList<Medicine> medicines = <Medicine>[].obs;
  RxList<OrderModel> orders = <OrderModel>[].obs;
  RxList<SellerStoreModel> myStores = <SellerStoreModel>[].obs; // ✅ New
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllStores(); // ✅ Load stores on init so inventory dialog has real IDs
  }

  // MEDICINES
  Future<void> fetchMedicines() async {
    try {
      isLoading.value = true;
      medicines.assignAll(await _repo.getMedicines());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createMedicine(Map<String, dynamic> body) async {
    await _repo.createMedicine(body);
    fetchMedicines();
  }

  // STORE
  Future<void> createStore(Map<String, dynamic> body) async {
    await _repo.createStore(body);
    Get.snackbar("Success", "Store Created", backgroundColor: Colors.green, colorText: Colors.white);
    await fetchAllStores(); // ✅ Refresh store list after creating
  }

  // ✅ New - fetch all stores
  Future<void> fetchAllStores() async {
    try {
      myStores.assignAll(await _repo.getAllStores());
    } catch (e) {
      log("❌ Fetch stores error: $e");
    }
  }

  // INVENTORY
  Future<void> addInventory(Map<String, dynamic> body) async {
    await _repo.addInventory(body);
    Get.snackbar("Success", "Inventory Added", backgroundColor: Colors.green, colorText: Colors.white);
  }

  // ORDERS
  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      orders.assignAll(await _repo.getOrders()); // ✅ Uncommented
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> confirmOrder(int id) async {
    try {
      await _repo.confirmOrder(id);
      Get.snackbar("Success", "Order confirmed", backgroundColor: Colors.green, colorText: Colors.white);
      await fetchOrders(); // ✅ Refresh orders list
    } catch (e) {
      Get.snackbar("Error", "Failed to confirm order", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}