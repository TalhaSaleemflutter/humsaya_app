import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:humsaya_app/models/chat_room_model.dart';
import 'package:humsaya_app/models/message_model.dart';
import 'package:humsaya_app/providers/auth_provider.dart' show AuthProvider;
import 'package:humsaya_app/shared/constants/app_assets.dart';
import 'package:provider/provider.dart' show Provider;

class ChatProvider extends ChangeNotifier {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  List<ChatRoomModel> _chatRooms = [];
  List<ChatRoomModel> get chatRooms => _chatRooms;

  String? _currentChatRoomId;
  String? get currentChatRoomId => _currentChatRoomId;

  List<ChatRoomModel> _allChatRooms = [];
  bool _isLoading = false;

  List<ChatRoomModel> get allChatRooms => _allChatRooms;
  bool get isLoading => _isLoading;

  Future<void> sendMessage(
    BuildContext context,
    String adId,
    String receiverId,
    String message,
  ) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUserId = authProvider.currentUser.uid;
    final currentUserName = authProvider.currentUser.name;
    final currentUserImage =
        authProvider.currentUser.profileImage ?? AppAssets.appIcon;

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    MessageModel newMessage = MessageModel(
      adId: adId,
      receiverId: receiverId,
      senderId: currentUserId,
      message: message,
      uid: currentUserId,
      name: currentUserName,
      dpImage: currentUserImage,
      sendAt: DateTime.now(),
      messageCount: 0,
      isPinned: false,
      messageId: '',
      isRead: false,
    );

    await _fireStore.collection('chat_rooms').doc(chatRoomId).set({
      'adId': adId,
      'senderId': currentUserId,
      'receiverId': receiverId,
      'lastMessage': message,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'lastMessageSenderId': currentUserId,
      'unreadCount': FieldValue.increment(1),
      'participants': [currentUserId, receiverId],
      'senderImage': currentUserImage,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await _fireStore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());

    notifyListeners();
  }

  Stream<List<MessageModel>> getMessages(String chatRoomId) {
    return _fireStore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('sendAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => MessageModel.fromMap(doc.data()))
                  .toList(),
        );
  }

