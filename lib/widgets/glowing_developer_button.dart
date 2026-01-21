import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'developer_dialog.dart';

/// A glowing, pulsing developer button representing the creator or special edition features.
class GlowingDeveloperButton extends StatefulWidget {
  const GlowingDeveloperButton({super.key});

  @override
  State<GlowingDeveloperButton> createState() => _GlowingDeveloperButtonState();
}

class _GlowingDeveloperButtonState extends State<GlowingDeveloperButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(
      begin: 2.0,
      end: 12.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.specialGold.withAlpha((0.6 * 255).round()),
                blurRadius: _glowAnimation.value * 1.5,
                spreadRadius: _glowAnimation.value / 2,
              ),
            ],
          ),
          child: IconButton(
            onPressed: () => DeveloperDialog.show(context),
            icon: const Icon(
              Icons.person_pin,
              color: AppColors.specialGold,
              size: 30,
            ),
            tooltip: 'عن المطور',
          ),
        );
      },
    );
  }
}
