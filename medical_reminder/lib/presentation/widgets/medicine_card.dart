import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medical_reminder/data/models/medicine_model.dart';
import 'package:intl/intl.dart';

class MedicineCard extends StatelessWidget {
  final Medicine medicine;
  final VoidCallback? onTap;
  final bool isSelected;

  const MedicineCard({
    super.key,
    required this.medicine,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final expiryDate = DateFormat('yyyy-MM-dd').parse(medicine.expiry?? "");
    final isExpired = expiryDate.isBefore(now);
    final daysUntilExpiry = expiryDate.difference(now).inDays;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150.w,
        margin: EdgeInsets.only(right: 12.w),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2D9CDB).withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? const Color(0xFF2D9CDB) : const Color(0xFFEEEEEE),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Medicine Name and Company
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicine.name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  medicine.company ?? '--',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            
            SizedBox(height: 12.h),
            
            // Stock Information
            Row(
              children: [
                Icon(
                  Icons.inventory,
                  size: 14.sp,
                  color: (medicine.stock ?? 0) > 10 
                      ? Colors.green 
                      : (medicine.stock??0) > 0 
                          ? Colors.orange 
                          : Colors.red,
                ),
                SizedBox(width: 4.w),
                Text(
                  'Stock: ${medicine.stock ?? '0'}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: (medicine.stock??0) > 10 
                        ? Colors.green 
                        : (medicine.stock??0) > 0 
                            ? Colors.orange 
                            : Colors.red,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 8.h),
            
            // Expiry Information
            Row(
              children: [
                Icon(
                  isExpired ? Icons.warning : Icons.calendar_today,
                  size: 14.sp,
                  color: isExpired ? Colors.red : Colors.blue,
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    isExpired 
                        ? 'Expired' 
                        : daysUntilExpiry <= 30 
                            ? 'Expires in $daysUntilExpiry days' 
                            : DateFormat('MMM yyyy').format(expiryDate),
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: isExpired 
                          ? Colors.red 
                          : daysUntilExpiry <= 30 
                              ? Colors.orange 
                              : Colors.blue,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            
            // Selection Indicator
            if (isSelected)
              Positioned(
                top: 8.w,
                right: 8.w,
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D9CDB),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    size: 12.sp,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Horizontal Medicine Card variant
class HorizontalMedicineCard extends StatefulWidget {
  final Medicine medicine;
  final VoidCallback? onTap;

  const HorizontalMedicineCard({
    super.key,
    required this.medicine,
    this.onTap,
  });

  @override
  State<HorizontalMedicineCard> createState() => _HorizontalMedicineCardState();
}

class _HorizontalMedicineCardState extends State<HorizontalMedicineCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Main Card Content
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
              widget.onTap?.call();
            },
            child: Container(
              padding: EdgeInsets.all(12.w),
              child: Row(
                children: [
                  // Medicine Icon
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D9CDB).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.medical_services,
                      size: 20.sp,
                      color: const Color(0xFF2D9CDB),
                    ),
                  ),
                  
                  SizedBox(width: 12.w),
                  
                  // Medicine Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.medicine.name,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          widget.medicine.company ?? '- -',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            // Stock
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: (widget.medicine.stock ?? 0) > 10 
                                    ? Colors.green.withOpacity(0.1) 
                                    : Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                'Stock: ${widget.medicine.stock ?? 0}',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: (widget.medicine.stock ?? 0) > 10 ? Colors.green : Colors.orange,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            
                            SizedBox(width: 8.w),
                            
                            // Expiry
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                'Exp: ${widget.medicine.expiry ?? '--'}',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Expansion Arrow
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 25.h,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Expanded Content
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: const Color(0xFFEEEEEE), height: 1),
                  SizedBox(height: 12.h),
                  
                  // Additional Information
                  _buildInfoRow('Medicine ID', '#${widget.medicine.id}'),
                  SizedBox(height: 8.h),
                  _buildInfoRow('Category', widget.medicine.category ?? 'Not specified'),
                  SizedBox(height: 8.h),
                  _buildInfoRow('Full Company Name', widget.medicine.company ?? 'Not specified'),
                  SizedBox(height: 8.h),
                  _buildInfoRow('Total Stock', '${widget.medicine.stock ?? 0} units'),
                  SizedBox(height: 8.h),
                  _buildInfoRow('Expiry Date', widget.medicine.expiry ?? 'Not specified'),
                ],
              ),
            ),
            crossFadeState: _isExpanded 
                ? CrossFadeState.showSecond 
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120.w,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.black87,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
