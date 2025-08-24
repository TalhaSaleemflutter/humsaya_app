import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:humsaya_app/models/ad_product_model.dart';
import 'package:humsaya_app/models/message_model.dart';
import 'package:humsaya_app/providers/auth_provider.dart' show AuthProvider;
import 'package:humsaya_app/providers/chat_provider.dart';
import 'package:humsaya_app/shared/constants/app_assets.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/shared/theme/app_palette.dart' as AppPalette;
import 'package:humsaya_app/shared/theme/theme_helper.dart';
import 'package:provider/provider.dart';

class LiveChattingScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  final String userAvatar;
  final String? adId;
  final AdModel? adModel;

  const LiveChattingScreen({
    super.key,
    required this.receiverId,
    required this.receiverName,
    required this.userAvatar,
    this.adId,
    this.adModel,
    required String receiverUserEmail,
    required String lastMessage,
    required String userName,
  });

  @override
  State<LiveChattingScreen> createState() => _LiveChattingScreenState();
}

class _LiveChattingScreenState extends State<LiveChattingScreen> {
  final TextEditingController _messageController = TextEditingController();
  late String _chatRoomId;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    List<String> ids = [authProvider.currentUser.uid, widget.receiverId];
    ids.sort();
    _chatRoomId = ids.join("_");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatProvider>(
        context,
        listen: false,
      ).markMessagesAsRead(_chatRoomId, authProvider.currentUser.uid);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    await chatProvider.sendMessage(
      context,
      widget.adId.toString(),
      widget.receiverId,
      _messageController.text.trim(),
    );
    _messageController.clear();
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final period = dateTime.hour < 12 ? 'AM' : 'PM';
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        titleSpacing: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          behavior: HitTestBehavior.translucent,
          child: Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(
              AppAssets.icBack,
              height: 22.h,
              width: 22.w,
              color: Theme.of(context).appBarTheme.foregroundColor,
            ),
          ),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  widget.userAvatar.isNotEmpty
                      ? NetworkImage(widget.userAvatar) as ImageProvider
                      : AssetImage(AppAssets.girl2),
              radius: 22.r,
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.receiverName,
                  style: AppTextStyles.subHeadingText(context),
                ),
                Text(
                  "Online",
                  style: AppTextStyles.fieldText(
                    context,
                  ).copyWith(fontSize: 12.sp, color: Colors.green),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: ThemeHelper.getBlackWhite(context),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [Expanded(child: _buildMessageList()), _buildMessageInput()],
      ),
    );
  }

  Widget _buildMessageList() {
    final chatProvider = Provider.of<ChatProvider>(context);
    return StreamBuilder<List<MessageModel>>(
      stream: chatProvider.getMessages(_chatRoomId),
      builder: (context, snapshot) {
        // Add this to prevent unnecessary rebuilds
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final messages = snapshot.data ?? [];
        if (messages.isEmpty) return Center(child: Text('No messages yet'));

        return ListView.builder(
          controller: _scrollController,
          reverse: true,
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            return _buildMessageItem(message);
          },
        );
      },
    );
  }

  Widget _buildMessageItem(MessageModel message) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isMe = message.senderId == authProvider.currentUser.uid;

    return Container(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      margin: EdgeInsets.symmetric(vertical: 4.h),
      child: ChatBubble(
        message: message.message,
        isMe: isMe,
        time: _formatTime(message.sendAt),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: ThemeHelper.getCardColor(context),
        border: Border(
          top: BorderSide(
            color: ThemeHelper.getFieldBorderColor(context),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.add, color: ThemeHelper.getBlackWhite(context)),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Type a message...",
                hintStyle: AppTextStyles.fieldText(context),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: ThemeHelper.getFieldColor(context),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 12.h,
                ),
              ),
              onSubmitted: (_) => sendMessage(),
            ),
          ),
          SizedBox(width: 8.w),
          CircleAvatar(
            backgroundColor: AppPalette.primary,
            child: IconButton(
              icon: Icon(Icons.send, color: Colors.white),
              onPressed: sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String time;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 280.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isMe ? AppPalette.primary : ThemeHelper.getCardColor(context),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isMe ? 16.r : 0),
          topRight: Radius.circular(isMe ? 0 : 16.r),
          bottomLeft: Radius.circular(16.r),
          bottomRight: Radius.circular(16.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(
              color: isMe ? Colors.white : ThemeHelper.getBlackWhite(context),
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            time,
            style: TextStyle(
              color: isMe ? Colors.white70 : Colors.grey,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}
