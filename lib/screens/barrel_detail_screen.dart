import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../controllers/oil_tank_controller.dart';
import '../services/storage_service.dart';
import '../widgets/widgets.dart';

/// Detail screen for a single barrel
class BarrelDetailScreen extends StatefulWidget {
  final String barrelId;
  final StorageService storageService;

  const BarrelDetailScreen({
    super.key,
    required this.barrelId,
    required this.storageService,
  });

  @override
  State<BarrelDetailScreen> createState() => _BarrelDetailScreenState();
}

class _BarrelDetailScreenState extends State<BarrelDetailScreen> {
  late final OilTankController _controller;

  @override
  void initState() {
    super.initState();
    _controller = OilTankController(widget.storageService, widget.barrelId);
    _controller.addListener(_onControllerUpdate);
    _initializeController();
  }

  Future<void> _initializeController() async {
    await _controller.init();
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    super.dispose();
  }

  void _onControllerUpdate() {
    setState(() {});
  }

  void _showAddDialog() {
    OilInputDialog.show(
      context: context,
      type: OilDialogType.add,
      onConfirm: (amount, personName, notes) {
        _controller.addOil(amount, personName: personName, notes: notes);
      },
    );
  }

  void _showWithdrawDialog() {
    OilInputDialog.show(
      context: context,
      type: OilDialogType.withdraw,
      onConfirm: (amount, personName, notes) async {
        final success = await _controller.withdrawOil(
          amount,
          personName: personName,
          notes: notes,
        );
        if (!success && mounted) {
          // Show error if withdrawal failed due to insufficient amount
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'لا يمكن سحب كمية أكبر من المتوفرة في البرميل!',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              backgroundColor: AppColors.withdraw,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      },
    );
  }

  void _showHistoryBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildHistorySheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.isLoading) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.specialGold),
        ),
      );
    }

    if (_controller.barrel == null) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: const Center(
          child: Text(
            'البرميل غير موجود',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAppBar(),
                  const SizedBox(height: 20),
                  _buildBarrelInfo(),
                  const SizedBox(height: 30),
                  Center(
                    child: OilGauge(
                      level: _controller.currentLevel,
                      maxLevel: _controller.maxLevel,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildActionButtons(),
                  const SizedBox(height: 24),
                  _buildViewHistoryButton(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios),
            color: AppColors.textPrimary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _controller.barrelName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'نسخة خاصة • SPECIAL EDITION',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.specialGold.withAlpha((0.8 * 255).round()),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
            color: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (value) {
              if (value == 'reset') {
                _showResetConfirmation();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'reset',
                child: Row(
                  children: [
                    Icon(Icons.refresh, color: AppColors.withdraw),
                    SizedBox(width: 12),
                    Text('إعادة تعيين'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBarrelInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.specialGold.withAlpha((0.15 * 255).round()),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.specialGold.withAlpha((0.3 * 255).round()),
              ),
            ),
            child: const Icon(
              Icons.oil_barrel,
              color: AppColors.specialGold,
              size: 24,
            ),
          ),

          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _controller.barrelUsage,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'السعة: ${_controller.maxLevel.toStringAsFixed(0)} لتر',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(child: WithdrawButton(onTap: _showWithdrawDialog)),
        const SizedBox(width: 15),
        Expanded(child: DepositButton(onTap: _showAddDialog)),
      ],
    );
  }

  Widget _buildViewHistoryButton() {
    return InkWell(
      onTap: _showHistoryBottomSheet,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.secondary),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.history, color: AppColors.textSecondary, size: 24),
            const SizedBox(width: 12),
            const Text(
              'عرض سجل العمليات',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.specialGold.withAlpha((0.15 * 255).round()),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.specialGold.withAlpha((0.3 * 255).round()),
                ),
              ),
              child: Text(
                '${_controller.history.length}',
                style: const TextStyle(
                  color: AppColors.specialGold,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistorySheet() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'سجل العمليات',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_controller.history.length} عملية',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: AppColors.secondary, height: 1),
            // List
            Expanded(
              child: _controller.history.isEmpty
                  ? const EmptyActivityList()
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: _controller.history.length,
                      itemBuilder: (context, index) {
                        return ActivityListItem(
                          transaction: _controller.history[index],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResetConfirmation() {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'إعادة تعيين البرميل',
            style: TextStyle(color: AppColors.textPrimary),
          ),
          content: const Text(
            'سيتم تصفير مستوى الزيت وحذف جميع العمليات المسجلة. هل تريد المتابعة؟',
            style: TextStyle(color: AppColors.textSecondary),
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
                backgroundColor: AppColors.withdraw,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                _controller.resetBarrel();
              },
              child: const Text('إعادة تعيين'),
            ),
          ],
        ),
      ),
    );
  }
}
