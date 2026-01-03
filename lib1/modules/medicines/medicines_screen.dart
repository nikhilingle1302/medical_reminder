import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'medicines_controller.dart';

class MedicinesScreen extends StatelessWidget {
  MedicinesScreen({Key? key}) : super(key: key);

  final MedicinesController controller = Get.put(MedicinesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicines'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.medicines.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.medication, size: 80.sp, color: Colors.grey),
                SizedBox(height: 16.h),
                Text(
                  'No medicines found',
                  style: TextStyle(fontSize: 18.sp, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
                onChanged: (value) => controller.searchMedicines(value),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: controller.filteredMedicines.length,
                itemBuilder: (context, index) {
                  final medicine = controller.filteredMedicines[index];
                  return _buildMedicineCard(medicine);
                },
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new medicine functionality
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMedicineCard(medicine) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  medicine.name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.expand_more),
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            medicine.dosage ?? 'No dosage info',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
