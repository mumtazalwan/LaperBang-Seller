import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laperbang_seller/Widget/chat_widget.dart';
import 'package:provider/provider.dart';
import '../Services/chat_provider.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({Key? key}) : super(key: key);

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChatProvider>();
    const Color darkText = Color(0xFF0F374A);
    const Color primaryBlue = Color(0xFF0E7DFF);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [primaryBlue.withOpacity(0.1), Colors.white, Colors.white],
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context, darkText),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                  itemCount: provider.messages.length,
                  itemBuilder: (context, index) {
                    final msg = provider.messages[index];
                    if (msg['sender'] == 'user') {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 20.h),
                        child: UserBubbleWidget(
                          message: msg['message'],
                          time: msg['time'],
                        ),
                      );
                    } else {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 20.h),
                        child: ContactBubbleWidget(
                          msgData: msg,
                          contactName: "Alwan",
                        ),
                      );
                    }
                  },
                ),
              ),
              ChatInputAreaWidget(
                controller: _textController,
                onSend: () {
                  if (_textController.text.trim().isNotEmpty) {
                    provider.sendMessage(_textController.text);
                    _textController.clear();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, Color darkText) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Row(
        children: [
          IconButton(
            icon: Container(
              padding: EdgeInsets.all(8.w),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: darkText,
                size: 18.sp,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              "Alwan",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: darkText,
              ),
            ),
          ),
          SizedBox(width: 48.w),
        ],
      ),
    );
  }
}
