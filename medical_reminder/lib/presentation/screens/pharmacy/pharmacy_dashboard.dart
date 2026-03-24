import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medical_reminder/data/models/medicine_model.dart';
import 'package:medical_reminder/data/models/order_model.dart';
import 'package:medical_reminder/data/models/search_medicien.dart';
import 'package:medical_reminder/presentation/controllers/auth_controller.dart';
import 'package:medical_reminder/presentation/controllers/pharmacy_controller.dart';


import 'package:flutter/material.dart';
import 'package:get/get.dart';
class SellerDashboardScreen extends StatefulWidget {
  const SellerDashboardScreen({super.key});

  @override
  State<SellerDashboardScreen> createState() => _SellerDashboardScreenState();
}

class _SellerDashboardScreenState extends State<SellerDashboardScreen> {
  final PharmacyController controller = Get.find<PharmacyController>();
  final AuthController _authController = Get.find<AuthController>();

  // ── Theme colors ──────────────────────────────────────────
  static const _primary = Color(0xFF1A73E8);
  static const _surface = Color(0xFFF8FAFF);
  static const _cardBg = Colors.white;
  static const _textPrimary = Color(0xFF1C1C2E);
  static const _textSecondary = Color(0xFF8E8E9A);

  @override
  void initState() {
    super.initState();
    controller.fetchMedicines();
    controller.fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      appBar: _buildAppBar(),
      floatingActionButton: _buildFAB(),
      // ✅ Blank screen fix — no Obx wrapping entire body
      body: RefreshIndicator(
        color: _primary,
        onRefresh: () async {
          await controller.fetchMedicines();
          await controller.fetchOrders();
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatsRow(),
                    const SizedBox(height: 24),
                    _buildSectionHeader(
                      "Medicines",
                      Icons.medication_outlined,
                      _primary,
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            // ── Medicines List ──────────────────────────
            Obx(() {
              if (controller.isLoading.value && controller.medicines.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
              }
              if (controller.medicines.isEmpty) {
                return SliverToBoxAdapter(child: _buildEmptyState(
                  icon: Icons.medication_outlined,
                  message: "No medicines added yet",
                ));
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: _buildMedicineCard(controller.medicines[i]),
                  ),
                  childCount: controller.medicines.length,
                ),
              );
            }),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: _buildSectionHeader(
                  "Pending Orders",
                  Icons.shopping_bag_outlined,
                  Colors.orange,
                ),
              ),
            ),

