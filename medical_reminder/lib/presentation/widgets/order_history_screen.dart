import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:medical_reminder/data/models/order_model.dart';
import 'package:medical_reminder/presentation/controllers/order_controller.dart';

class OrderHistoryScreen extends StatelessWidget {
  // final OrderController controller = Get.find<OrderController>();
final OrderController controller = Get.put(OrderController(Get.find()));
  OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.fetchMyOrders,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.myOrders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart_outlined,
                    size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                const Text("No orders yet",
                    style: TextStyle(color: Colors.grey, fontSize: 16)),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchMyOrders,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.myOrders.length,
            itemBuilder: (context, index) {
              final order = controller.myOrders[index];
              return _buildOrderCard(order);
            },
          ),
        );
      }),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    // ✅ Status color
    final statusColor = switch (order.status) {
      'confirmed' => Colors.green,
      'pending'   => Colors.orange,
      'cancelled' => Colors.red,
      _           => Colors.grey,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Order #${order.id}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    order.status.toUpperCase(),
                    style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            const Divider(height: 16),

            _orderRow(Icons.medication, "Medicine", order.medicineName),
            const SizedBox(height: 6),
            _orderRow(Icons.store, "Store", order.storeName),
            const SizedBox(height: 6),
            _orderRow(Icons.numbers, "Quantity", order.quantity.toString()),
            const SizedBox(height: 6),
            _orderRow(
              Icons.calendar_today,
              "Date",
              _formatDate(order.createdAt),
            ),
          ],
        ),
      ),
    );
  }

  Widget _orderRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text("$label: ",
            style: const TextStyle(color: Colors.grey, fontSize: 13)),
        Expanded(
          child: Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.w500, fontSize: 13),
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  String _formatDate(String createdAt) {
    try {
      final dt = DateTime.parse(createdAt).toLocal();
      return DateFormat('MMM dd, yyyy - hh:mm a').format(dt);
    } catch (e) {
      return createdAt;
    }
  }
} 