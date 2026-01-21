import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Dialog for adding or editing a barrel
class BarrelFormDialog extends StatefulWidget {
  final String? initialName;
  final String? initialUsage;
  final double? initialMaxLevel;
  final String? initialNotes;
  final bool isEditing;
  final void Function({
    required String name,
    required String usage,
    required double maxLevel,
    String? notes,
  })
  onConfirm;

  const BarrelFormDialog({
    super.key,
    this.initialName,
    this.initialUsage,
    this.initialMaxLevel,
    this.initialNotes,
    this.isEditing = false,
    required this.onConfirm,
  });

  /// Show the barrel form dialog
  static Future<void> show({
    required BuildContext context,
    String? initialName,
    String? initialUsage,
    double? initialMaxLevel,
    String? initialNotes,
    bool isEditing = false,
    required void Function({
      required String name,
      required String usage,
      required double maxLevel,
      String? notes,
    })
    onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (context) => BarrelFormDialog(
        initialName: initialName,
        initialUsage: initialUsage,
        initialMaxLevel: initialMaxLevel,
        initialNotes: initialNotes,
        isEditing: isEditing,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<BarrelFormDialog> createState() => _BarrelFormDialogState();
}

class _BarrelFormDialogState extends State<BarrelFormDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _usageController;
  late final TextEditingController _maxLevelController;
  late final TextEditingController _notesController;
  final _formKey = GlobalKey<FormState>();

  // قائمة استخدامات شائعة
  final List<String> _commonUsages = [
    'زيت هيدروليك',
    'زيت محرك',
    'زيت تبريد',
    'زيت تشحيم',
    'زيت قطع',
    'أخرى',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _usageController = TextEditingController(text: widget.initialUsage ?? '');
    _maxLevelController = TextEditingController(
      text: widget.initialMaxLevel?.toString() ?? '200',
    );
    _notesController = TextEditingController(text: widget.initialNotes ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usageController.dispose();
    _maxLevelController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _handleConfirm() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onConfirm(
        name: _nameController.text.trim(),
        usage: _usageController.text.trim(),
        maxLevel: double.tryParse(_maxLevelController.text) ?? 200.0,
        notes: _notesController.text.trim().isEmpty
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
        title: Text(
          widget.isEditing ? 'تعديل البرميل' : 'إضافة برميل جديد',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(
                  controller: _nameController,
                  label: 'اسم البرميل',
                  hint: 'مثال: برميل ماكينة 1',
                  icon: Icons.label_outline,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'يرجى إدخال اسم البرميل';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildUsageDropdown(),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _maxLevelController,
                  label: 'السعة القصوى (لتر)',
                  hint: '200',
                  icon: Icons.straighten,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'يرجى إدخال السعة';
                    }
                    final num = double.tryParse(value);
                    if (num == null || num <= 0) {
                      return 'يرجى إدخال رقم صحيح';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _notesController,
                  label: 'ملاحظات (اختياري)',
                  hint: 'أي ملاحظات إضافية...',
                  icon: Icons.note_outlined,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'إلغاء',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: _handleConfirm,
            child: Text(widget.isEditing ? 'حفظ التعديلات' : 'إضافة'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.withdraw, width: 1),
        ),
      ),
    );
  }

  Widget _buildUsageDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'نوع الاستخدام',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _commonUsages.map((usage) {
            final isSelected = _usageController.text == usage;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _usageController.text = usage;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withAlpha((0.2 * 255).round())
                      : AppColors.background,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.secondary,
                  ),
                ),
                child: Text(
                  usage,
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
