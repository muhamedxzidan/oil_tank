import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// A circular gauge widget that displays the oil level
class OilGauge extends StatelessWidget {
  final double level;
  final double maxLevel;

  const OilGauge({super.key, required this.level, required this.maxLevel});

  double get _percentage => (level / maxLevel).clamp(0.0, 1.0);
  bool get _isLowLevel => _percentage < 0.2;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _buildProgressIndicator(),
        _buildOuterRing(),
        _buildCenterContent(),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      width: 240,
      height: 240,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          if (!_isLowLevel)
            BoxShadow(
              color: AppColors.specialGold.withAlpha((0.15 * 255).round()),
              blurRadius: 20,
              spreadRadius: 2,
            ),
        ],
      ),
      child: CircularProgressIndicator(
        value: _percentage,
        strokeWidth: 14,
        backgroundColor: AppColors.secondary,
        valueColor: AlwaysStoppedAnimation<Color>(
          _isLowLevel ? AppColors.withdraw : AppColors.specialGold,
        ),
        strokeCap: StrokeCap.round,
      ),
    );
  }

  Widget _buildOuterRing() {
    return Container(
      width: 260,
      height: 260,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.secondary.withAlpha((0.3 * 255).round()),
          width: 1,
        ),
      ),
    );
  }

  Widget _buildCenterContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildLevelText(),
        _buildMaxLevelText(),
        const SizedBox(height: 10),
        _buildStatusBadge(),
      ],
    );
  }

  Widget _buildLevelText() {
    return Text(
      level.toStringAsFixed(0),
      style: const TextStyle(
        fontSize: 60,
        fontWeight: FontWeight.bold,
        color: AppColors.specialGold,
        letterSpacing: -2,
      ),
    );
  }

  Widget _buildMaxLevelText() {
    return Text(
      'من $maxLevel لتر',
      style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
    );
  }

  Widget _buildStatusBadge() {
    final Color statusColor = _isLowLevel
        ? AppColors.withdraw
        : AppColors.deposit;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withAlpha((0.2 * 255).round()),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _isLowLevel ? 'منخفض' : 'جيد',
        style: TextStyle(
          color: statusColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
