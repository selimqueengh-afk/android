import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/user_model.dart';
import '../models/message_model.dart';
import '../models/chat_room_model.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // Initialize Firebase
  static Future<void> initialize() async {
    await Firebase.initializeApp();
  }

  // Auth Methods
  static Future<UserCredential?> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user != null) {
        await _createUserProfile(credential.user!.uid, email, username);
      }
      
      return credential;
    } catch (e) {
      // Sign up error: $e
      return null;
    }
  }

  static Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      // Sign in error: $e
      return null;
    }
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  static User? getCurrentUser() {
    return _auth.currentUser;
  }

  // User Profile Methods
  static Future<void> _createUserProfile(
    String uid,
    String email,
    String username,
  ) async {
    final user = UserModel(
      id: uid,
      username: username,
      email: email,
      lastSeen: DateTime.now(),
      isOnline: true,
      createdAt: DateTime.now(),
    );

    await _firestore
        .collection('users')
        .doc(uid)
        .set(user.toMap());
  }

  static Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .get();
      
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      // Get user error: $e
      return null;
    }
  }

  static Future<List<UserModel>> getAllUsers() async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .get();
      
      return querySnapshot.docs
          .map((doc) => UserModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      // Get all users error: $e
      return [];
    }
  }

  static Future<void> updateUserStatus(String userId, bool isOnline) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .update({
        'isOnline': isOnline,
        'lastSeen': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Update user status error: $e
    }
  }

  // Chat Room Methods
  static Future<String> createChatRoom(List<String> participants) async {
    try {
      final chatRoom = ChatRoomModel(
        id: '',
        participants: participants,
        unreadCount: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final docRef = await _firestore
          .collection('chatRooms')
          .add(chatRoom.toMap());
      
      return docRef.id;
    } catch (e) {
      // Create chat room error: $e
      return '';
    }
  }

  static Future<List<ChatRoomModel>> getUserChatRooms(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('chatRooms')
          .where('participants', arrayContains: userId)
          .orderBy('updatedAt', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => ChatRoomModel.fromMap({
            'id': doc.id,
            ...doc.data(),
          }))
          .toList();
    } catch (e) {
      // Get user chat rooms error: $e
      return [];
    }
  }

  // Message Methods
  static Future<void> sendMessage(MessageModel message) async {
    try {
      await _firestore
          .collection('messages')
          .add(message.toMap());
      
      // Update chat room
      await _firestore
          .collection('chatRooms')
          .doc(message.id)
          .update({
        'lastMessage': message.content,
        'lastMessageTime': message.timestamp.toIso8601String(),
        'lastMessageSenderId': message.senderId,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Send message error: $e
    }
  }

  static Stream<List<MessageModel>> getMessages(String chatRoomId) {
    return _firestore
        .collection('messages')
        .where('chatRoomId', isEqualTo: chatRoomId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromMap(doc.data()))
            .toList());
  }

  // File Upload Methods
  static Future<String?> uploadFile(List<int> fileBytes, String fileName) async {
    try {
      final ref = _storage.ref().child('uploads/$fileName');
      final uploadTask = ref.putData(Uint8List.fromList(fileBytes));
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      // Upload file error: $e
      return null;
    }
  }
}