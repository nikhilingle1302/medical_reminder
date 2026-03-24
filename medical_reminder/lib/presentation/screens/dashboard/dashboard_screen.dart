import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_reminder/presentation/controllers/auth_controller.dart';
import 'package:medical_reminder/presentation/controllers/medicine_controller.dart';
import 'package:medical_reminder/presentation/controllers/reminder_controller.dart';
import 'package:medical_reminder/presentation/widgets/orderScreen.dart';
import 'package:medical_reminder/presentation/widgets/order_history_screen.dart';
import 'package:medical_reminder/presentation/widgets/reminder_card.dart';
import 'package:medical_reminder/presentation/widgets/medicine_card.dart';
import 'package:medical_reminder/presentation/widgets/searchMedicineScreen.dart';
import 'package:medical_reminder/presentation/widgets/storeListScreen.dart';
class DashboardScreen extends StatelessWidget {
  final AuthController _authController = Get.find<AuthController>();
  final ReminderController _reminderController = Get.find<ReminderController>();
  final MedicineController _medicineController = Get.find<MedicineController>();
  DashboardScreen({super.key});
  void _showLogoutConfirmation() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Logout',
          style: TextStyle(fontSize: 18.sp),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _authController.logout();
            },
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Obx(() => Text(
            'Welcome, ${_authController.username.value}!',
            style: TextStyle(fontSize: 18.sp),
          )),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none),
              onPressed: () {
                // Show due reminders
                _reminderController.getDueReminders();
              },
            ),
            // IconButton(
            //   icon: const Icon(Icons.person_outline),
            //   onPressed: () {
            //     Get.toNamed('/profile');
            //   },
            // ),
          IconButton(
                icon: const Icon(Icons.logout),
                color: Colors.red,
                onPressed: () {
                  _showLogoutConfirmation();
                },
              ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                
                // Today's Date
                Text(
                  'Today',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now()),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 20.h),
      
                _buildSearchBar(),
                
                SizedBox(height: 24.h),
                
                // Today's Reminders Card
                _buildTodayRemindersCard(),
      
                SizedBox(height: 20.h),
                _buildQuickActions(),
                
                SizedBox(height: 24.h),
                
                // Medicines List (View Only for Patients)
                _buildMedicinesSection(),
                
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      _actionCard(
        icon: Icons.search,
        title: "Search",
        onTap: () {
          Get.to(() => SearchMedicineScreen());
        },
      ),
      _actionCard(
        icon: Icons.medication,
        title: "Reminders",
        onTap: () {
          Get.toNamed('/add-reminder');
        },
      ),
_actionCard(
  icon: Icons.shopping_cart,
  title: "Orders",
  onTap: () {
    Get.to(() => OrderHistoryScreen());
  },
      ),
    ],
  );
}

