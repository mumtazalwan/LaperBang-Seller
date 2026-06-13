// 4. chat_list_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laperbang_seller/Pages/room_chat.dart';
import 'package:laperbang_seller/Widget/chat_widget.dart';
import 'package:provider/provider.dart';
import '../Services/chat_provider.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChatProvider>();
    const Color darkText = Color(0xFF0F374A);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          "Pesan",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: darkText,
          ),
        ),
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        itemCount: provider.chatList.length,
        separatorBuilder: (context, index) =>
            Divider(color: Colors.grey.shade200, height: 24.h),
        itemBuilder: (context, index) {
          final chat = provider.chatList[index];
          return ChatTileWidget(
            chat: chat,
            onTap: () {
              if (chat['id'] == 'alwan') {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const ChatRoomPage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;

                          var tween = Tween(
                            begin: begin,
                            end: end,
                          ).chain(CurveTween(curve: curve));

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                  ),
                );

                Future.delayed(const Duration(milliseconds: 300), () {
                  provider.clearUnread(chat['id']);
                });
              }
            },
          );
        },
      ),
    );
  }
}