  Stream<List<ChatRoomModel>> getChatRoomsStream(
    BuildContext context,
    String currentUserId,
  ) {
    return _fireStore
        .collection('chat_rooms')
        .where('participants', arrayContains: currentUserId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .handleError((error) {
          debugPrint('Error getting chat rooms: $error');
          return Stream.empty();
        })
        .asyncMap((snapshot) async {
          _isLoading = true;
          notifyListeners();
          try {
            _allChatRooms = await _processChatRooms(
              snapshot,
              context,
              currentUserId,
            );
            return _allChatRooms;
          } finally {
            _isLoading = false;
            notifyListeners();
          }
        });
  }

  Future<List<ChatRoomModel>> _processChatRooms(
    QuerySnapshot snapshot,
    BuildContext context,
    String currentUserId,
  ) async {
    final chatRooms = <ChatRoomModel>[]; 

    for (final doc in snapshot.docs) {
      try {
        final data = doc.data() as Map<String, dynamic>;
        final isCurrentUserSender = data['senderId'] == currentUserId;
        final senderImage = data['senderImage'] as String? ?? AppAssets.appIcon;
        final senderName = data['senderName'] as String? ?? 'Unknown User';
        final receiverImage =
            data['receiverImage'] as String? ?? AppAssets.appIcon;
        final receiverName = data['receiverName'] as String? ?? 'Unknown User';

        // Get current user's profile image once
        final currentUserImage =
            Provider.of<AuthProvider>(
              context,
              listen: false,
            ).currentUser?.profileImage ??
            AppAssets.appIcon;

        var chatRoom = ChatRoomModel(
          chatRoomId: doc.id,
          senderId: data['senderId'] as String? ?? '',
          senderName: isCurrentUserSender ? 'You' : senderName,
          senderImage: isCurrentUserSender ? currentUserImage : senderImage,
          receiverId: data['receiverId'] as String? ?? '',
          receiverName: !isCurrentUserSender ? 'You' : receiverName,
          receiverImage:
              !isCurrentUserSender ? currentUserImage : receiverImage,
          lastMessage: data['lastMessage'] as String? ?? '',
          lastMessageTime:
              (data['lastMessageTime'] as Timestamp?)?.toDate() ??
              DateTime.now(),
          unreadCount:
              (data['lastMessageSenderId'] == currentUserId)
                  ? 0 // Don't show unread for my own messages
                  : (data['unreadCount'] as int? ?? 0),
          isPinned: data['isPinned'] as bool? ?? false,
          isGroupChat: false,
          participants: List<String>.from(
            data['participants'] as List<dynamic>? ?? [],
          ),
          createdAt:
              (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          lastMessageSenderId: data['lastMessageSenderId'] as String?,
          adId: data['adId'] as String?,
        );

        if ((senderName == 'Unknown User' || receiverName == 'Unknown User') &&
            data['receiverId'] != null) {
          final otherUserId =
              isCurrentUserSender
                  ? data['receiverId'] as String
                  : data['senderId'] as String;

          if (otherUserId.isNotEmpty) {
            final userDoc =
                await _fireStore.collection('users').doc(otherUserId).get();
            if (userDoc.exists) {
              final userData = userDoc.data() as Map<String, dynamic>? ?? {};
              chatRoom = chatRoom.copyWith(
                senderName:
                    isCurrentUserSender
                        ? 'You'
                        : userData['name'] as String? ?? 'Unknown User',
                receiverName:
                    !isCurrentUserSender
                        ? 'You'
                        : userData['name'] as String? ?? 'Unknown User',
                senderImage:
                    isCurrentUserSender
                        ? currentUserImage
                        : userData['profileImage'] as String? ??
                            AppAssets.appIcon,
                receiverImage:
                    !isCurrentUserSender
                        ? currentUserImage
                        : userData['profileImage'] as String? ??
                            AppAssets.appIcon,
              );
            }
          }
        }
        chatRooms.add(chatRoom);
      } catch (e) {
        debugPrint('Error processing chat room ${doc.id}: $e');
      }
    }
    return chatRooms;
  }

  List<ChatRoomModel> getBuyingChats(String currentUserId) {
    return _allChatRooms
        .where((chatRoom) => chatRoom.receiverId == currentUserId)
        .toList();
  }

  List<ChatRoomModel> getSellingChats(String currentUserId) {
    return _allChatRooms
        .where((chatRoom) => chatRoom.senderId == currentUserId)
        .toList();
  }

  Future<void> markMessagesAsRead(
    String chatRoomId,
    String currentUserId,
  ) async {
    final messages =
        await _fireStore
            .collection('chat_rooms')
            .doc(chatRoomId)
            .collection('messages')
            .where('receiverId', isEqualTo: currentUserId)
            .where('isRead', isEqualTo: false)
            .get();

    final batch = _fireStore.batch();
    for (var doc in messages.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();

    await _fireStore.collection('chat_rooms').doc(chatRoomId).update({
      'unreadCount': 0,
    });
  }

  // Stream<List<ChatRoomModel>> getChatRoomsStream(
  //   BuildContext context,
  //   String currentUserId,
  // ) {
  //   return _fireStore
  //       .collection('chat_rooms')
  //       .where('participants', arrayContains: currentUserId)
  //       .orderBy('lastMessageTime', descending: true)
  //       .snapshots()
  //       .handleError((error) {
  //         debugPrint('Error getting chat rooms: $error');
  //         return Stream.empty();
  //       })
  //       .asyncMap((snapshot) async {
  //         try {
  //           final chatRooms = <ChatRoomModel>[];

  //           for (final doc in snapshot.docs) {
  //             try {
  //               final data = doc.data();
  //               final isCurrentUserSender = data['senderId'] == currentUserId;
  //               final senderImage =
  //                   data['senderImage'] as String? ?? AppAssets.appIcon;
  //               final senderName =
  //                   data['senderName'] as String? ?? 'Unknown User';
  //               final receiverImage =
  //                   data['receiverImage'] as String? ?? AppAssets.appIcon;
  //               final receiverName =
  //                   data['receiverName'] as String? ?? 'Unknown User';

  //               var chatRoom = ChatRoomModel(
  //                 chatRoomId: doc.id,
  //                 senderId: data['senderId'] as String? ?? '',
  //                 senderName: isCurrentUserSender ? 'You' : senderName,
  //                 senderImage:
  //                     isCurrentUserSender
  //                         ? (Provider.of<AuthProvider>(
  //                               context,
  //                               listen: false,
  //                             ).currentUser?.profileImage ??
  //                             AppAssets.appIcon)
  //                         : senderImage,
  //                 receiverId: data['receiverId'] as String? ?? '',
  //                 receiverName: !isCurrentUserSender ? 'You' : receiverName,
  //                 receiverImage:
  //                     !isCurrentUserSender
  //                         ? (Provider.of<AuthProvider>(
  //                               context,
  //                               listen: false,
  //                             ).currentUser?.profileImage ??
  //                             AppAssets.appIcon)
  //                         : receiverImage,
  //                 lastMessage: data['lastMessage'] as String? ?? '',
  //                 lastMessageTime:
  //                     (data['lastMessageTime'] as Timestamp?)?.toDate() ??
  //                     DateTime.now(),
  //                 unreadCount: data['unreadCount'] as int? ?? 0,
  //                 isPinned: data['isPinned'] as bool? ?? false,
  //                 isGroupChat: false,
  //                 participants: List<String>.from(
  //                   data['participants'] as List<dynamic>? ?? [],
  //                 ),
  //                 createdAt:
  //                     (data['createdAt'] as Timestamp?)?.toDate() ??
  //                     DateTime.now(),
  //                 lastMessageSenderId: data['lastMessageSenderId'] as String?,
  //                 adId: data['adId'] as String?,
  //               );
  //               if ((senderName == 'Unknown User' ||
  //                       receiverName == 'Unknown User') &&
  //                   data['receiverId'] != null) {
  //                 final otherUserId =
  //                     isCurrentUserSender
  //                         ? data['receiverId'] as String
  //                         : data['senderId'] as String;

  //                 if (otherUserId.isNotEmpty) {
  //                   final userDoc =
  //                       await _fireStore
  //                           .collection('users')
  //                           .doc(otherUserId)
  //                           .get();
  //                   if (userDoc.exists) {
  //                     final userData = userDoc.data() ?? {};
  //                     chatRoom = chatRoom.copyWith(
  //                       senderName:
  //                           isCurrentUserSender
  //                               ? 'You'
  //                               : userData['name'] as String? ?? 'Unknown User',
  //                       receiverName:
  //                           !isCurrentUserSender
  //                               ? 'You'
  //                               : userData['name'] as String? ?? 'Unknown User',
  //                       senderImage:
  //                           isCurrentUserSender
  //                               ? (Provider.of<AuthProvider>(
  //                                     context,
  //                                     listen: false,
  //                                   ).currentUser?.profileImage ??
  //                                   AppAssets.appIcon)
  //                               : userData['profileImage'] as String? ??
  //                                   AppAssets.appIcon,
  //                       receiverImage:
  //                           !isCurrentUserSender
  //                               ? (Provider.of<AuthProvider>(
  //                                     context,
  //                                     listen: false,
  //                                   ).currentUser?.profileImage ??
  //                                   AppAssets.appIcon)
  //                               : userData['profileImage'] as String? ??
  //                                   AppAssets.appIcon,
  //                     );
  //                   }
  //                 }
  //               }
  //               chatRooms.add(chatRoom);
  //             } catch (e) {
  //               debugPrint('Error processing chat room ${doc.id}: $e');
  //             }
  //           }
  //           return chatRooms;
  //         } catch (e) {
  //           debugPrint('Error mapping chat rooms: $e');
  //           return <ChatRoomModel>[];
  //         }
  //       });
  // }

  // Future<void> fetchUserChatRooms(BuildContext context) async {
  //   final authProvider = Provider.of<AuthProvider>(context, listen: false);
  //   final currentUser = authProvider.currentUser;
  //   final currentUserId = currentUser.uid;

  //   try {
  //     final senderQuery =
  //         await _fireStore
  //             .collection('chat_rooms')
  //             .where('senderId', isEqualTo: currentUserId)
  //             .get();

  //     final receiverQuery =
  //         await _fireStore
  //             .collection('chat_rooms')
  //             .where('receiverId', isEqualTo: currentUserId)
  //             .get();

  //     final allChatRooms = [...senderQuery.docs, ...receiverQuery.docs];
  //     final uniqueChatRooms =
  //         allChatRooms
  //             .fold<Map<String, QueryDocumentSnapshot>>({}, (map, doc) {
  //               final data = doc.data() as Map<String, dynamic>? ?? {};
  //               final chatRoomId = data['chatRoomId'] ?? doc.id;
  //               map.putIfAbsent(chatRoomId, () => doc);
  //               return map;
  //             })
  //             .values
  //             .toList();

  //     final userDataFutures =
  //         uniqueChatRooms.map((doc) async {
  //           final data = doc.data() as Map<String, dynamic>? ?? {};
  //           final isCurrentUserSender = data['senderId'] == currentUserId;
  //           final otherUserId =
  //               isCurrentUserSender
  //                   ? data['receiverId'] as String? ?? ''
  //                   : data['senderId'] as String? ?? '';

  //           if (otherUserId.isEmpty) {
  //             return {
  //               'docData': data,
  //               'otherUserName': 'Unknown User',
  //               'otherUserImage': AppAssets.appIcon,
  //             };
  //           }

  //           final userDoc =
  //               await _fireStore.collection('users').doc(otherUserId).get();
  //           final userData = userDoc.data() ?? {};
  //           Map<String, dynamic>? adData;
  //           if (data['adId'] != null) {
  //             try {
  //               final adDoc =
  //                   await _fireStore.collection('ads').doc(data['adId']).get();
  //               adData = adDoc.data();
  //             } catch (e) {
  //               debugPrint('Error fetching ad data: $e');
  //             }
  //           }
  //           return {
  //             'docData': data,
  //             'otherUserName': userData['name'] as String? ?? 'Unknown User',
  //             'otherUserImage':
  //                 userData['photoUrl'] as String? ?? AppAssets.appIcon,
  //             'adData': adData,
  //           };
  //         }).toList();

  //     final userDataResults = await Future.wait(userDataFutures);

  //     _chatRooms =
  //         uniqueChatRooms.asMap().entries.map((entry) {
  //           final index = entry.key;
  //           final doc = entry.value;
  //           final data =
  //               userDataResults[index]['docData'] as Map<String, dynamic>? ??
  //               {};
  //           final userData = userDataResults[index];
  //           final adData =
  //               userDataResults[index]['adData'] as Map<String, dynamic>?;
  //           final isCurrentUserSender = data['senderId'] == currentUserId;

  //           return ChatRoomModel(
  //             chatRoomId: doc.id,
  //             senderId: data['senderId'] as String? ?? '',
  //             senderName:
  //                 isCurrentUserSender
  //                     ? currentUser.name
  //                     : userData['otherUserName'] as String,
  //             senderImage: AppAssets.appIcon,
  //             receiverId: data['receiverId'] as String? ?? '',
  //             receiverName:
  //                 !isCurrentUserSender
  //                     ? currentUser.name
  //                     : userData['otherUserName'] as String,
  //             receiverImage: AppAssets.appIcon,
  //             lastMessage: data['lastMessage'] as String? ?? '',
  //             lastMessageTime:
  //                 (data['lastMessageTime'] as Timestamp?)?.toDate() ??
  //                 DateTime.now(),
  //             unreadCount: data['unreadCount'] as int? ?? 0,
  //             isPinned: data['isPinned'] as bool? ?? false,
  //             participants: List<String>.from(
  //               data['participants'] as List<dynamic>? ?? [],
  //             ),
  //             createdAt:
  //                 (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
  //             lastMessageSenderId: data['lastMessageSenderId'] as String?,
  //             lastMessageStatus:
  //                 data['lastMessageStatus'] != null
  //                     ? MessageStatus.values.firstWhere(
  //                       (e) =>
  //                           e.toString() ==
  //                           data['lastMessageStatus'] as String?,
  //                       orElse: () => MessageStatus.sent,
  //                     )
  //                     : null,
  //             lastMessageType: data['lastMessageType'] as String?,
  //             productId: data['productId'] as String?,
  //             adId: data['adId'] as String?, // Add adId to the ChatRoomModel
  //           );
  //         }).toList();

  //     _chatRooms.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
  //     notifyListeners();
  //   } catch (e) {
  //     debugPrint('Error fetching chat rooms: $e');
  //     rethrow;
  //   }
  // }
}
