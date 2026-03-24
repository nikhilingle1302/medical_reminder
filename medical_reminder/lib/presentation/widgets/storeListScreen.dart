import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_reminder/data/models/search_medicien.dart';
import 'package:medical_reminder/presentation/widgets/orderScreen.dart';
class StoreListScreen extends StatelessWidget {
  final SearchMedicineModel medicine;

  const StoreListScreen({super.key, required this.medicine});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(medicine.medicine)),
      body: medicine.availableStores.isEmpty
          ? const Center(child: Text("No stores available"))
          : ListView.builder(
              itemCount: medicine.availableStores.length,
              itemBuilder: (context, index) {
                final store = medicine.availableStores[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: const Icon(Icons.store, color: Colors.blue),
                    title: Text(store.storeName),
                    // ✅ show stock, not user/address
                    subtitle: Text("Stock: ${store.stock} units"),
                    trailing: Text(
                      "₹${store.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                    onTap: () {
                      Get.to(() => OrderScreen(
                            medicineId: medicine.medicineId,
                            storeId: store.id,
                            medicineName: medicine.medicine,
                            storeName: store.storeName,
                            price: store.price.toInt(),
                          ));
                    },
                  ),
                );
              },
            ),
    );
  }
}