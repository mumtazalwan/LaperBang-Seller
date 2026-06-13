import 'dart:async';
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  bool isLoading = false;

  // Struktur data list chat utama
  final List<Map<String, dynamic>> chatList = [
    {
      'id': 'alwan',
      'name': 'Alwan',
      'lastMessage': 'Halo, mau nanya soal lokasi jajanan nih.',
      'time': '10.30',
      'unread': 1,
      'isAI': false,
    },
    {
      'id': 'cs',
      'name': 'Customer Service',
      'lastMessage': 'Baik kak, keluhan sudah kami terima.',
      'time': 'Kemarin',
      'unread': 0,
      'isAI': false,
    },
  ];

  final List<Map<String, dynamic>> messages = [
    {
      'sender': 'alwan',
      'message': 'Halo, mau nanya soal lokasi jajanan nih.',
      'time': '10.30',
      'type': 'text',
    },
  ];

  // Logika mengirim pesan user dan memicu respon otomatis AI
  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    messages.add({
      'sender': 'user',
      'message': text,
      'time': '03.06',
      'type': 'text',
    });

    // Update rincian baris pesan terakhir pada halaman daftar chat
    final index = chatList.indexWhere(
      (element) => element['id'] == 'vitala_ai',
    );
    if (index != -1) {
      chatList[index]['lastMessage'] = text;
      chatList[index]['time'] = '03.06';
    }

    notifyListeners();
    _simulateAIResponse();
  }

  // Simulasi balasan otomatis dari Vitala-AI
  void _simulateAIResponse() {
    Future.delayed(const Duration(seconds: 1), () {
      messages.add({
        'sender': 'ai',
        'message':
            'Baik, Tapi ga ada..',
        'time': '03.06',
        'type': 'text',
      });

      final index = chatList.indexWhere(
        (element) => element['id'] == 'vitala_ai',
      );
      if (index != -1) {
        chatList[index]['lastMessage'] =
            'Oke deh :)';
        chatList[index]['time'] = '03.06';
      }
      notifyListeners();
    });
  }

  // Logika menghapus lingkaran jumlah indikator pesan belum dibaca
  void clearUnread(String id) {
    final index = chatList.indexWhere((element) => element['id'] == id);
    if (index != -1) {
      chatList[index]['unread'] = 0;
      notifyListeners();
    }
  }
}
