import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/message_model.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: isMe ? 60 : 0,
          right: isMe ? 0 : 60,
          bottom: 8,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isMe ? AppColors.messageSent : AppColors.messageReceived,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isMe ? 20 : 5),
            bottomRight: Radius.circular(isMe ? 5 : 20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMessageContent(),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat('HH:mm').format(message.timestamp),
                  style: AppTextStyles.caption.copyWith(
                    color: isMe 
                        ? AppColors.messageTextSent.withValues(alpha: 0.7)
                        : AppColors.textTertiary,
                    fontSize: 10,
                  ),
                ),
                if (isMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    message.isRead ? Icons.done_all : Icons.done,
                    size: 12,
                    color: message.isRead 
                        ? AppColors.success 
                        : AppColors.messageTextSent.withValues(alpha: 0.7),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageContent() {
    switch (message.type) {
      case MessageType.text:
        return Text(
          message.content,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isMe 
                ? AppColors.messageTextSent 
                : AppColors.messageTextReceived,
          ),
        );
      
      case MessageType.image:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.mediaUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  message.mediaUrl!,
                  width: 200,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 200,
                      height: 150,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.image_not_supported,
                        color: AppColors.textTertiary,
                      ),
                    );
                  },
                ),
              ),
            if (message.content.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                message.content,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isMe 
                      ? AppColors.messageTextSent 
                      : AppColors.messageTextReceived,
                ),
              ),
            ],
          ],
        );
      
      case MessageType.file:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isMe 
                ? AppColors.messageSent.withValues(alpha: 0.1)
                : AppColors.background,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.attach_file,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.fileName ?? 'Dosya',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isMe 
                            ? AppColors.messageTextSent 
                            : AppColors.messageTextReceived,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (message.fileSize != null)
                      Text(
                        '${(message.fileSize! / 1024).toStringAsFixed(1)} KB',
                        style: AppTextStyles.caption.copyWith(
                          color: isMe 
                              ? AppColors.messageTextSent.withOpacity(0.7)
                              : AppColors.textTertiary,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      
      default:
        return Text(
          message.content,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isMe 
                ? AppColors.messageTextSent 
                : AppColors.messageTextReceived,
          ),
        );
    }
  }
}