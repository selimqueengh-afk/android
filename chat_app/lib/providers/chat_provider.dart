import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../models/chat_room_model.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';

class ChatProvider extends ChangeNotifier {
  List<ChatRoomModel> _chatRooms = [];
  List<MessageModel> _messages = [];
  List<UserModel> _users = [];
  bool _isLoading = false;
  String? _error;

  List<ChatRoomModel> get chatRooms => _chatRooms;
  List<MessageModel> get messages => _messages;
  List<UserModel> get users => _users;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadChatRooms(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _chatRooms = await FirebaseService.getUserChatRooms(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadUsers() async {
    try {
      _users = await FirebaseService.getAllUsers();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String content,
    MessageType type = MessageType.text,
    String? mediaUrl,
    String? fileName,
    int? fileSize,
  }) async {
    try {
      final message = MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: senderId,
        receiverId: receiverId,
        content: content,
        type: type,
        timestamp: DateTime.now(),
        isRead: false,
        mediaUrl: mediaUrl,
        fileName: fileName,
        fileSize: fileSize,
      );

      await FirebaseService.sendMessage(message);
      _messages.insert(0, message);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadMessages(String chatRoomId) async {
    try {
      // Bu kısım Firebase'den gerçek zamanlı mesajları dinleyecek
      // Şimdilik boş bırakıyoruz, daha sonra implement edeceğiz
      _messages = [];
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<String> createChatRoom(List<String> participants) async {
    try {
      final chatRoomId = await FirebaseService.createChatRoom(participants);
      await loadChatRooms(participants.first);
      return chatRoomId;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return '';
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }
}