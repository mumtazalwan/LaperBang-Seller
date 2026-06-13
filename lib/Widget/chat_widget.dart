// 3. chat_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatTileWidget extends StatelessWidget {
  final Map<String, dynamic> chat;
  final VoidCallback onTap;

  const ChatTileWidget({Key? key, required this.chat, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color darkText = Color(0xFF0F374A);
    const Color primaryBlue = Color(0xFF0E7DFF);
    const Color greyText = Color(0xFF8A98A1);

    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          CircleAvatar(
            radius: 26.r,
            backgroundColor: primaryBlue.withOpacity(0.1),
            child: Icon(Icons.person, color: primaryBlue, size: 24.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      chat['name'],
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: darkText,
                      ),
                    ),
                    Text(
                      chat['time'],
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: chat['unread'] > 0 ? primaryBlue : greyText,
                        fontWeight: chat['unread'] > 0
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        chat['lastMessage'],
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: chat['unread'] > 0 ? darkText : greyText,
                          fontWeight: chat['unread'] > 0
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (chat['unread'] > 0) ...[
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: const BoxDecoration(
                          color: primaryBlue,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          chat['unread'].toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserBubbleWidget extends StatelessWidget {
  final String message;
  final String time;

  const UserBubbleWidget({Key? key, required this.message, required this.time})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF0E7DFF);

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(left: 40.w),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: primaryBlue,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: Radius.circular(16.r),
            bottomRight: Radius.circular(4.r),
          ),
          boxShadow: [
            BoxShadow(
              color: primaryBlue.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                height: 1.4,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              time,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactBubbleWidget extends StatelessWidget {
  final Map<String, dynamic> msgData;
  final String contactName;

  const ContactBubbleWidget({
    Key? key,
    required this.msgData,
    required this.contactName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color darkText = Color(0xFF0F374A);
    const Color greyText = Color(0xFF8A98A1);
    const Color primaryBlue = Color(0xFF0E7DFF);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 18.r,
          backgroundColor: primaryBlue.withOpacity(0.1),
          child: Icon(Icons.person, color: primaryBlue, size: 18.sp),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                contactName,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.r),
                    topRight: Radius.circular(16.r),
                    bottomLeft: Radius.circular(16.r),
                    bottomRight: Radius.circular(16.r),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      msgData['message'],
                      style: TextStyle(
                        color: darkText,
                        fontSize: 14.sp,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        msgData['time'],
                        style: TextStyle(color: greyText, fontSize: 10.sp),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ChatInputAreaWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatInputAreaWidget({
    Key? key,
    required this.controller,
    required this.onSend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF0E7DFF);
    const Color greyText = Color(0xFF8A98A1);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file, color: greyText),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: "Ketik pesan...",
                        hintStyle: const TextStyle(
                          color: greyText,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: onSend,
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.send, color: primaryBlue, size: 24),
            ),
          ),
        ],
      ),
    );
  }
}
