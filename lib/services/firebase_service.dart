import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../models/message_model.dart';
import '../models/chat_room_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // User Operations
  Future<void> createUser(UserModel user) async {
    await _firestore.collection('users').doc(user.id).set(user.toMap());
  }

  Future<UserModel?> getUser(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!);
    }
    return null;
  }

  Future<List<UserModel>> getUsers() async {
    final querySnapshot = await _firestore.collection('users').get();
    return querySnapshot.docs
        .map((doc) => UserModel.fromMap(doc.data()))
        .toList();
  }

  // Chat Room Operations
  Future<List<ChatRoomModel>> getChatRooms(String userId) async {
    final querySnapshot = await _firestore
        .collection('chatRooms')
        .where('participants', arrayContains: userId)
        .orderBy('updatedAt', descending: true)
        .get();
    
    return querySnapshot.docs
        .map((doc) => ChatRoomModel.fromMap({...doc.data(), 'id': doc.id}))
        .toList();
  }

  Future<ChatRoomModel> createChatRoom(String userId1, String userId2) async {
    final participants = [userId1, userId2];
    final chatRoom = ChatRoomModel(
      id: '',
      participants: participants,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final docRef = await _firestore.collection('chatRooms').add(chatRoom.toMap());
    return chatRoom.copyWith(id: docRef.id);
  }

  // Message Operations
  Future<List<MessageModel>> getMessages(String chatRoomId) async {
    final querySnapshot = await _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .get();
    
    return querySnapshot.docs
        .map((doc) => MessageModel.fromMap({...doc.data(), 'id': doc.id}))
        .toList();
  }

  Future<MessageModel> sendMessage({
    required String senderId,
    required String receiverId,
    required String content,
    String? mediaUrl,
    String? fileName,
    int? fileSize,
  }) async {
    // Find or create chat room
    final chatRoomQuery = await _firestore
        .collection('chatRooms')
        .where('participants', arrayContains: senderId)
        .get();

    ChatRoomModel chatRoom;
    String chatRoomId;

    // Check if chat room exists
    final existingRoom = chatRoomQuery.docs.firstWhere(
      (doc) => doc.data()['participants'].contains(receiverId),
      orElse: () => null,
    );

    if (existingRoom != null) {
      chatRoomId = existingRoom.id;
      chatRoom = ChatRoomModel.fromMap({...existingRoom.data(), 'id': existingRoom.id});
    } else {
      // Create new chat room
      final newChatRoom = ChatRoomModel(
        id: '',
        participants: [senderId, receiverId],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final docRef = await _firestore.collection('chatRooms').add(newChatRoom.toMap());
      chatRoomId = docRef.id;
      chatRoom = newChatRoom.copyWith(id: chatRoomId);
    }

    // Create message
    final message = MessageModel(
      id: '',
      senderId: senderId,
      receiverId: receiverId,
      content: content,
      timestamp: DateTime.now(),
      mediaUrl: mediaUrl,
      fileName: fileName,
      fileSize: fileSize,
    );

    final messageRef = await _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(message.toMap());

    // Update chat room
    await _firestore.collection('chatRooms').doc(chatRoomId).update({
      'lastMessage': content,
      'lastMessageTime': message.timestamp.toIso8601String(),
      'lastMessageSenderId': senderId,
      'updatedAt': DateTime.now().toIso8601String(),
    });

    return message.copyWith(id: messageRef.id);
  }

  // File Operations (using Firestore instead of Storage)
  Future<String> uploadFile(List<int> fileBytes, String fileName) async {
    final base64String = base64Encode(fileBytes);
    final fileDoc = {
      'fileName': fileName,
      'fileSize': fileBytes.length,
      'data': base64String,
      'uploadedAt': DateTime.now().toIso8601String(),
    };

    final docRef = await _firestore.collection('files').add(fileDoc);
    return docRef.id; // Return document ID as file URL
  }

  Future<List<int>> getFile(String fileId) async {
    final doc = await _firestore.collection('files').doc(fileId).get();
    if (doc.exists) {
      final data = doc.data()!;
      final base64String = data['data'] as String;
      return base64Decode(base64String);
    }
    throw Exception('File not found');
  }
}