import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_reminder/data/models/medicine_model.dart';
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

  final TextEditingController nameController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController sellQtyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.fetchMedicines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Seller Dashboard",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: Colors.blue,
                  size: 20,
                ),
              ),
              onPressed: () {
                Get.toNamed('/profile');
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddMedicineSheet(context),
        backgroundColor: Colors.blue,
        elevation: 4,
        icon: const Icon(Icons.add_circle_outline),
        label: const Text(
          "Add Medicine",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                const SizedBox(height: 16),
                Text(
                  "Loading medicines...",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }

        if (controller.medicines.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 80,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 16),
                Text(
                  "No medicines available",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Tap the button below to add your first medicine",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchMedicines,
          color: Colors.blue,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.blue.shade700],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      "Total Items",
                      "${controller.medicines.length}",
                      Icons.inventory_2_outlined,
                    ),
                    Container(
                      height: 40,
                      width: 1,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    _buildStatItem(
                      "In Stock",
                      "${controller.medicines.where((m) => (m.stock ?? 0) > 0).length}",
                      Icons.check_circle_outline,
                    ),
                  ],
                ),
              ),

              // Medicines List Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Medicines Inventory",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Medicines List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  itemCount: controller.medicines.length,
                  itemBuilder: (context, index) {
                    final medicine = controller.medicines[index];
                    final isLowStock = (medicine.stock ?? 0) < 10;
                    final isExpired = medicine.expiry != null &&
                        DateTime.tryParse(medicine.expiry!)
                            ?.isBefore(DateTime.now()) ==
                            true;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _showMedicineDetails(context, medicine),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Header Row
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          Icons.medication,
                                          color: Colors.blue.shade700,
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              medicine.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              medicine.company ?? "-",
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Sell Button
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.point_of_sale,
                                            color: Colors.green,
                                          ),
                                          onPressed: () =>
                                              _showSellDialog(context, medicine),
                                          tooltip: "Sell Medicine",
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  // Divider
                                  Divider(
                                    color: Colors.grey[200],
                                    height: 1,
                                  ),
                                  const SizedBox(height: 12),

                                  // Info Grid
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildInfoChip(
                                          Icons.category_outlined,
                                          medicine.category ?? "-",
                                          Colors.purple,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: _buildInfoChip(
                                          Icons.inventory_outlined,
                                          "${medicine.stock ?? 0} units",
                                          isLowStock ? Colors.orange : Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildInfoChip(
                                          Icons.calendar_today_outlined,
                                          medicine.expiry ?? "-",
                                          isExpired ? Colors.red : Colors.teal,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      // Expanded(
                                      //   child: _buildInfoChip(
                                      //     Icons.currency_rupee,
                                      //     "${medicine.price ?? "0"}",
                                      //     Colors.green,
                                      //   ),
                                      // ),
                                    ],
                                  ),

                                  // Warning Badges
                                  if (isLowStock || isExpired) ...[
                                    const SizedBox(height: 12),
                                    Wrap(
                                      spacing: 8,
                                      children: [
                                        if (isLowStock)
                                          _buildWarningBadge(
                                            "Low Stock",
                                            Colors.orange,
                                          ),
                                        if (isExpired)
                                          _buildWarningBadge(
                                            "Expired",
                                            Colors.red,
                                          ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // =====================================================
  // UI Helper Widgets
  // =====================================================

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning_amber_rounded, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // Medicine Details Bottom Sheet
  // =====================================================

  void _showMedicineDetails(BuildContext context, Medicine medicine) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.medication,
                    color: Colors.blue.shade700,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medicine.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        medicine.company ?? "-",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildDetailRow("Category", medicine.category ?? "-"),
            _buildDetailRow("Stock", "${medicine.stock ?? 0} units"),
            //_buildDetailRow("Price", "₹${medicine. ?? "0"}"),
            _buildDetailRow("Expiry Date", medicine.expiry ?? "-"),
            // if (medicine.shopName != null)
            //   _buildDetailRow("Shop", medicine.shopName!),
            // if (medicine.location != null)
            //   _buildDetailRow("Location", medicine.location!),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.back();
                  _showSellDialog(context, medicine);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.point_of_sale),
                label: const Text(
                  "Sell This Medicine",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // ADD MEDICINE
  // =====================================================

  void _showAddMedicineSheet(BuildContext context) {
    nameController.clear();
    companyController.clear();
    categoryController.clear();
    quantityController.clear();
    expiryController.clear();
    priceController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle Bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.add_circle_outline,
                      color: Colors.blue.shade700,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Add New Medicine",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Divider(color: Colors.grey[200], height: 1),

            // Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildModernTextField(
                      controller: nameController,
                      label: "Medicine Name",
                      icon: Icons.medication_outlined,
                      hint: "e.g., Paracetamol",
                    ),
                    const SizedBox(height: 16),

                    _buildModernTextField(
                      controller: companyController,
                      label: "Company",
                      icon: Icons.business_outlined,
                      hint: "e.g., Cipla",
                    ),
                    const SizedBox(height: 16),

                    _buildModernTextField(
                      controller: categoryController,
                      label: "Category",
                      icon: Icons.category_outlined,
                      hint: "e.g., Tablet, Syrup",
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _buildModernTextField(
                            controller: quantityController,
                            label: "Stock Quantity",
                            icon: Icons.inventory_2_outlined,
                            hint: "e.g., 100",
                            isNumber: true,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildModernTextField(
                            controller: priceController,
                            label: "Price (₹)",
                            icon: Icons.currency_rupee,
                            hint: "e.g., 50",
                            isNumber: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Date Picker Field
                    GestureDetector(
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now().add(const Duration(days: 365)),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: Colors.blue.shade700,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );

                        if (picked != null) {
                          expiryController.text =
                              "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                        }
                      },
                      child: AbsorbPointer(
                        child: _buildModernTextField(
                          controller: expiryController,
                          label: "Expiry Date",
                          icon: Icons.calendar_today_outlined,
                          hint: "Select expiry date",
                          readOnly: true,
                          suffixIcon: Icons.arrow_drop_down,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Action Button
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _handleAddMedicine(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Add Medicine",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleAddMedicine() {
    final name = nameController.text.trim();
    final company = companyController.text.trim();
    final category = categoryController.text.trim();
    final quantity = int.tryParse(quantityController.text) ?? 0;
    final price = int.tryParse(priceController.text) ?? 0;
    final expiry = expiryController.text.trim();

    if (name.isEmpty ||
        company.isEmpty ||
        category.isEmpty ||
        quantity <= 0 ||
        expiry.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Please fill all fields correctly",
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        icon: const Icon(Icons.error_outline, color: Colors.white),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    controller.addSellerMedicine({
      "name": name,
      "company": company,
      "category": category,
      "quantity": quantity,
      "price": price,
      "expiry_date": expiry,
    });

    Get.back();

    // Success feedback
    Get.snackbar(
      "Success",
      "Medicine added successfully!",
      backgroundColor: Colors.green.shade400,
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  // =====================================================
  // SELL MEDICINE
  // =====================================================

  void _showSellDialog(BuildContext context, Medicine medicine) {
    sellQtyController.clear();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.point_of_sale,
                  color: Colors.green.shade700,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                "Sell ${medicine.name}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Available Stock
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.inventory_outlined,
                      size: 18,
                      color: Colors.blue.shade700,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Available: ${medicine.stock ?? 0} units",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Quantity Input
              _buildModernTextField(
                controller: sellQtyController,
                label: "Quantity to Sell",
                icon: Icons.shopping_cart_outlined,
                hint: "Enter quantity",
                isNumber: true,
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _handleSellMedicine(medicine),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Sell",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSellMedicine(Medicine medicine) {
    final qty = int.tryParse(sellQtyController.text) ?? 0;

    if (qty <= 0) {
      Get.snackbar(
        "Invalid Quantity",
        "Please enter a valid quantity",
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        icon: const Icon(Icons.error_outline, color: Colors.white),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    if (qty > (medicine.stock ?? 0)) {
      Get.snackbar(
        "Insufficient Stock",
        "Only ${medicine.stock ?? 0} units available",
        backgroundColor: Colors.orange.shade400,
        colorText: Colors.white,
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    controller.sellMedicine(medicine.id, qty);
    Get.back();

    // Success feedback
    Get.snackbar(
      "Sale Successful",
      "$qty units of ${medicine.name} sold",
      backgroundColor: Colors.green.shade400,
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }

  // =====================================================
  // Reusable Modern TextField
  // =====================================================

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    bool isNumber = false,
    bool readOnly = false,
    IconData? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(icon, color: Colors.blue.shade700, size: 20),
            suffixIcon: suffixIcon != null
                ? Icon(suffixIcon, color: Colors.grey[400])
                : null,
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
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
