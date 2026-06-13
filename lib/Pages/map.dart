import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:laperbang_seller/Widget/map_widget.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../Services/seller_provider.dart';

class MapSeller extends StatefulWidget {
  const MapSeller({Key? key}) : super(key: key);

  @override
  State<MapSeller> createState() => _MapSellerState();
}

class _MapSellerState extends State<MapSeller> {
  final MapController _mapController = MapController();
  final Color primaryBlue = const Color(0xFF0E7DFF);
  final Color primaryRed = const Color(0xFFFF3B47);

  void _showPopupDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: primaryBlue,
          ),
        ),
        content: Text(message, style: TextStyle(fontSize: 14.sp)),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text("OK", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _konfirmasiStopNavigasi() {
    final provider = context.read<SellerProvider>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          "Batalkan Perjalanan?",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: primaryRed,
          ),
        ),
        content: Text(
          "Apakah Anda yakin ingin membatalkan perjalanan? Status Anda akan dikembalikan ke Mangkal.",
          style: TextStyle(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Lanjutkan",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryRed,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              provider.stopNavigation();
            },
            child: const Text(
              "Ya, Batalkan",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  LatLngBounds _getBoundsFromRadius(LatLng center, double radiusInMeters) {
    const distance = Distance();
    final north = distance.offset(center, radiusInMeters, 0);
    final east = distance.offset(center, radiusInMeters, 90);
    final south = distance.offset(center, radiusInMeters, 180);
    final west = distance.offset(center, radiusInMeters, 270);
    return LatLngBounds.fromPoints([north, east, south, west]);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SellerProvider>();

    if (provider.isLoading || provider.currentPosition == null) {
      return const Center(child: CircularProgressIndicator());
    }

    double sisaJarakMeter = 0;
    if (provider.targetPosition != null) {
      sisaJarakMeter = const Distance().distance(
        provider.currentPosition!,
        provider.targetPosition!,
      );
    }

    if (provider.selectedCluster != null && provider.trackingTimer == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(provider.selectedCluster!['lokasi'], 17.0);
      });
    }

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCameraFit: CameraFit.bounds(
                bounds: _getBoundsFromRadius(provider.currentPosition!, 1000.0),
                padding: EdgeInsets.all(40.w),
              ),
              onTap: (tapPosition, point) {
                if (provider.trackingTimer != null &&
                    provider.trackingTimer!.isActive) {
                  _konfirmasiStopNavigasi();
                } else {
                  provider.clearClusterSelection();
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.laperbang',
              ),
              CircleLayer(
                circles: [
                  for (var cluster in provider.clusterSekitar)
                    CircleMarker(
                      point: cluster['lokasi'],
                      color: primaryRed.withOpacity(0.12),
                      borderColor: primaryRed.withOpacity(0.4),
                      borderStrokeWidth: 1.5,
                      useRadiusInMeter: true,
                      radius: 150.0,
                    ),
                ],
              ),
              if (provider.rutePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: provider.rutePoints,
                      color: primaryBlue,
                      strokeWidth: 7.0,
                      strokeCap: StrokeCap.round,
                    ),
                  ],
                )
              else if (provider.previewRuteBerantai.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: provider.previewRuteBerantai,
                      color: primaryBlue.withOpacity(0.4),
                      strokeWidth: 4.5,
                      strokeCap: StrokeCap.round,
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
                      width: 44,
                      height: 44,
                      child: GestureDetector(
                        onTap: () {
                          provider.selectCluster(cluster);
                          _mapController.move(cluster['lokasi'], 17.0);
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: primaryRed,
                                shape: BoxShape.circle,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.groups,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),

          if (provider.targetPosition != null)
            TopNavigationPanelWidget(
              sisaJarakMeter: sisaJarakMeter,
              onCancel: _konfirmasiStopNavigasi,
            ),

          if (provider.selectedCluster != null && provider.rutePoints.isEmpty)
            BottomClusterCardWidget(
              onStartNavigation: () {
                provider.startNavigation(
                  () => _showPopupDialog(
                    "Sudah Sampai",
                    "Anda telah sampai di lokasi kluster tujuan. Sistem telah mengaktifkan lapak Anda kembali!",
                  ),
                  (errorMsg) => _showPopupDialog("Koneksi Lemah", errorMsg),
                  (newPos) =>
                      _mapController.move(newPos, _mapController.camera.zoom),
                );
              },
            ),
        ],
      ),
    );
  }
}
