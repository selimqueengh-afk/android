class UserModel {
  final String id;
  final String username;
  final String email;
  final String? profileImageUrl;
  final String status;
  final DateTime lastSeen;
  final bool isOnline;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.profileImageUrl,
    this.status = 'Hey there! I\'m using ChatApp',
    required this.lastSeen,
    this.isOnline = false,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      profileImageUrl: map['profileImageUrl'],
      status: map['status'] ?? 'Hey there! I\'m using ChatApp',
      lastSeen: map['lastSeen'] != null 
          ? DateTime.parse(map['lastSeen']) 
          : DateTime.now(),
      isOnline: map['isOnline'] ?? false,
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'status': status,
      'lastSeen': lastSeen.toIso8601String(),
      'isOnline': isOnline,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? profileImageUrl,
    String? status,
    DateTime? lastSeen,
    bool? isOnline,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      status: status ?? this.status,
      lastSeen: lastSeen ?? this.lastSeen,
      isOnline: isOnline ?? this.isOnline,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}