import 'package:flutter/material.dart';
import '../models/chat_room_model.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';

class ChatProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  
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
    _setLoading(true);
    _clearError();
    
    try {
      final chatRooms = await _firebaseService.getChatRooms(userId);
      _chatRooms = chatRooms;
      notifyListeners();
    } catch (e) {
      _setError('Sohbet odaları yüklenemedi: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadMessages(String chatRoomId) async {
    _setLoading(true);
    _clearError();
    
    try {
      final messages = await _firebaseService.getMessages(chatRoomId);
      _messages = messages;
      notifyListeners();
    } catch (e) {
      _setError('Mesajlar yüklenemedi: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadUsers() async {
    _setLoading(true);
    _clearError();
    
    try {
      final users = await _firebaseService.getUsers();
      _users = users;
      notifyListeners();
    } catch (e) {
      _setError('Kullanıcılar yüklenemedi: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String content,
    String? mediaUrl,
    String? fileName,
    int? fileSize,
  }) async {
    try {
      final message = await _firebaseService.sendMessage(
        senderId: senderId,
        receiverId: receiverId,
        content: content,
        mediaUrl: mediaUrl,
        fileName: fileName,
        fileSize: fileSize,
      );
      
      _messages.add(message);
      notifyListeners();
    } catch (e) {
      _setError('Mesaj gönderilemedi: ${e.toString()}');
    }
  }

  Future<void> createChatRoom(String userId1, String userId2) async {
    try {
      final chatRoom = await _firebaseService.createChatRoom(userId1, userId2);
      _chatRooms.add(chatRoom);
      notifyListeners();
    } catch (e) {
      _setError('Sohbet odası oluşturulamadı: ${e.toString()}');
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}