            // ── Orders List ─────────────────────────────
            Obx(() {
              if (controller.isLoading.value && controller.orders.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
              }
              if (controller.orders.isEmpty) {
                return SliverToBoxAdapter(child: _buildEmptyState(
                  icon: Icons.shopping_bag_outlined,
                  message: "No orders yet",
                ));
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: _buildOrderCard(controller.orders[i]),
                  ),
                  childCount: controller.orders.length,
                ),
              );
            }),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  // ── AppBar ──────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _cardBg,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      title: Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Seller Dashboard",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _textPrimary,
            ),
          ),
          Text(
            _authController.username.value,
            style: const TextStyle(
              fontSize: 12,
              color: _textSecondary,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      )),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded, color: _primary),
          onPressed: () {
            controller.fetchMedicines();
            controller.fetchOrders();
          },
        ),
        IconButton(
          icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
          onPressed: _showLogoutConfirmation,
        ),
        const SizedBox(width: 4),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: const Color(0xFFEEEEF5)),
      ),
    );
  }

  // ── FAB ─────────────────────────────────────────────────────
  Widget _buildFAB() {
    return FloatingActionButton.extended(
      onPressed: _showMainActions,
      backgroundColor: _primary,
      icon: const Icon(Icons.add_rounded, color: Colors.white),
      label: const Text(
        "Add",
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }

  // ── Stats Row ───────────────────────────────────────────────
  Widget _buildStatsRow() {
    return Obx(() {
      final pendingCount =
          controller.orders.where((o) => o.status == "pending").length;
      final confirmedCount =
          controller.orders.where((o) => o.status == "confirmed").length;

      return Row(
        children: [
          _buildStatChip(
            label: "Medicines",
            value: controller.medicines.length.toString(),
            icon: Icons.medication_outlined,
            color: _primary,
          ),
          const SizedBox(width: 10),
          _buildStatChip(
            label: "Pending",
            value: pendingCount.toString(),
            icon: Icons.hourglass_top_rounded,
            color: Colors.orange,
          ),
          const SizedBox(width: 10),
          _buildStatChip(
            label: "Confirmed",
            value: confirmedCount.toString(),
            icon: Icons.check_circle_outline_rounded,
            color: Colors.green,
          ),
        ],
      );
    });
  }

 Widget _buildStatChip({
  required String label,
  required String value,
  required IconData icon,
  required Color color,
}) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // ✅ don't force full width
        children: [
          Icon(icon, color: color, size: 18), // ✅ slightly smaller
          const SizedBox(width: 6),           // ✅ tighter gap
          Flexible(                            // ✅ let text shrink/wrap
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,             // ✅ reduced from 18
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    color: _textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis, // ✅ truncate if needed
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  // ── Section Header ──────────────────────────────────────────
  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: _textPrimary,
          ),
        ),
      ],
    );
  }

  // ── Medicine Card ───────────────────────────────────────────
  Widget _buildMedicineCard(Medicine m) {
    final isRx = m.requiresPrescription == true;
    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: _primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.medication_rounded,
              color: _primary, size: 22),
        ),
        title: Text(
          m.name ?? "-",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: _textPrimary,
          ),
        ),
        subtitle: m.description != null && m.description!.isNotEmpty
            ? Text(
                m.description!,
                style: const TextStyle(
                    fontSize: 12, color: _textSecondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isRx
                ? Colors.orange.withOpacity(0.1)
                : Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isRx
                  ? Colors.orange.withOpacity(0.3)
                  : Colors.green.withOpacity(0.3),
            ),
          ),
          child: Text(
            isRx ? "Rx" : "OTC",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isRx ? Colors.orange : Colors.green,
            ),
          ),
        ),
      ),
    );
  }

  // ── Order Card ──────────────────────────────────────────────
  Widget _buildOrderCard(OrderModel order) {
    final isPending = order.status == "pending";
    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(14),
        border: isPending
            ? Border.all(color: Colors.orange.withOpacity(0.3))
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isPending
                    ? Colors.orange.withOpacity(0.08)
                    : Colors.green.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isPending
                    ? Icons.hourglass_top_rounded
                    : Icons.check_circle_outline_rounded,
                color: isPending ? Colors.orange : Colors.green,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.medicineName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: _textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "${order.patientName}  •  Qty: ${order.quantity}",
                    style: const TextStyle(
                        fontSize: 12, color: _textSecondary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    order.storeName,
                    style: TextStyle(
                        fontSize: 11,
                        color: _primary.withOpacity(0.7)),
                  ),
                ],
              ),
            ),

            // Action
            if (isPending)
              TextButton(
                onPressed: () => controller.confirmOrder(order.id),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.orange.withOpacity(0.1),
                  foregroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  "Confirm",
                  style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w700),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  order.status.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.green,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ── Empty State ─────────────────────────────────────────────
  Widget _buildEmptyState(
      {required IconData icon, required String message}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Center(
        child: Column(
          children: [
            Icon(icon, size: 40, color: Colors.grey.shade300),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  // ── Bottom Sheet ────────────────────────────────────────────
  void _showMainActions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                _buildSheetItem(
                  icon: Icons.medication_outlined,
                  color: _primary,
                  title: "Add Medicine",
                  subtitle: "Register a new medicine",
                  onTap: () { Get.back(); _showAddMedicineDialog(); },
                ),
                _buildSheetItem(
                  icon: Icons.store_outlined,
                  color: Colors.teal,
                  title: "Create Store",
                  subtitle: "Set up a new pharmacy store",
                  onTap: () { Get.back(); _showCreateStoreDialog(); },
                ),
                _buildSheetItem(
                  icon: Icons.inventory_2_outlined,
                  color: Colors.purple,
                  title: "Add Inventory",
                  subtitle: "Add stock to your store",
                  onTap: () { Get.back(); _showAddInventoryDialog(); },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSheetItem({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title,
          style: const TextStyle(
              fontWeight: FontWeight.w600, fontSize: 14)),
      subtitle: Text(subtitle,
          style:
              const TextStyle(fontSize: 12, color: _textSecondary)),
    );
  }

  // ── Dialogs (functionality unchanged) ──────────────────────
  void _showAddMedicineDialog() {
    final name = TextEditingController();
    final desc = TextEditingController();
    bool isRx = false;

    Get.defaultDialog(
      title: "Add Medicine",
      content: StatefulBuilder(
        builder: (_, setState) => Column(
          children: [
            TextField(
                controller: name,
                decoration:
                    const InputDecoration(hintText: "Name")),
            const SizedBox(height: 8),
            TextField(
                controller: desc,
                decoration: const InputDecoration(
                    hintText: "Description")),
            Row(
              children: [
                Checkbox(
                    value: isRx,
                    onChanged: (v) => setState(() => isRx = v!)),
                const Text("Requires Prescription"),
              ],
            ),
          ],
        ),
      ),
      onConfirm: () {
        controller.createMedicine({
          "name": name.text.trim(),
          "description": desc.text.trim(),
          "requires_prescription": isRx.toString(),
        });
        Get.back();
      },
      textConfirm: "Add",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
    );
  }

  void _showCreateStoreDialog() {
    final name = TextEditingController();
    final address = TextEditingController();

    Get.defaultDialog(
      title: "Create Store",
      content: Column(
        children: [
          TextField(
              controller: name,
              decoration:
                  const InputDecoration(hintText: "Store Name")),
          const SizedBox(height: 8),
          TextField(
              controller: address,
              decoration:
                  const InputDecoration(hintText: "Address")),
        ],
      ),
      onConfirm: () {
        controller.createStore({
          "store_name": name.text,
          "address": address.text,
        });
        Get.back();
      },
      textConfirm: "Create",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
    );
  }

  void _showAddInventoryDialog() {
    final price = TextEditingController();
    final stock = TextEditingController();
    final selectedStore = Rx<SellerStoreModel?>(null);
    final selectedMedicine = Rx<Medicine?>(null);

    if (controller.myStores.isNotEmpty) {
      selectedStore.value = controller.myStores.first;
    }

    Get.defaultDialog(
      title: "Add Inventory",
      titleStyle: const TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold),
      contentPadding: const EdgeInsets.all(16),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Store",
                style:
                    TextStyle(fontSize: 13, color: _textSecondary)),
            const SizedBox(height: 4),
            Obx(() {
              if (controller.myStores.isEmpty) {
                return const Text(
                    "No stores found. Create a store first.",
                    style: TextStyle(
                        color: Colors.red, fontSize: 13));
              }
              return _dropdownContainer(
                child: DropdownButton<SellerStoreModel>(
                  isExpanded: true,
                  value: selectedStore.value,
                  items: controller.myStores
                      .map((s) => DropdownMenuItem(
                          value: s,
                          child: Text(s.storeName,
                              style: const TextStyle(
                                  fontSize: 14))))
                      .toList(),
                  onChanged: (v) => selectedStore.value = v,
                ),
              );
            }),
            const SizedBox(height: 12),
            const Text("Medicine",
                style:
                    TextStyle(fontSize: 13, color: _textSecondary)),
            const SizedBox(height: 4),
            Obx(() {
              if (controller.medicines.isEmpty) {
                return const Text("No medicines found.",
                    style: TextStyle(
                        color: Colors.red, fontSize: 13));
              }
              return _dropdownContainer(
                child: DropdownButton<Medicine>(
                  isExpanded: true,
                  value: selectedMedicine.value,
                  hint: const Text("Select medicine",
                      style: TextStyle(fontSize: 14)),
                  items: controller.medicines
                      .map((m) => DropdownMenuItem(
                          value: m,
                          child: Text(m.name ?? "-",
                              style: const TextStyle(
                                  fontSize: 14))))
                      .toList(),
                  onChanged: (v) => selectedMedicine.value = v,
                ),
              );
            }),
            const SizedBox(height: 12),
            const Text("Price (₹)",
                style:
                    TextStyle(fontSize: 13, color: _textSecondary)),
            const SizedBox(height: 4),
            TextField(
              controller: price,
              keyboardType: const TextInputType.numberWithOptions(
                  decimal: true),
              decoration: InputDecoration(
                hintText: "e.g. 45.50",
                prefixIcon:
                    const Icon(Icons.currency_rupee, size: 18),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
              ),
            ),
            const SizedBox(height: 12),
            const Text("Stock",
                style:
                    TextStyle(fontSize: 13, color: _textSecondary)),
            const SizedBox(height: 4),
            TextField(
              controller: stock,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "e.g. 100",
                prefixIcon: const Icon(Icons.inventory_2_outlined,
                    size: 18),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
              ),
            ),
          ],
        ),
      ),
      onConfirm: () {
        if (selectedStore.value == null) {
          Get.snackbar("Error", "Please select a store",
              backgroundColor: Colors.red,
              colorText: Colors.white);
          return;
        }
        if (selectedMedicine.value == null) {
          Get.snackbar("Error", "Please select a medicine",
              backgroundColor: Colors.red,
              colorText: Colors.white);
          return;
        }
        if (price.text.isEmpty || stock.text.isEmpty) {
          Get.snackbar("Error", "Please fill price and stock",
              backgroundColor: Colors.red,
              colorText: Colors.white);
          return;
        }
        controller.addInventory({
          "store": selectedStore.value!.id,
          "medicine": selectedMedicine.value!.id,
          "price": double.parse(price.text),
          "stock": int.parse(stock.text),
        });
        Get.back();
      },
      textConfirm: "Add",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
    );
  }

  Widget _dropdownContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(child: child),
    );
  }

  void _showLogoutConfirmation() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Text("Logout",
            style:
                TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
        content: const Text(
            "Are you sure you want to logout?",
            style: TextStyle(fontSize: 14, color: _textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel",
                style: TextStyle(color: _textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _authController.logout();
            },
            child: const Text("Logout",
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
// class SellerDashboardScreen extends StatefulWidget {
//   const SellerDashboardScreen({super.key});

//   @override
//   State<SellerDashboardScreen> createState() =>
//       _SellerDashboardScreenState();
// }

// class _SellerDashboardScreenState extends State<SellerDashboardScreen> {
//   final PharmacyController controller =
//       Get.find<PharmacyController>();

//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController companyController = TextEditingController();
//   final TextEditingController categoryController = TextEditingController();
//   final TextEditingController quantityController = TextEditingController();
//   final TextEditingController expiryController = TextEditingController();
//   final TextEditingController priceController = TextEditingController();
//   final TextEditingController sellQtyController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     controller.fetchMedicines(); // ✅ fetch on load
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Seller Dashboard"),
//         centerTitle: true,
//         actions: [          
//           IconButton(
//             icon: const Icon(Icons.person_outline),
//             onPressed: () {
//               Get.toNamed('/profile');
//             },
//           ),],
//       ),

//       // ✅ ADD BUTTON
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showAddMedicineSheet(context),
//         child: const Icon(Icons.add),
//       ),

//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (controller.medicines.isEmpty) {
//           return const Center(
//             child: Text(
//               "No medicines available",
//               style: TextStyle(fontSize: 16),
//             ),
//           );
//         }

//         return RefreshIndicator(
//           onRefresh: controller.fetchMedicines,
//           child: ListView.builder(
//             padding: const EdgeInsets.all(12),
//             itemCount: controller.medicines.length,
//             itemBuilder: (context, index) {
//               final medicine = controller.medicines[index];

//               return Card(
//                 elevation: 3,
//                 margin: const EdgeInsets.symmetric(vertical: 8),
//                 child: ListTile(
//                   title: Text(
//                     medicine.name,
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Company: ${medicine.company ?? "-"}"),
//                       Text("Category: ${medicine.category ?? "-"}"),
//                       Text("Stock: ${medicine.stock ?? 0}"),
//                       Text("Expiry: ${medicine.expiry ?? "-"}"),
//                     ],
//                   ),
//                   trailing: IconButton(
//                     icon: const Icon(Icons.sell, color: Colors.green),
//                     onPressed: () =>
//                         _showSellDialog(context, medicine),
//                   ),
//                 ),
//               );
//             },
//           ),
//         );
//       }),
//     );
//   }

//   // =====================================================
//   // ✅ ADD MEDICINE
//   // =====================================================

//   void _showAddMedicineSheet(BuildContext context) {
//     nameController.clear();
//     companyController.clear();
//     categoryController.clear();
//     quantityController.clear();
//     expiryController.clear();
//     priceController.clear();

//     Get.bottomSheet(
//       Container(
//         padding: const EdgeInsets.all(16),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius:
//               BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const Text(
//                 "Add Medicine",
//                 style: TextStyle(
//                     fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 16),

//               _buildTextField(nameController, "Medicine Name"),
//               _buildTextField(companyController, "Company"),
//               _buildTextField(categoryController, "Category"),

//               _buildTextField(
//                 quantityController,
//                 "Stock Quantity",
//                 isNumber: true,
//               ),

//               _buildTextField(
//                 priceController,
//                 "Price",
//                 isNumber: true,
//               ),

//               TextField(
//                 controller: expiryController,
//                 readOnly: true,
//                 decoration: const InputDecoration(
//                   labelText: "Expiry Date",
//                   border: OutlineInputBorder(),
//                   suffixIcon: Icon(Icons.calendar_today),
//                 ),
//                 onTap: () async {
//                   DateTime? picked = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime.now(),
//                     lastDate: DateTime(2100),
//                   );

//                   if (picked != null) {
//                     expiryController.text =
//                         "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
//                   }
//                 },
//               ),

//               const SizedBox(height: 16),

//               ElevatedButton(
//                 onPressed: () {
//                   final name = nameController.text.trim();
//                   final company = companyController.text.trim();
//                   final category = categoryController.text.trim();
//                   final quantity =
//                       int.tryParse(quantityController.text) ?? 0;
//                   final price =
//                       int.tryParse(priceController.text) ?? 0;
//                   final expiry = expiryController.text.trim();

//                   if (name.isEmpty ||
//                       company.isEmpty ||
//                       category.isEmpty ||
//                       quantity <= 0 ||
//                       expiry.isEmpty) {
//                     Get.snackbar(
//                       "Error",
//                       "Please fill all fields correctly",
//                       backgroundColor: Colors.red,
//                       colorText: Colors.white,
//                     );
//                     return;
//                   }

//                   controller.addSellerMedicine(
//                     {
//   "name": name ?? "",
//   "company": company,
//   "category": category,
//   "quantity": quantity,
//   "price": price,
//   "expiry_date": expiry
// }
//                   //   CreateMedicineRequest(
//                   //     name: name,
//                   //     company: company,
//                   //     category: category,
//                   //     quantity: quantity,
//                   //     expiryDate: expiry,
//                   //     price: price,
//                   //   ),
//                    );

//                   Get.back();
//                 },
//                 child: const Text("Add Medicine"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // =====================================================
//   // ✅ SELL MEDICINE
//   // =====================================================

//   void _showSellDialog(BuildContext context, Medicine medicine) {
//     sellQtyController.clear();

//     Get.defaultDialog(
//       title: "Sell ${medicine.name}",
//       content: Column(
//         children: [
//           Text("Available Stock: ${medicine.stock ?? 0}"),
//           const SizedBox(height: 12),
//           TextField(
//             controller: sellQtyController,
//             keyboardType: TextInputType.number,
//             decoration: const InputDecoration(
//               labelText: "Quantity to Sell",
//               border: OutlineInputBorder(),
//             ),
//           ),
//         ],
//       ),
//       textConfirm: "Sell",
//       textCancel: "Cancel",
//       onConfirm: () {
//         final qty = int.tryParse(sellQtyController.text) ?? 0;

//         if (qty <= 0) {
//           Get.snackbar(
//             "Invalid Quantity",
//             "Enter valid quantity",
//             backgroundColor: Colors.red,
//             colorText: Colors.white,
//           );
//           return;
//         }

//         controller.sellMedicine(medicine.id, qty);
//         Get.back();
//       },
//     );
//   }

//   // =====================================================
//   // ✅ Reusable TextField Builder
//   // =====================================================

//   Widget _buildTextField(
//     TextEditingController controller,
//     String label, {
//     bool isNumber = false,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: TextField(
//         controller: controller,
//         keyboardType:
//             isNumber ? TextInputType.number : TextInputType.text,
//         decoration: InputDecoration(
//           labelText: label,
//           border: const OutlineInputBorder(),
//         ),
//       ),
//     );
//   }
// }
