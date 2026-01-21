import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Dialog type enum
enum OilDialogType { add, withdraw }

/// A dialog for inputting oil amount (add or withdraw)
class OilInputDialog extends StatefulWidget {
  final OilDialogType type;
  final void Function(double amount, String? personName, String? notes)
  onConfirm;

  const OilInputDialog({
    super.key,
    required this.type,
    required this.onConfirm,
  });

  /// Show the oil input dialog
  static Future<void> show({
    required BuildContext context,
    required OilDialogType type,
    required void Function(double amount, String? personName, String? notes)
    onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (context) => OilInputDialog(type: type, onConfirm: onConfirm),
    );
  }

  @override
  State<OilInputDialog> createState() => _OilInputDialogState();
}

class _OilInputDialogState extends State<OilInputDialog> {
  late final TextEditingController _amountController;
  late final TextEditingController _personController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _personController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _personController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  bool get _isAdding => widget.type == OilDialogType.add;
  Color get _accentColor => _isAdding ? AppColors.deposit : AppColors.withdraw;

  void _handleConfirm() {
    final double? amount = double.tryParse(_amountController.text);
    if (amount != null && amount > 0) {
      widget.onConfirm(
        amount,
        _personController.text.trim().isEmpty
            ? null
            : _personController.text.trim(),
        _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: _buildTitle(),
        content: SingleChildScrollView(child: _buildContent()),
        actions: _buildActions(),
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      children: [
        Icon(
          _isAdding ? Icons.add_circle : Icons.remove_circle,
          color: _accentColor,
        ),
        const SizedBox(width: 12),
        Text(
          _isAdding ? 'إضافة زيت' : 'سحب زيت',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _isAdding
              ? 'كم لتر تريد إضافته للبرميل؟'
              : 'كم لتر تريد سحبه من البرميل؟',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        const SizedBox(height: 20),
        _buildAmountField(),
        const SizedBox(height: 16),
        _buildPersonField(),
        const SizedBox(height: 16),
        _buildNotesField(),
      ],
    );
  }

  Widget _buildAmountField() {
    return TextField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      autofocus: true,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.background,
        hintText: '0.0',
        hintStyle: TextStyle(
          color: AppColors.textSecondary.withAlpha((0.5 * 255).round()),
        ),
        suffixText: 'لتر',
        suffixStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _accentColor, width: 2),
        ),
      ),
    );
  }

  Widget _buildPersonField() {
    return TextField(
      controller: _personController,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.background,
        labelText: _isAdding ? 'من أضاف؟ (اختياري)' : 'من سحب؟ (اختياري)',
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIcon: const Icon(
          Icons.person_outline,
          color: AppColors.textSecondary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _accentColor, width: 2),
        ),
      ),
    );
  }

  Widget _buildNotesField() {
    return TextField(
      controller: _notesController,
      style: const TextStyle(color: AppColors.textPrimary),
      maxLines: 2,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.background,
        labelText: 'ملاحظات (اختياري)',
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIcon: const Icon(
          Icons.note_outlined,
          color: AppColors.textSecondary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _accentColor, width: 2),
        ),
      ),
    );
  }

  List<Widget> _buildActions() {
    return [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text(
          'إلغاء',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _accentColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: _handleConfirm,
          child: Text(_isAdding ? 'تأكيد الإضافة' : 'تأكيد السحب'),
        ),
      ),
    ];
  }
}