Widget _actionCard({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 100.w,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 24.sp, color: Colors.blueAccent),
          SizedBox(height: 8.h),
          Text(
            title,
            style: TextStyle(fontSize: 12.sp),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildSearchBar() {
  return Column(
    children: [
      TextField(
        decoration: InputDecoration(
          hintText: "Search medicines...",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) {
          if (value.length > 2) {
            _medicineController.searchMedicine(value);
          }
        },
      ),

      SizedBox(height: 12.h),

      Obx(() {
        if (_medicineController.searchResults.isEmpty) {
          return const SizedBox();
        }

        return Container(
          height: 200.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
              )
            ],
          ),
          child:  ListView.builder(
  itemCount: _medicineController.searchResults.length,
  itemBuilder: (context, index) {
    final item = _medicineController.searchResults[index];

return Card(
  child: ListTile(
    leading: const Icon(Icons.medication, color: Colors.blue),
    title: Text(item.medicine),
    subtitle: Text("${item.store}  •  Stock: ${item.stock}"),
    trailing: Text(
      "₹${item.price.toStringAsFixed(0)}",
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
    ),
    onTap: () {
      // ✅ Go directly to OrderScreen — no StoreListScreen needed
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
),  
        );
      }),
    ],
  );
}
  
  Widget _buildTodayRemindersCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today\'s Reminders',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Obx(() {
                final todayCount = _reminderController.getTodayReminders().length;
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D9CDB).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    '$todayCount',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2D9CDB),
                    ),
                  ),
                );
              }),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          Obx(() {
            final todayReminders = _reminderController.getTodayReminders();
            
            if (todayReminders.isEmpty) {
              return Column(
                children: [
                  Icon(
                    Icons.notifications_off,
                    size: 40.sp,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'No reminders for today',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
              );
            }
            
            return Column(
              children: todayReminders.map((reminder) {
                return ReminderCard(
                  reminder: reminder,
                  onTap: () {
                    Get.toNamed('/reminder-detail', arguments: {'id': reminder.id});
                  },
                  onTaken: () {
                    _reminderController.markAsTaken(reminder.id!);
                  },
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }
  
  Widget _buildMedicinesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Medicines',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
        
        Obx(() {
          final medicines = _reminderController.medicines;
          
          if (medicines.isEmpty) {
            return Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Text(
                  'No medicines available',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            );
          }
          
          return SizedBox(
            height: 120.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: medicines.length,
              itemBuilder: (context, index) {
                 final m = medicines[index];
                //return MedicineCard(medicine: medicines[index]);
                            return Card(
                margin: EdgeInsets.only(right: 12.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Container(
                  width: 130.w,
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.medication,
                          color: Colors.blueAccent, size: 28.sp),
                      SizedBox(height: 8.h),
                      Text(
                        m.name ?? "-",
                        style: TextStyle(
                            fontSize: 13.sp, fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: m.requiresPrescription == true
                              ? Colors.orange.withOpacity(0.1)
                              : Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          m.requiresPrescription == true ? "Rx" : "OTC",
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            color: m.requiresPrescription == true
                                ? Colors.orange
                                : Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );

              },
            ),
          );
        }),
        
        SizedBox(height: 24.h),
        // ElevatedButton(
        // onPressed: (){
        //  Get.toNamed('/chat-bot');
        // }, 
        // child:Text("chat bot",style: TextStyle(fontSize: 14.h),)),
       SizedBox(
  width: double.infinity,
  height: 48.h,
  child: ElevatedButton(
    onPressed: () {
      Get.toNamed('/bmi-calculator');
    },
    style: ElevatedButton.styleFrom(
      elevation: 2,
      backgroundColor: Colors.blueAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.monitor_weight_outlined,
          size: 18.h,
          color: Colors.white,
        ),
        SizedBox(width: 8.w),
        Text(
          "BMI Calculator",
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    ),
  ),
),

      ],
    );
  }
}
// class DashboardScreen extends StatelessWidget {
//   final AuthController _authController = Get.find();
//   final ReminderController _reminderController = Get.find();

//   DashboardScreen({super.key});
// String _formatReminderTime(String timeString) {
//   try {
//     final date = DateFormat('yyyy-MM-dd HH:mm:ss').parse(timeString);
//     return DateFormat('hh:mm a').format(date);
//   } catch (e) {
//     return timeString;
//   }
// }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Obx(() => Text(
//           'Welcome, ${_authController.currentUser.value?.username ?? 'User'}!',
//           style: TextStyle(fontSize: 18.sp),
//         )),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.notifications_none),
//             onPressed: () {},
//           ),
//           IconButton(
//             icon: const Icon(Icons.person_outline),
//             onPressed: () {
//               Get.toNamed('/profile');
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16.w),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 20.h),
              
//               // Today's Date
//               Text(
//                 'Today',
//                 style: TextStyle(
//                   fontSize: 20.sp,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 8.h),
//               Text(
//                 DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now()),
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   color: Colors.grey,
//                 ),
//               ),
              
//               SizedBox(height: 24.h),
              
//               // Calendar Section
//               Container(
//                 height: 200.h,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12.r),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 10,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: SfCalendar(
//                   view: CalendarView.month,
//                   showNavigationArrow: true,
//                   monthViewSettings: const MonthViewSettings(
//                     showTrailingAndLeadingDates: false,
//                   ),
//                 ),
//               ),
              
//               SizedBox(height: 24.h),
              
//               // Reminders Section
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Reminders',
//                     style: TextStyle(
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.add_circle_outline, size: 24.sp),
//                     onPressed: () {
//                       if (_authController.isPatient()) {
//                         Get.toNamed('/add-reminder');
//                       }
//                     },
//                   ),
//                 ],
//               ),
//               // In dashboard_screen.dart, update the reminder card section:
// //Obx(() {
// //   final todayReminders = _reminderController.getTodayReminders();
  
// //   if (todayReminders.isEmpty) {
// //     return Container(
// //       height: 100.h,
// //       child: Center(
// //         child: Text(
// //           'No reminders for today',
// //           style: TextStyle(
// //             color: Colors.grey,
// //             fontSize: 14.sp,
// //           ),
// //         ),
// //       ),
// //     );
// //   }
  
// //   return Column(
// //     children: todayReminders.map((reminder) {
// //       return Container(
// //         margin: EdgeInsets.only(bottom: 12.h),
// //         padding: EdgeInsets.all(16.w),
// //         decoration: BoxDecoration(
// //           color: reminder.isTaken ? Colors.grey[100] : Colors.white,
// //           borderRadius: BorderRadius.circular(12.r),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.black.withOpacity(0.05),
// //               blurRadius: 10,
// //               offset: const Offset(0, 4),
// //             ),
// //           ],
// //         ),
// //         child: Row(
// //           children: [
// //             Container(
// //               width: 4.w,
// //               height: 40.h,
// //               decoration: BoxDecoration(
// //                 color: reminder.isTaken ? Colors.green : const Color(0xFF2D9CDB),
// //                 borderRadius: BorderRadius.circular(2.r),
// //               ),
// //             ),
// //             SizedBox(width: 16.w),
// //             Expanded(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     reminder.medicine,
// //                     style: TextStyle(
// //                       fontSize: 16.sp,
// //                       fontWeight: FontWeight.w600,
// //                       color: reminder.isTaken ? Colors.grey : Colors.black,
// //                     ),
// //                   ),
// //                   SizedBox(height: 4.h),
// //                   Text(
// //                     '${reminder.dosage} • ${_formatReminderTime(reminder.reminderTime)}',
// //                     style: TextStyle(
// //                       fontSize: 14.sp,
// //                       color: reminder.isTaken ? Colors.grey : Colors.black87,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             if (!reminder.isTaken)
// //               IconButton(
// //                 icon: Icon(Icons.check_circle_outline,
// //                     color: const Color(0xFF2D9CDB)),
// //                 onPressed: () {
// //                   _reminderController.markAsTaken(reminder.id);
// //                 },
// //               )
// //             else
// //               Icon(Icons.check_circle, color: Colors.green),
// //           ],
// //         ),
// //       );
// //     }).toList(),
// //   );
// // }),

// // Add helper method

//               SizedBox(height: 12.h),
              
//               // Search Bar
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 16.w),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF5F5F5),
//                   borderRadius: BorderRadius.circular(10.r),
//                 ),
//                 child: TextField(
//                   decoration: InputDecoration(
//                     hintText: 'Search reminders...',
//                     hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
//                     border: InputBorder.none,
//                     prefixIcon: Icon(Icons.search, size: 20.sp, color: Colors.grey),
//                   ),
//                 ),
//               ),
              
