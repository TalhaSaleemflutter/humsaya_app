import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:humsaya_app/models/ad_product_model.dart';
import 'package:humsaya_app/models/chat_room_model.dart';
import 'package:humsaya_app/providers/ad_provider.dart';
import 'package:humsaya_app/providers/auth_provider.dart' show AuthProvider;
import 'package:humsaya_app/providers/chat_provider.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/views/home/dashboard_screens/chat/Live_chatting_screen.dart';
import 'package:humsaya_app/widgets/custom_listtiles/custom_message_tile.dart';
import 'package:humsaya_app/widgets/custom_tabbars/custom_tabbar_hamsaya_app.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_appbar.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final AdModel? adModel;
  const ChatScreen({super.key, this.adModel});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
      
  late TabController _tabController;
  AdModel? _adModel;
  StreamSubscription<List<ChatRoomModel>>? _chatSubscription;
  List<ChatRoomModel> _allChatRooms = [];
  List<ChatRoomModel> _buyingChats = [];
  List<ChatRoomModel> _sellingChats = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _adModel = widget.adModel;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    // Initialize chat stream
    _initChatStream(authProvider.currentUser.uid, chatProvider);

    if (_adModel == null && widget.adModel?.addId != null) {
      _fetchAdData(widget.adModel!.addId);
    }
  }

  Future<void> _fetchAdData(String adId) async {
    try {
      final adDoc =
          await FirebaseFirestore.instance.collection('ads').doc(adId).get();
      if (adDoc.exists && mounted) {
        setState(() {
          _adModel = AdModel.fromMap(adDoc.data() as Map<String, dynamic>);
        });
      }
    } catch (e) {
      debugPrint('Error fetching ad data: $e');
    }
  }

  void _initChatStream(String currentUserId, ChatProvider chatProvider) {
    _chatSubscription = chatProvider
        .getChatRoomsStream(context, currentUserId)
        .listen((chatRooms) {
          if (mounted) {
            setState(() {
              _allChatRooms = chatRooms;
              _buyingChats = chatProvider.getBuyingChats(currentUserId);
              _sellingChats = chatProvider.getSellingChats(currentUserId);
              _isLoading = false;
            });
          }
        });
  }

  @override
  void dispose() {
    _chatSubscription?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarHeight: 45.h,
        title: 'Chats',
        textStyle: AppTextStyles.appBarHeadingText(context),
        trailingIcon: Icon(CupertinoIcons.ellipsis_vertical),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 22.w, right: 22.w),
        child: Consumer2<ChatProvider, AdProvider>(
          builder: (
            BuildContext context,
            chatProvider,
            adProvider,
            Widget? child,
          ) {
            return Column(
              children: [
                CustomTabBarHumsayaApp(
                  tabTitles: ["All", "Buying", "Selling"],
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  tabController: _tabController,
                ),
                SizedBox(height: 10.h),

                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildAllChatsTab(chatProvider, adProvider),
                      _buildBuyingTab(chatProvider, adProvider),
                      _buildSellingTab(chatProvider, adProvider),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            );
          },
        ),
      ),
    );
  }

  // All chats tab - uses cached data from provider
  Widget _buildAllChatsTab(ChatProvider chatProvider, AdProvider adProvider) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUserId = authProvider.currentUser.uid;
    final chatRooms = chatProvider.allChatRooms;

    if (chatProvider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (chatRooms.isEmpty) {
      return Center(
        child: Text('No chats yet', style: AppTextStyles.fieldText(context)),
      );
    }

    return ListView.builder(
      itemCount: chatRooms.length,
      itemBuilder: (context, index) {
        final chatRoom = chatRooms[index];
        final isCurrentUser = chatRoom.senderId == currentUserId;
        final otherUserName =
            isCurrentUser ? chatRoom.receiverName : chatRoom.senderName;
        final profileImage =
            isCurrentUser ? chatRoom.receiverImage : chatRoom.senderImage;
        final otherUserId =
            isCurrentUser ? chatRoom.receiverId : chatRoom.senderId;

        String adTitle = 'No ad associated';
        if (chatRoom.adId != null) {
          final ad = adProvider.getAdById(chatRoom.adId!);
          adTitle = ad?.title ?? 'Deleted ad';
        }

        return CustomMessageTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => LiveChattingScreen(
                      receiverId: otherUserId,
                      receiverName: otherUserName,
                      adId: chatRoom.adId,
                      receiverUserEmail: '',
                      userAvatar: profileImage ?? '',
                      lastMessage: chatRoom.lastMessage,
                      userName: otherUserName,
                    ),
              ),
            );
          },
          leadingIcon: profileImage,
          name: otherUserName,
          title: adTitle,
          description:
              chatRoom.lastMessage.isNotEmpty
                  ? chatRoom.lastMessage
                  : 'New chat',
          time: _formatTime(chatRoom.lastMessageTime),
          trailingIcon1: chatRoom.isPinned ? Icons.push_pin : null,
          text: chatRoom.unreadCount > 0 ? chatRoom.unreadCount.toString() : '',
          isRead: chatRoom.unreadCount == 0,
        );
      },
    );
  }

  // Buying tab - filters cached data
  Widget _buildBuyingTab(ChatProvider chatProvider, AdProvider adProvider) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUserId = authProvider.currentUser.uid;
    final buyingChats = chatProvider.getBuyingChats(currentUserId);

    if (chatProvider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (buyingChats.isEmpty) {
      return Center(
        child: Text(
          'No buying chats yet',
          style: AppTextStyles.fieldText(context),
        ),
      );
    }

    return ListView.builder(
      itemCount: buyingChats.length,
      itemBuilder: (context, index) {
        final chatRoom = buyingChats[index];
        final otherUserName = chatRoom.senderName;
        final profileImage = chatRoom.senderImage;
        final otherUserId = chatRoom.senderId;

        String adTitle = 'No ad associated';
        if (chatRoom.adId != null) {
          final ad = adProvider.getAdById(chatRoom.adId!);
          adTitle = ad?.title ?? 'Deleted ad';
        }

        return CustomMessageTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => LiveChattingScreen(
                      receiverId: otherUserId,
                      receiverName: otherUserName,
                      adId: chatRoom.adId,
                      receiverUserEmail: '',
                      userAvatar: profileImage ?? '',
                      lastMessage: chatRoom.lastMessage,
                      userName: otherUserName,
                    ),
              ),
            );
          },
          leadingIcon: profileImage,
          name: otherUserName,
          title: adTitle,
          description:
              chatRoom.lastMessage.isNotEmpty
                  ? chatRoom.lastMessage
                  : 'New chat',
          time: _formatTime(chatRoom.lastMessageTime),
          trailingIcon1: chatRoom.isPinned ? Icons.push_pin : null,
          text: chatRoom.unreadCount > 0 ? chatRoom.unreadCount.toString() : '',
          isRead: chatRoom.unreadCount == 0,
        );
      },
    );
  }

  Widget _buildSellingTab(ChatProvider chatProvider, AdProvider adProvider) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUserId = authProvider.currentUser.uid;
    final sellingChats = chatProvider.getSellingChats(currentUserId);

    if (chatProvider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (sellingChats.isEmpty) {
      return Center(
        child: Text(
          'No buying chats yet',
          style: AppTextStyles.fieldText(context),
        ),
      );
    }

    return ListView.builder(
      itemCount: sellingChats.length,
      itemBuilder: (context, index) {
        final chatRoom = sellingChats[index];
        final otherUserName = chatRoom.senderName;
        final profileImage = chatRoom.senderImage;
        final otherUserId = chatRoom.senderId;

        String adTitle = 'No ad associated';
        if (chatRoom.adId != null) {
          final ad = adProvider.getAdById(chatRoom.adId!);
          adTitle = ad?.title ?? 'Deleted ad';
        }

        return CustomMessageTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => LiveChattingScreen(
                      receiverId: otherUserId,
                      receiverName: otherUserName,
                      adId: chatRoom.adId,
                      receiverUserEmail: '',
                      userAvatar: profileImage ?? '',
                      lastMessage: chatRoom.lastMessage,
                      userName: otherUserName,
                    ),
              ),
            );
          },
          leadingIcon: profileImage,
          name: otherUserName,
          title: adTitle,
          description:
              chatRoom.lastMessage.isNotEmpty
                  ? chatRoom.lastMessage
                  : 'New chat',
          time: _formatTime(chatRoom.lastMessageTime),
          trailingIcon1: chatRoom.isPinned ? Icons.push_pin : null,
          text: chatRoom.unreadCount > 0 ? chatRoom.unreadCount.toString() : '',
          isRead: chatRoom.unreadCount == 0,
        );
      },
    );
  }

  String _formatTime(DateTime dateTime) {
    int hour = dateTime.hour % 12;
    hour = hour == 0 ? 12 : hour;
    String period = dateTime.hour < 12 ? 'AM' : 'PM';
    return '$hour:${dateTime.minute.toString().padLeft(2, '0')} $period';
  }
}



