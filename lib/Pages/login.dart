import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laperbang_seller/Widget/auth_widget.dart';
import 'package:provider/provider.dart';
import '../Services/auth_provider.dart';
import 'register.dart';
import 'main_screen.dart'; // ⭐️ Pastikan import halaman MainScreen ditambahkan

class SellerLoginPage extends StatefulWidget {
  const SellerLoginPage({Key? key}) : super(key: key);

  @override
  State<SellerLoginPage> createState() => _SellerLoginPageState();
}

class _SellerLoginPageState extends State<SellerLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    const Color darkText = Color(0xFF0F374A);
    const Color primaryOrange = Colors.orange;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: darkText),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              Text(
                "Seller Login",
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: primaryOrange,
                ),
              ),
              Text(
                "Masuk ke dashboard warung Anda",
                style: TextStyle(fontSize: 14.sp, color: Colors.grey),
              ),
              SizedBox(height: 40.h),
              AuthTextField(
                controller: _emailController,
                label: "Email Seller",
                hint: "vendor@laperbang.com",
              ),
              SizedBox(height: 25.h),
              AuthTextField(
                controller: _passwordController,
                label: "Password",
                hint: "••••••••",
                isPassword: true,
                obscureText: !authProvider.isPasswordVisible,
                onToggleVisibility: () =>
                    authProvider.togglePasswordVisibility(),
              ),
              SizedBox(height: 50.h),
              PrimaryButton(
                label: authProvider.isLoading
                    ? "Masuk..."
                    : "Masuk ke Dashboard",
                onPressed: () async {
                  if (authProvider.isLoading) return;

                  if (_emailController.text.isEmpty ||
                      _passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Harap isi email dan password.'),
                      ),
                    );
                    return;
                  }

                  bool success = await authProvider.login(
                    _emailController.text,
                    _passwordController.text,
                  );

                  if (success) {
                    if (context.mounted) {
                      if (authProvider.currentUser?.role == 'vendor') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Selamat datang, Seller!'),
                          ),
                        );
                        // ⭐️ PERBAIKAN: Tambahkan navigasi ini agar pindah halaman
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainScreen(),
                          ),
                        );
                      } else {
                        authProvider.logout();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Gagal: Akun ini bukan akun Seller!'),
                          ),
                        );
                      }
                    }
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Login gagal. Periksa kredensial Anda.',
                          ),
                        ),
                      );
                    }
                  }
                },
              ),
              SizedBox(height: 30.h),
              Center(
                child: Column(
                  children: [
                    Text(
                      "Belum punya warung?",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: darkText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SellerRegisterPage(),
                          ),
                        );
                      },
                      child: Text(
                        "Daftar Seller",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: primaryOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
