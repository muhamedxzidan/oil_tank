import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'glowing_developer_button.dart';

/// Main header for the barrels list screen, including greeting, title, count, and developer button.
class BarrelsHeader extends StatelessWidget {
  final int barrelCount;

  const BarrelsHeader({super.key, required this.barrelCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_buildTitleSection(), _buildActionSection()],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildGreetingRow(),
        const SizedBox(height: 4),
        _buildTitleRow(),
      ],
    );
  }

  Widget _buildGreetingRow() {
    return Row(
      children: [
        const Text(
          'مرحباً بك في الورشة',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        const SizedBox(width: 8),
        _buildSpecialBadge(),
      ],
    );
  }

  Widget _buildSpecialBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.specialGold.withAlpha((0.15 * 255).round()),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: AppColors.specialGold.withAlpha((0.5 * 255).round()),
          width: 0.5,
        ),
      ),
      child: const Text(
        'SPECIAL',
        style: TextStyle(
          color: AppColors.specialGold,
          fontSize: 8,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildTitleRow() {
    return Row(
      children: [
        const Text(
          'إدارة البراميل',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        if (barrelCount > 0) ...[const SizedBox(width: 12), _buildCountBadge()],
      ],
    );
  }

  Widget _buildCountBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha((0.2 * 255).round()),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$barrelCount',
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildActionSection() {
    return Row(
      children: [
        const GlowingDeveloperButton(),
        const SizedBox(width: 8),
        _buildBarrelIcon(),
      ],
    );
  }

  Widget _buildBarrelIcon() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.specialGold.withAlpha((0.3 * 255).round()),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.specialGold.withAlpha((0.1 * 255).round()),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: const Icon(
        Icons.oil_barrel,
        color: AppColors.specialGold,
        size: 28,
      ),
    );
  }
}
