import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_reminder/presentation/controllers/medicine_controller.dart';
import 'package:medical_reminder/presentation/widgets/orderScreen.dart';
import 'package:medical_reminder/presentation/widgets/storeListScreen.dart';

class SearchMedicineScreen extends StatelessWidget {
  final MedicineController controller = Get.find<MedicineController>();

  SearchMedicineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Medicine")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: "Search medicine...",
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
  if (value.length > 2) {
    controller.searchMedicine(value);
  } else {
    controller.searchResults.clear(); // ✅ clear when query too short
  }
},
            ),

            const SizedBox(height: 16),

                   Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                if (controller.searchResults.isEmpty) {
                  return Center(child: Text("No results"));
                }

                return ListView.builder(
  itemCount: controller.searchResults.length,
  itemBuilder: (context, index) {
    final item = controller.searchResults[index];
    return Card(
      child: ListTile(
        leading: const Icon(Icons.medication, color: Colors.blue),
        title: Text(item.medicine),
        subtitle: Text("${item.store}  •  Stock: ${item.stock}"),
        trailing: Text(
          "₹${item.price.toStringAsFixed(0)}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.green,
          ),
        ),
        onTap: () {
  Get.to(() => OrderScreen(
    medicineId: item.medicineId,
    storeId: item.storeId,
    medicineName: item.medicine,
    storeName: item.store,
    price: item.price.toInt(),
  ));
},
      ),
    );
  },
);
              }),
            ),
          ],
        ),
      ),
    );
  }
}