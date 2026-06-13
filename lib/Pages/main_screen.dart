import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:laperbang_seller/Pages/list_chat.dart';
import 'package:laperbang_seller/Pages/home.dart';
import 'package:laperbang_seller/Pages/map.dart';
import '../Services/seller_provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SellerProvider>();

    final List<Widget> pages = [
      const Home(),
      const MapSeller(),
      const ChatListPage(),
    ];

    return Scaffold(
      body: pages[provider.mainTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        ],
        currentIndex: provider.mainTabIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) => context.read<SellerProvider>().changeTab(index),
        backgroundColor: Colors.grey.shade50,
      ),
    );
  }
}