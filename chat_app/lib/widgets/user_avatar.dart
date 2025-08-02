import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_colors.dart';

class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final bool isOnline;

  const UserAvatar({
    super.key,
    this.imageUrl,
    this.size = 40,
    this.isOnline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withOpacity(0.1),
          ),
          child: imageUrl != null
              ? ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.background,
                      child: const Icon(
                        Icons.person,
                        color: AppColors.primary,
                      ),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.person,
                      color: AppColors.primary,
                    ),
                  ),
                )
              : Icon(
                  Icons.person,
                  size: size * 0.5,
                  color: AppColors.primary,
                ),
        ),
        if (isOnline)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: size * 0.3,
              height: size * 0.3,
              decoration: BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }
}