import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageStatus { sending, sent, delivered, failed }

class MessageModel {
  final String uid;
  final String name;
  final String message;
  final String dpImage;
  final DateTime sendAt;
  final int messageCount;
  final String? file;
  final MessageStatus? status;
  final bool isPinned;
  final String messageId;
  final String receiverId;
  final bool isRead;
  final String senderId;
  final String? adId; // New field for ad reference

  MessageModel({
    required this.uid,
    required this.name,
    required this.message,
    required this.dpImage,
    required this.sendAt,
    required this.messageCount,
    this.file,
    this.status,
    required this.isPinned,
    required this.messageId,
    required this.receiverId,
    required this.isRead,
    required this.senderId,
    this.adId, // Added as optional parameter
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'message': message,
      'dpImage': dpImage,
      'sendAt': sendAt,
      'messageCount': messageCount,
      'file': file,
      'status': status?.name,
      'isPinned': isPinned,
      'messageId': messageId,
      'receiverId': receiverId,
      'isRead': isRead,
      'senderId': senderId,
      'adId': adId, // Added to map
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      message: map['message'] ?? '',
      dpImage: map['dpImage'] ?? '',
      sendAt: (map['sendAt'] as Timestamp).toDate(),
      messageCount: map['messageCount'] ?? 0,
      file: map['file'],
      status:
          map['status'] != null
              ? MessageStatus.values.byName(map['status'])
              : MessageStatus.sending,
      isPinned: map['isPinned'] ?? false,
      messageId: map['messageId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      isRead: map['isRead'] ?? false,
      senderId: map['senderId'] ?? '',
      adId: map['adId'], // Added to fromMap
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source));

  MessageModel copyWith({
    String? uid,
    String? name,
    String? message,
    String? dpImage,
    DateTime? sendAt,
    int? messageCount,
    String? file,
    MessageStatus? status,
    bool? isPinned,
    String? messageId,
    String? receiverId,
    bool? isRead,
    String? senderId,
    String? adId, // Added to copyWith
  }) {
    return MessageModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      message: message ?? this.message,
      dpImage: dpImage ?? this.dpImage,
      sendAt: sendAt ?? this.sendAt,
      messageCount: messageCount ?? this.messageCount,
      file: file ?? this.file,
      status: status ?? this.status,
      isPinned: isPinned ?? this.isPinned,
      messageId: messageId ?? this.messageId,
      receiverId: receiverId ?? this.receiverId,
      isRead: isRead ?? this.isRead,
      senderId: senderId ?? this.senderId,
      adId: adId ?? this.adId, // Added to copy
    );
  }
}
