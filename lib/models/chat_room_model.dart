import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:humsaya_app/models/message_model.dart';

class ChatRoomModel {
  final String chatRoomId; // Unique ID for the chat room
  final String senderId;
  final String senderName;
  final String? senderImage; // Profile image of sender
  final String receiverId;
  final String receiverName;
  final String? receiverImage; // Profile image of receiver
  final String lastMessage; // Last message in the chat
  final DateTime lastMessageTime; // When the last message was sent
  final int unreadCount; // Number of unread messages
  final bool isPinned; // Whether the chat is pinned
  final bool isGroupChat; // Flag for group chats
  final List<String> participants; // List of all participant IDs
  final DateTime createdAt; // When the chat room was created
  final String? lastMessageSenderId; // Who sent the last message
  final MessageStatus? lastMessageStatus; // Status of last message
  final String? lastMessageType; // text, image, video, etc.
  final String? productId; // If it's related to a product
  final String? adId; // Added field for ad reference

  ChatRoomModel({
    required this.chatRoomId,
    required this.senderId,
    required this.senderName,
    this.senderImage,
    required this.receiverId,
    required this.receiverName,
    this.receiverImage,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    this.isPinned = false,
    this.isGroupChat = false,
    required this.participants,
    required this.createdAt,
    this.lastMessageSenderId,
    this.lastMessageStatus,
    this.lastMessageType,
    this.productId,
    this.adId,
  });

  // Factory method to create a ChatRoom from Firestore document
  factory ChatRoomModel.fromMap(Map<String, dynamic> map) {
    return ChatRoomModel(
      chatRoomId: map['chatRoomId'] ?? '',
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? '',
      senderImage: map['senderImage'],
      receiverId: map['receiverId'] ?? '',
      receiverName: map['receiverName'] ?? '',
      receiverImage: map['receiverImage'],
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTime:
          (map['lastMessageTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      unreadCount: map['unreadCount'] ?? 0,
      isPinned: map['isPinned'] ?? false,
      isGroupChat: map['isGroupChat'] ?? false,
      participants: List<String>.from(map['participants'] ?? []),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastMessageSenderId: map['lastMessageSenderId'],
      lastMessageStatus:
          map['lastMessageStatus'] != null
              ? MessageStatus.values.firstWhere(
                (e) => e.toString() == map['lastMessageStatus'],
                orElse: () => MessageStatus.sent,
              )
              : null,
      lastMessageType: map['lastMessageType'],
      productId: map['productId'],
      adId: map['adId'],
    );
  }

  // Convert ChatRoom to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'chatRoomId': chatRoomId,
      'senderId': senderId,
      'senderName': senderName,
      'senderImage': senderImage,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'receiverImage': receiverImage,
      'lastMessage': lastMessage,
      'lastMessageTime': Timestamp.fromDate(lastMessageTime),
      'unreadCount': unreadCount,
      'isPinned': isPinned,
      'isGroupChat': isGroupChat,
      'participants': participants,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastMessageSenderId': lastMessageSenderId,
      'lastMessageStatus': lastMessageStatus?.toString(),
      'lastMessageType': lastMessageType,
      'productId': productId,
      'adId': adId,
    };
  }

  // Creates a copy of the ChatRoomModel with updated fields
  ChatRoomModel copyWith({
    String? chatRoomId,
    String? senderId,
    String? senderName,
    String? senderImage,
    String? receiverId,
    String? receiverName,
    String? receiverImage,
    String? lastMessage,
    DateTime? lastMessageTime,
    int? unreadCount,
    bool? isPinned,
    bool? isGroupChat,
    List<String>? participants,
    DateTime? createdAt,
    String? lastMessageSenderId,
    MessageStatus? lastMessageStatus,
    String? lastMessageType,
    String? productId,
    String? adId,
  }) {
    return ChatRoomModel(
      chatRoomId: chatRoomId ?? this.chatRoomId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderImage: senderImage ?? this.senderImage,
      receiverId: receiverId ?? this.receiverId,
      receiverName: receiverName ?? this.receiverName,
      receiverImage: receiverImage ?? this.receiverImage,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      isPinned: isPinned ?? this.isPinned,
      isGroupChat: isGroupChat ?? this.isGroupChat,
      participants: participants ?? List.from(this.participants),
      createdAt: createdAt ?? this.createdAt,
      lastMessageSenderId: lastMessageSenderId ?? this.lastMessageSenderId,
      lastMessageStatus: lastMessageStatus ?? this.lastMessageStatus,
      lastMessageType: lastMessageType ?? this.lastMessageType,
      productId: productId ?? this.productId,
      adId: adId ?? this.adId,
    );
  }

  // Helper method to get the other user's ID
  String getOtherUserId(String currentUserId) {
    return senderId == currentUserId ? receiverId : senderId;
  }

  // Helper method to get the other user's name
  String getOtherUserName(String currentUserId) {
    return senderId == currentUserId ? receiverName : senderName;
  }

  // Helper method to get the other user's image
  String? getOtherUserImage(String currentUserId) {
    return senderId == currentUserId ? receiverImage : senderImage;
  }

  // Override toString for better debugging
  @override
  String toString() {
    return 'ChatRoomModel('
        'chatRoomId: $chatRoomId, '
        'senderId: $senderId, '
        'senderName: $senderName, '
        'receiverId: $receiverId, '
        'receiverName: $receiverName, '
        'lastMessage: $lastMessage, '
        'unreadCount: $unreadCount, '
        'adId: $adId)';
  }

  // Override equality comparison
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatRoomModel &&
          runtimeType == other.runtimeType &&
          chatRoomId == other.chatRoomId;

  // Override hashCode
  @override
  int get hashCode => chatRoomId.hashCode;
}
