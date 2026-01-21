import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class PinCodeScreen extends StatefulWidget {
  final Widget child;
  final String correctPin;

  const PinCodeScreen({
    super.key,
    required this.child,
    required this.correctPin,
  });

  @override
  State<PinCodeScreen> createState() => _PinCodeScreenState();
}

class _PinCodeScreenState extends State<PinCodeScreen> {
  String _inputPin = '';
  bool _isError = false;

  void _onKeyPress(String value) {
    if (_inputPin.length < 4) {
      setState(() {
        _inputPin += value;
        _isError = false;
      });

      if (_inputPin.length == 4) {
        if (_inputPin == widget.correctPin) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => widget.child),
          );
        } else {
          setState(() {
            _isError = true;
            _inputPin = '';
          });
          // Vibrate or show error
        }
      }
    }
  }

  void _onDelete() {
    if (_inputPin.isNotEmpty) {
      setState(() {
        _inputPin = _inputPin.substring(0, _inputPin.length - 1);
        _isError = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 1),
            _buildHeader(),
            const Spacer(flex: 1),
            _buildPinDisplay(),
            if (_isError)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  'رقم السر غير صحيح، حاول مرة أخرى',
                  style: TextStyle(color: AppColors.withdraw, fontSize: 14),
                ),
              ),
            const Spacer(flex: 1),
            _buildKeyboard(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.specialGold.withAlpha(100)),
          ),
          child: const Icon(
            Icons.lock_outline,
            color: AppColors.specialGold,
            size: 40,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'النسخة الخاصة',
          style: TextStyle(
            color: AppColors.specialGold,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'أدخل رقم السري للدخول',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPinDisplay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        bool isFilled = index < _inputPin.length;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 12),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isError
                ? AppColors.withdraw.withAlpha(100)
                : isFilled
                ? AppColors.specialGold
                : AppColors.secondary,
            border: Border.all(
              color: isFilled
                  ? AppColors.specialGold
                  : AppColors.textSecondary.withAlpha(50),
              width: 2,
            ),
            boxShadow: isFilled
                ? [
                    BoxShadow(
                      color: AppColors.specialGold.withAlpha(100),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
        );
      }),
    );
  }

  Widget _buildKeyboard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_buildKey('1'), _buildKey('2'), _buildKey('3')],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_buildKey('4'), _buildKey('5'), _buildKey('6')],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_buildKey('7'), _buildKey('8'), _buildKey('9')],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 70),
              _buildKey('0'),
              _buildDeleteKey(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKey(String value) {
    return InkWell(
      onTap: () => _onKeyPress(value),
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surface,
          border: Border.all(color: AppColors.secondary),
        ),
        child: Center(
          child: Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteKey() {
    return InkWell(
      onTap: _onDelete,
      borderRadius: BorderRadius.circular(40),
      child: SizedBox(
        width: 70,
        height: 70,
        child: const Center(
          child: Icon(
            Icons.backspace_outlined,
            color: AppColors.textSecondary,
            size: 28,
          ),
        ),
      ),
    );
  }
}
