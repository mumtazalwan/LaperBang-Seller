import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import '../Services/seller_provider.dart';

class StatusHeaderWidget extends StatelessWidget {
  const StatusHeaderWidget({Key? key}) : super(key: key);

  void _showStatusPicker(BuildContext context, SellerProvider provider) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (bottomSheetContext) {
        return Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
            ),
            color: Colors.grey.shade50,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Pilih Status Operasional",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F374A),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                "Status menentukan hak akses konsumen pada aplikasi",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF8A98A1),
                ),
              ),
              SizedBox(height: 16.h),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.statusOptions.length,
                itemBuilder: (context, index) {
                  final status = provider.statusOptions[index];
                  bool isCurrent = provider.selectedStatusIndex == index;

                  return Container(
                    margin: EdgeInsets.only(bottom: 10.h),
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? status['color'].withOpacity(0.05)
                          : Colors.white,
                      border: Border.all(
                        color: isCurrent
                            ? status['color']
                            : Colors.grey.shade200,
                        width: isCurrent ? 1.5 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: status['color'].withOpacity(0.12),
                        child: Icon(
                          status['icon'],
                          color: status['color'],
                          size: 20.sp,
                        ),
                      ),
                      title: Text(
                        status['title'],
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0F374A),
                        ),
                      ),
                      subtitle: Text(
                        status['rules'],
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF8A98A1),
                        ),
                      ),
                      trailing: isCurrent
                          ? Icon(Icons.check_circle, color: status['color'])
                          : null,
                      onTap: () async {
                        bool success = await provider.changeStatus(index);

                        Navigator.pop(bottomSheetContext);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              success
                                  ? "Status berhasil diubah"
                                  : "Gagal mengubah status",
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SellerProvider>();
    final currentStatus = provider.currentStatus;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: currentStatus['color'].withOpacity(0.06),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: currentStatus['color'].withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22.r,
            backgroundColor: currentStatus['color'].withOpacity(0.15),
            child: Icon(
              currentStatus['icon'],
              color: currentStatus['color'],
              size: 22.sp,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Status Operasional Anda:",
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: const Color(0xFF8A98A1),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  currentStatus['title'],
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: currentStatus['color'],
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  currentStatus['rules'],
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: const Color(0xFF0F374A).withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: currentStatus['color'],
              side: BorderSide(color: currentStatus['color']),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
              minimumSize: Size.zero,
            ),
            onPressed: () => _showStatusPicker(context, provider),
            child: Text(
              'Ubah',
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class MetricCardWidget extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const MetricCardWidget({
    Key? key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.01),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 18.sp),
            ),
            SizedBox(height: 10.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F374A),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(fontSize: 11.sp, color: const Color(0xFF8A98A1)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class HomeMapPreviewWidget extends StatelessWidget {
  const HomeMapPreviewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SellerProvider>();

    return Container(
      width: double.infinity,
      height: 280.h,
      decoration: BoxDecoration(
        color: Colors.white,
        //borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        //borderRadius: BorderRadius.circular(16.r),
        child: provider.currentPosition == null
            ? const Center(child: Text('Gagal sinkronisasi GPS'))
            : FlutterMap(
                options: MapOptions(
                  initialCenter: provider.currentPosition!,
                  initialZoom: 14.5,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.laperbang',
                  ),
                  CircleLayer(
                    circles: [
                      for (var cluster in provider.clusterSekitar)
                        CircleMarker(
                          point: cluster['lokasi'],
                          color: const Color(0xFFFF3B47).withOpacity(0.12),
                          borderColor: const Color(0xFFFF3B47).withOpacity(0.4),
                          borderStrokeWidth: 1.5,
                          useRadiusInMeter: true,
                          radius: 150.0,
                        ),
                    ],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: provider.currentPosition!,
                        width: 40.w,
                        height: 40.h,
                        child: Container(
                          decoration: BoxDecoration(
                            color: provider.currentStatus['color'],
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2.5),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            provider.currentStatus['mapIcon'],
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                      ),
                      for (var cluster in provider.clusterSekitar)
                        Marker(
                          point: cluster['lokasi'],
                          width: 30,
                          height: 30,
                          child: GestureDetector(
                            onTap: () {
                              provider.selectClusterAndGoToMap(cluster);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF3B47),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.groups,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
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
