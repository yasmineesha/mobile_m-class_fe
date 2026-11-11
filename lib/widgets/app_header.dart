import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../screens/app/notifikasi_screen.dart';
import 'profile_avatar.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showBackButton;
  final VoidCallback? onBack; // Tambahan parameter untuk aksi tombol back
  final int notificationFromTabIndex;

  const AppHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.showBackButton = true,
    this.onBack,
    this.notificationFromTabIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showBackButton) ...[
          GestureDetector(
            onTap: onBack ?? () => Navigator.maybePop(context),
            child: const Icon(
              Icons.arrow_back,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
        ],
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const Spacer(),
        AppNotificationButton(fromTabIndex: notificationFromTabIndex),
        const ProfileAvatar(
          size: 44,
          borderColor: AppColors.primary,
          borderWidth: 1.5,
        ),
      ],
    );
  }
}

class AppNotificationButton extends StatelessWidget {
  const AppNotificationButton({super.key, this.fromTabIndex = 0});

  final int fromTabIndex;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NotifikasiScreen(fromTabIndex: fromTabIndex),
          ),
        );
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(
              Icons.notifications_none_rounded,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
