import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SellerProvider extends ChangeNotifier {
  LatLng? currentPosition;
  bool isLoading = true;

  int mainTabIndex = 0;

  int selectedStatusIndex = 0;
  final List<Map<String, dynamic>> statusOptions = [
    {
      "value": "active",
      "title": "Active / Mangkal",
      "rules": "Bisa Diikuti & Bisa Dipanggil",
      "icon": Icons.storefront,
      "mapIcon": Icons.local_shipping_outlined,
      "color": const Color(0xFF0E7DFF),
    },
    {
      "value": "moving",
      "title": "Moving / Jalan",
      "rules": "Bisa Diikuti & Ga Bisa Dipanggil",
      "icon": Icons.directions_run,
      "mapIcon": Icons.electric_moped_outlined,
      "color": Colors.orange,
    },
    {
      "value": "idle",
      "title": "Idle / Istirahat",
      "rules": "Bisa Diikuti & Ga Bisa Dipanggil",
      "icon": Icons.coffee,
      "mapIcon": Icons.delivery_dining_outlined,
      "color": Colors.amber,
    },
    {
      "value": "closed",
      "title": "Close / Tutup",
      "rules": "Ga Bisa Diikuti & Ga Bisa Dipanggil",
      "icon": Icons.cancel,
      "mapIcon": Icons.door_back_door_outlined,
      "color": Color(0xFFFF3B47),
    },
  ];

  List<Map<String, dynamic>> clusterSekitar = [];
  Map<String, dynamic>? selectedCluster;
  LatLng? targetPosition;

  List<LatLng> previewRuteBerantai = [];
  List<LatLng> rutePoints = [];
  Timer? trackingTimer;

  Map<String, dynamic> get currentStatus => statusOptions[selectedStatusIndex];

  Future<void> initData() async {
    LatLng posisiAwal;

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        isLoading = false;
        notifyListeners();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          isLoading = false;
          notifyListeners();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        isLoading = false;
        notifyListeners();
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 5),
      );
      posisiAwal = LatLng(position.latitude, position.longitude);
    } catch (e) {
      debugPrint("GPS Error, fallback ke default: $e");
      posisiAwal = const LatLng(-6.43202, 106.80898);
    }

    List<Map<String, dynamic>> rawClusters = [
      {
        'id': 1,
        'nama': 'Cluster Stasiun Citayam',
        'jumlah_minat': 45,
        'kepadatan': 'Sangat Padat',
        'users': [
          'Budi Santoso',
          'Siti Rahma',
          'Axel',
          'Alva Jufinto',
          'Gading',
          'Rian',
          'Mega',
        ],
        'lokasi': LatLng(
          posisiAwal.latitude + 0.0035,
          posisiAwal.longitude + 0.0030,
        ),
      },
      {
        'id': 2,
        'nama': 'Cluster Taman Perumahan',
        'jumlah_minat': 18,
        'kepadatan': 'Ramai',
        'users': ['Dewi', 'Hendra', 'Aris', 'Fanny', 'Roni'],
        'lokasi': LatLng(
          posisiAwal.latitude - 0.0040,
          posisiAwal.longitude - 0.0035,
        ),
      },
      {
        'id': 3,
        'nama': 'Cluster Area Kampus',
        'jumlah_minat': 62,
        'kepadatan': 'Sangat Padat',
        'users': [
          'Dimas',
          'Chandra',
          'Reza',
          'Amel',
          'Putri',
          'Taufik',
          'Dodi',
        ],
        'lokasi': LatLng(
          posisiAwal.latitude + 0.0015,
          posisiAwal.longitude - 0.0045,
        ),
      },
    ];

    const distanceCalc = Distance();
    rawClusters.sort((a, b) {
      double jarakA = distanceCalc.distance(posisiAwal, a['lokasi']);
      double jarakB = distanceCalc.distance(posisiAwal, b['lokasi']);
      return jarakA.compareTo(jarakB);
    });

    List<LatLng> jalurBerantai = await _getMultiPointRouteOSRM(
      posisiAwal,
      rawClusters,
    );

    currentPosition = posisiAwal;
    clusterSekitar = rawClusters;
    previewRuteBerantai = jalurBerantai;
    isLoading = false;
    notifyListeners();
  }

  Future<bool> changeStatus(int index) async {
    final status = statusOptions[index]["value"];

    bool success = await updateVendorStatus(status);

    if (success) {
      selectedStatusIndex = index;
      notifyListeners();
    }

    return success;
  }

  void changeTab(int index) {
    mainTabIndex = index;
    if (index != 1 && trackingTimer == null) {
      clearClusterSelection();
    }
    notifyListeners();
  }

  void selectClusterAndGoToMap(Map<String, dynamic> cluster) {
    selectedCluster = cluster;
    targetPosition = cluster['lokasi'];
    mainTabIndex = 1;
    notifyListeners();
  }

  void selectCluster(Map<String, dynamic> cluster) {
    selectedCluster = cluster;
    targetPosition = cluster['lokasi'];
    notifyListeners();
  }

  void clearClusterSelection() {
    selectedCluster = null;
    targetPosition = null;
    rutePoints.clear();
    notifyListeners();
  }

  Future<List<LatLng>> _getMultiPointRouteOSRM(
    LatLng start,
    List<Map<String, dynamic>> sortedClusters,
  ) async {
    if (sortedClusters.isEmpty) return [];
    String coords = "${start.longitude},${start.latitude}";
    for (var cluster in sortedClusters) {
      LatLng loc = cluster['lokasi'];
      coords += ";${loc.longitude},${loc.latitude}";
    }

    final url =
        'https://router.project-osrm.org/route/v1/driving/$coords?geometries=geojson';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List coordinates = data['routes'][0]['geometry']['coordinates'];
        return coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
      }
    } catch (e) {
      debugPrint("API Error: $e");
    }
    return [];
  }

  Future<List<LatLng>> _getRouteOSRM(LatLng start, LatLng end) async {
    final url =
        'https://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?geometries=geojson';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List coordinates = data['routes'][0]['geometry']['coordinates'];
        return coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
      }
    } catch (e) {
      debugPrint("API Error: $e");
    }
    return [];
  }

  Future<bool> updateVendorStatus(String status) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token");

    final url = Uri.parse(
      "https://laper-bang-backend.vercel.app/api/v1/vendors/status",
    );

    final response = await http.patch(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({"status": status}),
    );

    print("========== RESPONSE ==========");
    print("Status Code : ${response.statusCode}");
    print("Body        : ${response.body}");
    print("==============================");

    return response.statusCode == 200;
  }

  void startNavigation(
    VoidCallback onArrival,
    Function(String) onError,
    Function(LatLng) onMapMove,
  ) async {
    if (selectedCluster == null || currentPosition == null) return;

    trackingTimer?.cancel();
    rutePoints.clear();

    LatLng posisiCluster = selectedCluster!['lokasi'];
    List<LatLng> jalurJalan = await _getRouteOSRM(
      currentPosition!,
      posisiCluster,
    );

    if (jalurJalan.isEmpty) {
      onError("Gagal kalkulasi rute jalan OSRM.");
      return;
    }

    rutePoints = jalurJalan;
    selectedStatusIndex = 1;
    notifyListeners();

    onMapMove(currentPosition!);

    trackingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (rutePoints.length > 1) {
        rutePoints.removeAt(0);
        currentPosition = rutePoints[0];
        rutePoints = List<LatLng>.from(rutePoints);
        notifyListeners();
        onMapMove(currentPosition!);
      } else {
        timer.cancel();
        selectedStatusIndex = 0;
        rutePoints.clear();
        selectedCluster = null;
        targetPosition = null;
        notifyListeners();

        onArrival();
        initData();
      }
    });
  }

  void stopNavigation() {
    trackingTimer?.cancel();
    rutePoints.clear();
    selectedCluster = null;
    targetPosition = null;
    selectedStatusIndex = 0;
    notifyListeners();
    initData();
  }

  @override
  void dispose() {
    trackingTimer?.cancel();
    super.dispose();
  }
}
