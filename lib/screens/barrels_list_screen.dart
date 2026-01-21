import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../controllers/barrels_controller.dart';
import '../services/storage_service.dart';
import '../widgets/widgets.dart';
import 'barrel_detail_screen.dart';

/// Screen showing list of all barrels
class BarrelsListScreen extends StatefulWidget {
  const BarrelsListScreen({super.key});

  @override
  State<BarrelsListScreen> createState() => _BarrelsListScreenState();
}

class _BarrelsListScreenState extends State<BarrelsListScreen> {
  late final StorageService _storageService;
  late final BarrelsController _controller;

  @override
  void initState() {
    super.initState();
    _storageService = StorageService();
    _controller = BarrelsController(_storageService);
    _controller.addListener(_onControllerUpdate);
    _initializeController();
  }

  Future<void> _initializeController() async {
    await _storageService.init();
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

  void _showAddBarrelDialog() {
    BarrelFormDialog.show(
      context: context,
      onConfirm:
          ({
            required String name,
            required String usage,
            required double maxLevel,
            String? notes,
          }) {
            _controller.addBarrel(
              name: name,
              usage: usage,
              maxLevel: maxLevel,
              notes: notes,
            );
          },
    );
  }

  void _navigateToBarrelDetail(String barrelId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BarrelDetailScreen(
          barrelId: barrelId,
          storageService: _storageService,
        ),
      ),
    );
    // Refresh the list when coming back
    await _controller.refresh();
  }

  void _showDeleteConfirmation(String barrelId, String barrelName) {
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
            'حذف البرميل',
            style: TextStyle(color: AppColors.textPrimary),
          ),
          content: Text(
            'هل أنت متأكد من حذف "$barrelName"؟\nسيتم حذف جميع البيانات المرتبطة به.',
            style: const TextStyle(color: AppColors.textSecondary),
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
                _controller.deleteBarrel(barrelId);
              },
              child: const Text('حذف'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(child: _buildContent()),
      ),
      floatingActionButton: _controller.barrels.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _showAddBarrelDialog,
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'إضافة برميل',
                style: TextStyle(color: Colors.white),
              ),
            )
          : null,
    );
  }

  Widget _buildContent() {
    if (_controller.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    return Column(
      children: [
        BarrelsHeader(barrelCount: _controller.barrelCount),
        Expanded(
          child: _controller.barrels.isEmpty
              ? _buildEmptyState()
              : _buildBarrelsList(),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.oil_barrel_outlined,
              size: 100,
              color: AppColors.textSecondary.withAlpha((0.3 * 255).round()),
            ),
            const SizedBox(height: 32),
            const Text(
              'لا توجد براميل',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'ابدأ بإضافة برميل جديد لتتبع مستوى الزيت',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: _showAddBarrelDialog,
              icon: const Icon(Icons.add),
              label: const Text('إضافة برميل جديد'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarrelsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _controller.barrels.length,
      itemBuilder: (context, index) {
        final barrel = _controller.barrels[index];
        return BarrelCard(
          barrel: barrel,
          onTap: () => _navigateToBarrelDetail(barrel.id),
          onLongPress: () => _showDeleteConfirmation(barrel.id, barrel.name),
        );
      },
    );
  }
}
