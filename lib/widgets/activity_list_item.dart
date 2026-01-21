import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/transaction.dart';

/// A single item in the activity list showing transaction details
class ActivityListItem extends StatelessWidget {
  final Transaction transaction;

  const ActivityListItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildIcon(),
              const SizedBox(width: 15),
              _buildDetails(),
              _buildAmount(),
            ],
          ),
          if (transaction.personName != null || transaction.notes != null) ...[
            const SizedBox(height: 12),
            const Divider(color: AppColors.secondary, height: 1),
            const SizedBox(height: 12),
            _buildExtraInfo(),
          ],
        ],
      ),
    );
  }

  Widget _buildIcon() {
    final Color iconColor = transaction.isWithdraw
        ? AppColors.withdraw
        : AppColors.deposit;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: iconColor.withAlpha((0.1 * 255).round()),
        shape: BoxShape.circle,
      ),
      child: Icon(
        transaction.isWithdraw ? Icons.arrow_downward : Icons.arrow_upward,
        color: iconColor,
        size: 20,
      ),
    );
  }

  Widget _buildDetails() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            transaction.isWithdraw ? 'سحب كمية' : 'إضافة كمية',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            _formatDateTime(transaction.date),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmount() {
    final Color amountColor = transaction.isWithdraw
        ? AppColors.withdraw
        : AppColors.deposit;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${transaction.isWithdraw ? '' : '+'}${transaction.amount.toStringAsFixed(1)}L',
          style: TextStyle(
            color: amountColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          'المتبقي: ${transaction.remaining.toStringAsFixed(1)}',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildExtraInfo() {
    return Row(
      children: [
        if (transaction.personName != null) ...[
          const Icon(
            Icons.person_outline,
            size: 16,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 6),
          Text(
            transaction.personName!,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          if (transaction.notes != null) const SizedBox(width: 16),
        ],
        if (transaction.notes != null) ...[
          const Icon(
            Icons.note_outlined,
            size: 16,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              transaction.notes!,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }

  String _formatDateTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) {
      return 'الآن';
    } else if (diff.inHours < 1) {
      return 'منذ ${diff.inMinutes} دقيقة';
    } else if (diff.inDays < 1) {
      return 'منذ ${diff.inHours} ساعة';
    } else if (diff.inDays == 1) {
      return 'أمس ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day}/${date.month} - ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    }
  }
}

/// Empty state widget for when there are no transactions
class EmptyActivityList extends StatelessWidget {
  const EmptyActivityList({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 48,
            color: AppColors.textSecondary.withAlpha((0.5 * 255).round()),
          ),
          const SizedBox(height: 16),
          const Text(
            'لا يوجد نشاط مسجل حتى الآن',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