//               SizedBox(height: 16.h),
              
//               // Reminders List
//               Obx(() {
//                 if (_reminderController.isLoading.value) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
                
//                 final todayReminders = _reminderController.getTodayReminders();
                
//                 if (todayReminders.isEmpty) {
//                   return Container(
//                     height: 100.h,
//                     child: Center(
//                       child: Text(
//                         'No reminders for today',
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 14.sp,
//                         ),
//                       ),
//                     ),
//                   );
//                 }
                
//                 return Column(
//                   children: todayReminders.map((reminder) {
//                     return ReminderCard(
//                       reminder: reminder,
//                       onTap: () {
//                         // Handle reminder tap
//                       },
//                       onTaken: () {
//                         _reminderController.markAsTaken(reminder.id);
//                       },
//                     );
//                   }).toList(),
//                 );
//               }),
              
//               SizedBox(height: 24.h),
              
//               // Medicines Section
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Medicines',
//                     style: TextStyle(
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.filter_list, size: 24.sp),
//                     onPressed: () {},
//                   ),
//                 ],
//               ),
              
//               SizedBox(height: 12.h),
              
//               // Medicines Search
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 16.w),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF5F5F5),
//                   borderRadius: BorderRadius.circular(10.r),
//                 ),
//                 child: TextField(
//                   decoration: InputDecoration(
//                     hintText: 'Search medicines...',
//                     hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
//                     border: InputBorder.none,
//                     prefixIcon: Icon(Icons.search, size: 20.sp, color: Colors.grey),
//                   ),
//                 ),
//               ),
              
