import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_reminder/data/models/medicine_model.dart';
import 'package:medical_reminder/presentation/controllers/auth_controller.dart';
import 'package:medical_reminder/presentation/controllers/reminder_controller.dart';
import 'package:medical_reminder/presentation/controllers/medicine_controller.dart';
import 'package:medical_reminder/presentation/widgets/reminder_card.dart';
import 'package:medical_reminder/presentation/widgets/medicine_card.dart';

class CaretakerDashboardScreen extends StatefulWidget {
  const CaretakerDashboardScreen({super.key});

  @override
  State<CaretakerDashboardScreen> createState() =>
      _CaretakerDashboardScreenState();
}

class _CaretakerDashboardScreenState
    extends State<CaretakerDashboardScreen> {
  final AuthController authController = Get.find<AuthController>();
  final ReminderController reminderController = Get.find<ReminderController>();
  final MedicineController medicineController = Get.find<MedicineController>();
@override
  void initState() {
    super.initState();
    reminderController.getDueReminders();
    medicineController.fetchMedicines();
}
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Caretaker Dashboard',
            style: TextStyle(fontSize: 18.sp),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none),
              onPressed: () {
                reminderController.getDueReminders();
              },
            ),
            IconButton(
              icon: const Icon(Icons.person_outline),
              onPressed: () {
                print(
                  'Navigating to profile, user: ${authController.currentUser.value?.username}',
                );
                Get.toNamed('/profile');
              },
            ),
          ],
          bottom: TabBar(
            indicatorColor: const Color(0xFF2D9CDB),
            labelColor: const Color(0xFF2D9CDB),
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                text: 'Overview',
                icon: Icon(Icons.dashboard, size: 20.sp),
              ),
              Tab(
                text: 'Medicines',
                icon: Icon(Icons.medical_services, size: 20.sp),
              ),
              Tab(
                text: 'Reminders',
                icon: Icon(Icons.notifications, size: 20.sp),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOverviewTab(),
            _buildMedicinesTab(),
            _buildRemindersTab(),
          ],
        ),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }


  
  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          // Stats Cards
          Row(
            children: [
             Obx(()=>
                 Expanded(
                  child: _buildStatCard(
                    title: 'Total Medicines',
                    value: medicineController.medicines.length.toString(),
                    icon: Icons.medical_services,
                    color: const Color(0xFF2D9CDB),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
            Obx(
              () => Expanded(
                child: _buildStatCard(
                  title: 'Active Reminders',
                  value: reminderController.reminders.where((r) {
                    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
                    final afterStart = r.startDate.compareTo(today) <= 0;
                    final beforeEnd = r.endDate == null || r.endDate!.compareTo(today) >= 0;
                    return afterStart && beforeEnd;
                  }).length.toString(),
                  icon: Icons.notifications_active,
                  color: const Color(0xFF4CAF50),
                ),
              ),
            ),
            ],
          ),
          
          SizedBox(height: 16.h),
          
Row(
  children: [
    Expanded(
      child: _buildStatCard(
        title: 'Due Today',
        value: reminderController.getTodayReminders().length.toString(),
        icon: Icons.access_time,
        color: const Color(0xFFFF9800),
      ),
    ),
    SizedBox(width: 12.w),
    Expanded(
      child: _buildStatCard(
        // ✅ "Completed" = reminders whose end_date has passed
        title: 'Completed',
        value: reminderController.reminders.where((r) {
          if (r.endDate == null) return false;
          final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
          return r.endDate!.compareTo(today) < 0;
        }).length.toString(),
        icon: Icons.check_circle,
        color: const Color(0xFF9C27B0),
      ),
    ),
  ],
),
          SizedBox(height: 24.h),
          
          // Quick Actions
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          SizedBox(height: 16.h),
          
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.add_circle,
                  title: 'Add Medicine',
                  subtitle: 'Add new medicine to inventory',
                  onTap: () {
                    _showAddMedicineDialog();
                  },
                  color: const Color(0xFF2D9CDB),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.add_alert,
                  title: 'Create Reminder',
                  subtitle: 'Set reminder for patient',
                  onTap: () {
                    Get.toNamed('/add-reminder');
                  },
                  color: const Color(0xFF4CAF50),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          // Due Reminders Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                reminderController.getDueReminders();
              },
              icon: Icon(Icons.notifications_active, size: 20.sp),
              label: Text(
                'Check Due Reminders',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9800),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Add this to your controller or state management
final searchQuery = ''.obs;
final filteredMedicines = <Medicine>[].obs;

Widget _buildMedicinesTab() {
  return Column(
    children: [
      // Search and Filter Bar
      Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search medicines...',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, size: 20.sp, color: Colors.grey),
                    suffixIcon: Obx(() => searchQuery.value.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, size: 20.sp, color: Colors.grey),
                            onPressed: () {
                              searchQuery.value = '';
                              _filterMedicines();
                            },
                          )
                        : const SizedBox.shrink()),
                  ),
                  onChanged: (value) {
                    searchQuery.value = value;
                    _filterMedicines();
                  },
                ),
              ),
            ),
            SizedBox(width: 12.w),
            IconButton(
              icon: Icon(Icons.filter_list, size: 24.sp),
              onPressed: () {
                // Show filter options
              },
            ),
          ],
        ),
      ),
      
      Expanded(
        child: Obx(() {
          if (medicineController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          
          // Use filtered list if search is active, otherwise use all medicines
          final displayMedicines = searchQuery.value.isEmpty
              ? medicineController.medicines
              : filteredMedicines;
          
          if (displayMedicines.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    searchQuery.value.isEmpty
                        ? Icons.medical_services_outlined
                        : Icons.search_off,
                    size: 60.sp,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    searchQuery.value.isEmpty
                        ? 'No medicines in inventory'
                        : 'No medicines found',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    searchQuery.value.isEmpty
                        ? 'Tap + to add medicines'
                        : 'Try a different search term',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: displayMedicines.length,
            itemBuilder: (context, index) {
              return HorizontalMedicineCard(
                medicine: displayMedicines[index],
                onTap: () {
                  // Show medicine details
                },
              );
            },
          );
        }),
      ),
    ],
  );
}

