import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laperbang_seller/Widget/auth_widget.dart';
import 'package:provider/provider.dart';
import '../Services/auth_provider.dart';

class SellerRegisterPage extends StatefulWidget {
  const SellerRegisterPage({Key? key}) : super(key: key);

  @override
  State<SellerRegisterPage> createState() => _SellerRegisterPageState();
}

class _SellerRegisterPageState extends State<SellerRegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    const Color darkText = Color(0xFF0F374A);

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
                "Buka Warung",
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),
              Text(
                "Mulai berjualan di LaperBang Seller",
                style: TextStyle(fontSize: 14.sp, color: Colors.grey),
              ),
              SizedBox(height: 30.h),
              AuthTextField(
                controller: _usernameController,
                label: "Username",
                hint: "warung_enak",
              ),
              SizedBox(height: 15.h),
              AuthTextField(
                controller: _nameController,
                label: "Nama Warung",
                hint: "Sate Padang Ajo",
              ),
              SizedBox(height: 15.h),
              AuthTextField(
                controller: _emailController,
                label: "Email Warung",
                hint: "ajo@mail.com",
              ),
              SizedBox(height: 15.h),
              AuthTextField(
                controller: _passwordController,
                label: "Password",
                hint: "••••••••",
                isPassword: true,
                obscureText: !authProvider.isPasswordVisible,
                onToggleVisibility: () =>
                    authProvider.togglePasswordVisibility(),
              ),
              SizedBox(height: 40.h),
              PrimaryButton(
                label: authProvider.isLoading
                    ? "Mendaftarkan..."
                    : "Daftar Jadi Seller",
                onPressed: () async {
                  if (authProvider.isLoading) return;

                  if (_usernameController.text.isEmpty ||
                      _nameController.text.isEmpty ||
                      _emailController.text.isEmpty ||
                      _passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Harap isi semua kolom.')),
                    );
                    return;
                  }

                  bool success = await authProvider.register(
                    username: _usernameController.text,
                    name: _nameController.text,
                    email: _emailController.text,
                    password: _passwordController.text,
                    role: 'vendor',
                  );

                  if (success) {
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Pendaftaran Seller Berhasil! Silakan Login.',
                          ),
                        ),
                      );
                    }
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pendaftaran gagal. Coba lagi.'),
                        ),
                      );
                    }
                  }
                },
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
