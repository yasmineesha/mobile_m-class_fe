import 'package:flutter/material.dart';

import '../models/student_profile.dart';
import '../utils/colors.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.size,
    this.borderColor = Colors.white,
    this.borderWidth = 2,
  });

  final double size;
  final Color borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: StudentProfile.instance,
      builder: (context, _) {
        final photoBytes = StudentProfile.instance.photoBytes;
        return Container(
          width: size,
          height: size,
          padding: EdgeInsets.all(borderWidth),
          decoration: BoxDecoration(
            color: borderColor,
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: borderWidth),
          ),
          child: ClipOval(
            child: photoBytes == null
                ? ColoredBox(
                    color: AppColors.primarySoft,
                    child: Icon(
                      Icons.person_rounded,
                      size: size * 0.62,
                      color: AppColors.primary,
                    ),
                  )
                : Image.memory(
                    photoBytes,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => ColoredBox(
                      color: AppColors.primarySoft,
                      child: Icon(
                        Icons.person_rounded,
                        size: size * 0.62,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
