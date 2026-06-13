import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laperbang_seller/Widget/home_widget.dart';
import 'package:provider/provider.dart';
import '../Services/seller_provider.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  final Color darkText = const Color(0xFF0F374A);
  final Color primaryBlue = const Color(0xFF0E7DFF);
  final Color primaryRed = const Color(0xFFFF3B47);
  final Color greyText = const Color(0xFF8A98A1);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SellerProvider>();

    if (provider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18.r,
              backgroundColor: primaryBlue.withOpacity(0.1),
              child: Icon(Icons.storefront, color: primaryBlue, size: 20.sp),
            ),
            SizedBox(width: 10.w),
            Text("LaperBang Seller", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: darkText)),
          ],
        ),
        actions: [
          IconButton(icon: Icon(Icons.notifications_outlined, color: darkText, size: 24.sp), onPressed: () {}),
          SizedBox(width: 10.w),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StatusHeaderWidget(),
            SizedBox(height: 20.h),
            Row(
              children: [
                const MetricCardWidget(label: "Jarak Perjalanan", value: "4.2 Km", icon: Icons.directions_bike, color: Colors.purple),
                SizedBox(width: 12.w),
                const MetricCardWidget(label: "Rating Toko", value: "4.8", icon: Icons.star, color: Colors.amber),
                SizedBox(width: 12.w),
                MetricCardWidget(label: "Total Favorit", value: "124", icon: Icons.favorite, color: primaryRed),
              ],
            ),
            SizedBox(height: 24.h),
            Text("Titik Kumpul Konsumen (High Demand)", style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: darkText)),
            SizedBox(height: 4.h),
            Text("Mendekatlah ke area lingkaran merah untuk potensi orderan tinggi", style: TextStyle(fontSize: 12.sp, color: greyText)),
            SizedBox(height: 12.h),
            const HomeMapPreviewWidget(),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}