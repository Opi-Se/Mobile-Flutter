import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../cubits/chat_cubit.dart';

class ChatTextField extends StatelessWidget {
  const ChatTextField({super.key, required this.cubit});

  final ChatCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200, width: 1.w),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            padding: EdgeInsets.zero,
            icon: Icon(
              CupertinoIcons.paperclip,
              color: const Color(0XFF000E08).withOpacity(0.5),
              size: 24.sp,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF3F6F6),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: TextField(
                controller: cubit.messageController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 12.h,
                  ),
                  hintText: 'Type a message',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              if (cubit.messageController.text.isNotEmpty) {
                cubit.sendMessage(
                  '657864d6b9aeadd65b0d92b9',
                  '6544fb51e09bf066c237cc48',
                  'Hello',
                  'text',
                );
              }
            },
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.send,
              color: const Color(0XFF000E08).withOpacity(0.5),
              size: 24.sp,
            ),
          ),
        ],
      ),
    );
  }
}
