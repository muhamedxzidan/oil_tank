import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// A styled action button for oil operations (add/withdraw)
class ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const ActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withAlpha((0.3 * 255).round())),
          boxShadow: [
            BoxShadow(
              color: color.withAlpha((0.05 * 255).round()),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Pre-configured withdraw button
class WithdrawButton extends StatelessWidget {
  final VoidCallback onTap;

  const WithdrawButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionButton(
      label: 'سحب زيت',
      icon: Icons.remove_circle_outline,
      color: AppColors.withdraw,
      onTap: onTap,
    );
  }
}

/// Pre-configured deposit button
class DepositButton extends StatelessWidget {
  final VoidCallback onTap;

  const DepositButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionButton(
      label: 'إضافة زيت',
      icon: Icons.add_circle_outline,
      color: AppColors.deposit,
      onTap: onTap,
    );
  }
}