// Add this search filter method
void _filterMedicines() {
  if (searchQuery.value.isEmpty) {
    filteredMedicines.clear();
    return;
  }
  
  final query = searchQuery.value.toLowerCase();
  filteredMedicines.value = medicineController.medicines.where((medicine) {
    // Customize these fields based on your Medicine model
    final name = medicine.name?.toLowerCase() ?? '';
    final category = medicine.category?.toLowerCase() ?? '';
    final manufacturer = medicine.company?.toLowerCase() ?? '';
    
    return name.contains(query) ||
           category.contains(query) ||
           manufacturer.contains(query);
  }).toList();
}
  
  Widget _buildRemindersTab() {
    return Column(
      children: [
        // Filter Options
        Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search reminders...',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search, size: 20.sp, color: Colors.grey),
                    ),
                    onChanged: (value) {
                      // Implement search
                    },
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              PopupMenuButton<String>(
                icon: Icon(Icons.filter_list, size: 24.sp),
                onSelected: (value) {
                  // Handle filter selection
                },
                itemBuilder: (context) => [
                  PopupMenuItem(value: 'all', child: Text('All Reminders')),
                  PopupMenuItem(value: 'today', child: Text('Today')),
                  PopupMenuItem(value: 'upcoming', child: Text('Upcoming')),
                  PopupMenuItem(value: 'completed', child: Text('Completed')),
                ],
              ),
            ],
          ),
        ),
        
        Expanded(
          child: Obx(() {
            if (reminderController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            
            final reminders = reminderController.reminders;
            
            if (reminders.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_off,
                      size: 60.sp,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No reminders created',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Create reminders for patients',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }
            
           return ListView.builder(
  itemCount: reminders.length,
  itemBuilder: (context, index) {
    final reminder = reminders[index];
    return ReminderCard(
      reminder: reminder,
      onTap: () {
        print('Navigating to detail for reminder ID: ${reminder.id}');
  print('Total reminders in controller: ${reminderController.reminders.length}');
  print('All reminder IDs: ${reminderController.reminders.map((r) => r.id).toList()}');
          Get.toNamed('/reminder-detail/${reminder.id}', arguments: {
    'reminder': reminder,
    'allReminders': reminderController.reminders.toList(),
  });
      },
      onTaken: () {
        reminderController.markAsTaken(reminder.id!);
      },
    );
  },
);

          }),
        ),
      ],
    );
  }
  
  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        // Show action options
        _showActionMenu();
      },
      backgroundColor: const Color(0xFF2D9CDB),
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
  
  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32.sp),
            SizedBox(height: 8.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11.sp,
                color: color.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  void _showAddMedicineDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Add New Medicine', style: TextStyle(fontSize: 18.sp)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: medicineController.nameController,
                decoration: InputDecoration(
                  labelText: 'Medicine Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: medicineController.companyController,
                decoration: InputDecoration(
                  labelText: 'Company',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: medicineController.categoryController,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: medicineController.stockController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Stock Quantity',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ), 
              SizedBox(height: 12.h),
              TextField(
                controller: medicineController.priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              GestureDetector(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: Get.context!,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    medicineController.selectedExpiryDate.value = picked;
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.grey, size: 20.sp),
                      SizedBox(width: 12.w),
                      Obx(() => Text(
                        medicineController.selectedExpiryDate.value != null
                            ? DateFormat('yyyy-MM-dd').format(medicineController.selectedExpiryDate.value!)
                            : 'Select Expiry Date',
                        style: TextStyle(
                          color: medicineController.selectedExpiryDate.value != null
                              ? Colors.black
                              : Colors.grey,
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(fontSize: 14.sp)),
          ),
          ElevatedButton(
            onPressed: () {
              medicineController.createMedicine();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2D9CDB),
            ),
            child: Text('Add Medicine', style: TextStyle(fontSize: 14.sp)),
          ),
        ],
      ),
    );
  }
  
  void _showActionMenu() {
    showModalBottomSheet(
      context: Get.context!,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.add_circle, color: const Color(0xFF2D9CDB)),
                title: Text('Add Medicine', style: TextStyle(fontSize: 16.sp)),
                subtitle: Text('Add new medicine to inventory'),
                onTap: () {
                  Get.back();
                  _showAddMedicineDialog();
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.add_alert, color: const Color(0xFF2D9CDB)),
                title: Text('Create Reminder', style: TextStyle(fontSize: 16.sp)),
                subtitle: Text('Set reminder for patient'),
                onTap: () {
                  Get.back();
                  Get.toNamed('/add-reminder');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