//               SizedBox(height: 16.h),
              
//               // Medicines List
//               Obx(() {
//                 final medicines = _reminderController.medicines;
                
//                 if (medicines.isEmpty) {
//                   return Container(
//                     height: 100.h,
//                     child: Center(
//                       child: Text(
//                         'No medicines available',
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 14.sp,
//                         ),
//                       ),
//                     ),
//                   );
//                 }
                
//                 return SizedBox(
//                   height: 120.h,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: medicines.length,
//                     itemBuilder: (context, index) {
//                       return MedicineCard(medicine: medicines[index]);
//                     },
//                   ),
//                 );
//               }),
              
//               SizedBox(height: 24.h),
              
//               // Appointments Section
//               Text(
//                 'Appointments',
//                 style: TextStyle(
//                   fontSize: 18.sp,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
              
//               SizedBox(height: 16.h),
              
//               // Sample appointments (you can replace with real data)
//               Column(
//                 children: [
//                   _buildAppointmentCard(
//                     time: '5:00 AM',
//                     title: 'Medication Refill',
//                     color: const Color(0xFFE3F2FD),
//                   ),
//                   SizedBox(height: 12.h),
//                   _buildAppointmentCard(
//                     time: '10:00 AM',
//                     title: 'Doctor\'s Appointment',
//                     color: const Color(0xFFE8F5E9),
//                   ),
//                   SizedBox(height: 12.h),
//                   _buildAppointmentCard(
//                     time: '7:00 PM',
//                     title: 'Lab Test',
//                     color: const Color(0xFFF3E5F5),
//                   ),
//                 ],
//               ),
              
//               SizedBox(height: 40.h),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
  
//   Widget _buildAppointmentCard({
//     required String time,
//     required String title,
//     required Color color,
//   }) {
//     return Container(
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(12.r),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 4.w,
//             height: 40.h,
//             decoration: BoxDecoration(
//               color: const Color(0xFF2D9CDB),
//               borderRadius: BorderRadius.circular(2.r),
//             ),
//           ),
//           SizedBox(width: 16.w),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 time,
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black87,
//                 ),
//               ),
//               SizedBox(height: 4.h),
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 16.sp,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.black,
//                 ),
//               ),
//             ],
//           ),
//           const Spacer(),
//           IconButton(
//             icon: Icon(Icons.notifications_active, color: const Color(0xFF2D9CDB)),
//             onPressed: () {},
//           ),
//         ],
//       ),
//     );
//   }
// }