import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/chat_room_model.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import 'user_avatar.dart';

class ChatListItem extends StatelessWidget {
  final ChatRoomModel chatRoom;

  const ChatListItem({
    super.key,
    required this.chatRoom,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: const UserAvatar(
          size: 50,
          imageUrl: null,
          isOnline: true,
        ),
        title: Text(
          'Sohbet ${chatRoom.id.substring(0, 8)}',
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          chatRoom.lastMessage ?? 'Henüz mesaj yok',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              chatRoom.lastMessageTime != null
                  ? DateFormat('HH:mm').format(chatRoom.lastMessageTime!)
                  : '',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 4),
            if (chatRoom.unreadCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  chatRoom.unreadCount.toString(),
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/chat',
            arguments: chatRoom,
          );
        },
      ),
    );
  }
}