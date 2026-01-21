import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Header widget displaying the app title and settings button
class HeaderWidget extends StatelessWidget {
  final String greeting;
  final String title;
  final VoidCallback? onSettingsTap;

  const HeaderWidget({
    super.key,
    this.greeting = 'مرحباً بك في الورشة',
    this.title = 'مراقب برميل الزيت',
    this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [_buildTitleSection(), _buildSettingsButton()],
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsButton() {
    return GestureDetector(
      onTap: onSettingsTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.settings_outlined,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
