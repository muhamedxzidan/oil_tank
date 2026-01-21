import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/barrel.dart';

/// A card widget displaying barrel summary
class BarrelCard extends StatelessWidget {
  final Barrel barrel;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const BarrelCard({
    super.key,
    required this.barrel,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: barrel.isLowLevel
                ? AppColors.withdraw.withAlpha((0.3 * 255).round())
                : AppColors.specialGold.withAlpha((0.15 * 255).round()),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.2 * 255).round()),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildProgressBar(),
            const SizedBox(height: 16),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.specialGold.withAlpha((0.2 * 255).round()),
                AppColors.specialGold.withAlpha((0.05 * 255).round()),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.specialGold.withAlpha((0.3 * 255).round()),
            ),
          ),
          child: const Icon(
            Icons.oil_barrel,
            color: AppColors.specialGold,
            size: 28,
          ),
        ),
        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                barrel.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                barrel.usage,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        _buildStatusBadge(),
      ],
    );
  }

  Widget _buildStatusBadge() {
    final Color statusColor = barrel.isLowLevel
        ? AppColors.withdraw
        : AppColors.deposit;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withAlpha((0.15 * 255).round()),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        barrel.isLowLevel ? 'منخفض' : 'جيد',
        style: TextStyle(
          color: statusColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${barrel.currentLevel.toStringAsFixed(1)} لتر',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'من ${barrel.maxLevel.toStringAsFixed(0)} لتر',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: barrel.percentage,
            backgroundColor: AppColors.secondary,
            valueColor: AlwaysStoppedAnimation<Color>(
              barrel.isLowLevel ? AppColors.withdraw : AppColors.specialGold,
            ),
            minHeight: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${(barrel.percentage * 100).toStringAsFixed(0)}% ممتلئ',
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.textSecondary,
        ),
      ],
    );
  }
}

/// Empty state for no barrels
class EmptyBarrelsList extends StatelessWidget {
  final VoidCallback onAddBarrel;

  const EmptyBarrelsList({super.key, required this.onAddBarrel});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.oil_barrel_outlined,
            size: 80,
            color: AppColors.textSecondary.withAlpha((0.5 * 255).round()),
          ),
          const SizedBox(height: 24),
          const Text(
            'لا توجد براميل حتى الآن',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'اضغط على الزر أدناه لإضافة برميل جديد',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: onAddBarrel,
            icon: const Icon(Icons.add),
            label: const Text('إضافة برميل'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
