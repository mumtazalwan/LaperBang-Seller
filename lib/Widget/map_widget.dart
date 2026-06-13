import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../Services/seller_provider.dart';

class TopNavigationPanelWidget extends StatelessWidget {
  final double sisaJarakMeter;
  final VoidCallback onCancel;

  const TopNavigationPanelWidget({Key? key, required this.sisaJarakMeter, required this.onCancel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SellerProvider>();
    final darkText = const Color(0xFF0F374A);
    final primaryBlue = const Color(0xFF0E7DFF);
    final primaryRed = const Color(0xFFFF3B47);
    final greyText = const Color(0xFF8A98A1);

    return Positioned(
      top: 50.h,
      left: 20.w,
      right: 20.w,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, 5))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(color: primaryRed.withOpacity(0.1), shape: BoxShape.circle),
                  child: Icon(Icons.navigation, color: primaryRed, size: 18.sp),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    provider.selectedCluster?['nama'] ?? "Menuju Lokasi",
                    style: TextStyle(color: darkText, fontSize: 14.sp, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(Icons.cancel, color: Colors.grey.shade400, size: 22.sp),
                  onPressed: onCancel,
                ),
              ],
            ),
            SizedBox(height: 8.h),
            const Divider(height: 1, color: Colors.black12),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.directions_bike, color: primaryBlue, size: 16.sp),
                    SizedBox(width: 4.w),
                    Text(
                      sisaJarakMeter > 1000
                          ? "${(sisaJarakMeter / 1000).toStringAsFixed(1)} Km lagi"
                          : "${sisaJarakMeter.toInt()} m lagi",
                      style: TextStyle(color: darkText, fontSize: 13.sp, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      " (${(sisaJarakMeter / 50).ceil()} mnt)",
                      style: TextStyle(color: greyText, fontSize: 12.sp),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: provider.currentStatus['color'].withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    provider.currentStatus['title'].toString().toUpperCase(),
                    style: TextStyle(color: provider.currentStatus['color'], fontSize: 10.sp, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BottomClusterCardWidget extends StatelessWidget {
  final VoidCallback onStartNavigation;

  const BottomClusterCardWidget({Key? key, required this.onStartNavigation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SellerProvider>();
    final darkText = const Color(0xFF0F374A);
    final primaryBlue = const Color(0xFF0E7DFF);
    final primaryRed = const Color(0xFFFF3B47);
    final greyText = const Color(0xFF8A98A1);
    final lightGreyBg = const Color(0xFFF5F7F9);

    if (provider.selectedCluster == null) return const SizedBox.shrink();

    return Positioned(
      bottom: 30.h,
      left: 20.w,
      right: 20.w,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 4))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(color: primaryRed.withOpacity(0.12), borderRadius: BorderRadius.circular(10.r)),
                  child: Icon(Icons.analytics_outlined, color: primaryRed, size: 24.sp),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.selectedCluster!['nama'],
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: darkText),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "${provider.selectedCluster!['jumlah_minat']} Customer Berminat • ${provider.selectedCluster!['kepadatan']}",
                        style: TextStyle(fontSize: 12.sp, color: greyText, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            const Divider(height: 1, color: Colors.black12),
            SizedBox(height: 12.h),
            Text(
              "Konsumen di area ini:",
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: darkText),
            ),
            SizedBox(height: 8.h),
            SizedBox(
              height: 32.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: provider.selectedCluster!['users'].length,
                itemBuilder: (context, uIndex) {
                  return Container(
                    margin: EdgeInsets.only(right: 8.w),
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: lightGreyBg,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 7.r,
                          backgroundColor: primaryBlue,
                          child: Text(
                            provider.selectedCluster!['users'][uIndex][0].toUpperCase(),
                            style: TextStyle(fontSize: 8.sp, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          provider.selectedCluster!['users'][uIndex],
                          style: TextStyle(fontSize: 12.sp, color: darkText, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              height: 42.h,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                ),
                onPressed: onStartNavigation,
                icon: const Icon(Icons.motorcycle, color: Colors.white),
                label: Text(
                  "Mulai Jalan Ke Sini",
                  style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}