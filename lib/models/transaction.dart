import 'package:hive/hive.dart';

part 'transaction.g.dart';

/// Model class representing an oil transaction (deposit or withdrawal)
@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  final double amount;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final double remaining;

  @HiveField(3)
  final String barrelId;

  @HiveField(4)
  final String? personName; // اسم الشخص الذي قام بالعملية

  @HiveField(5)
  final String? notes; // ملاحظات إضافية

  Transaction({
    required this.amount,
    required this.date,
    required this.remaining,
    required this.barrelId,
    this.personName,
    this.notes,
  });

  /// Returns true if this is a withdrawal transaction
  bool get isWithdraw => amount < 0;

  /// Returns the absolute amount of the transaction
  double get absoluteAmount => amount.abs();
}
