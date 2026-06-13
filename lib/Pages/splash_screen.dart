import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../Services/auth_provider.dart';
import 'login.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSessionAndNavigate();
  }

  Future<void> _checkSessionAndNavigate() async {
    final authProvider = context.read<AuthProvider>();

    final results = await Future.wait([
      authProvider.checkLoginStatus(),
      Future.delayed(const Duration(seconds: 2)),
    ]);

    bool isLoggedIn = results[0] as bool;

    if (!mounted) return;

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SellerLoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryOrange = Colors.orange;

    return Scaffold(
      backgroundColor: primaryOrange,
      body: Center(
        child: Text(
          "LaperBang Seller",
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
