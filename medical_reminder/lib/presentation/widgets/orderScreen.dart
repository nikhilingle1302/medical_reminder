import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_reminder/presentation/controllers/order_controller.dart';

class OrderScreen extends StatelessWidget {
  final int medicineId;
  final int storeId;
  final String medicineName;
  final String storeName;
  final int price;

  final OrderController controller = Get.put(OrderController(Get.find()));

  OrderScreen({
    super.key,
    required this.medicineId,
    required this.storeId,
    required this.medicineName,
    required this.storeName,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Place Order")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ✅ Order summary card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _summaryRow(Icons.medication, "Medicine", medicineName),
                  const Divider(height: 16),
                  _summaryRow(Icons.store, "Store", storeName),
                  const Divider(height: 16),
                  _summaryRow(Icons.currency_rupee, "Price", "₹$price each"),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "Quantity",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller.quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.numbers),
                hintText: "Enter quantity",
              ),
            ),

            // ✅ Live total price
        ValueListenableBuilder<TextEditingValue>(
  valueListenable: controller.quantityController,
  builder: (context, value, _) {
    final qty = int.tryParse(value.text) ?? 1;
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Text(
        "Total: ₹${price * qty}",
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  },
),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.placeOrder(
                              medicineId: medicineId,
                              storeId: storeId,
                            ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Place Order",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.blue),
        const SizedBox(width: 8),
        Text("$label: ",
            style: const TextStyle(color: Colors.grey, fontSize: 14)),
        Expanded(
          child: Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 14),
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}