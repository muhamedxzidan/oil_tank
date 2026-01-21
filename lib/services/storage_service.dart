import 'package:hive_flutter/hive_flutter.dart';
import '../models/barrel.dart';
import '../models/transaction.dart';

/// Service class for managing local storage using Hive
class StorageService {
  static const String _barrelsBoxName = 'barrels';
  static const String _transactionsBoxName = 'transactions';

  late Box<Barrel> _barrelsBox;
  late Box<Transaction> _transactionsBox;

  /// Initialize Hive and open boxes
  Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TransactionAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(BarrelAdapter());
    }

    // Open boxes
    _barrelsBox = await Hive.openBox<Barrel>(_barrelsBoxName);
    _transactionsBox = await Hive.openBox<Transaction>(_transactionsBoxName);
  }

  // ==================== Barrels ====================

  /// Get all barrels
  List<Barrel> getBarrels() {
    return _barrelsBox.values.toList();
  }

  /// Get a barrel by ID
  Barrel? getBarrel(String id) {
    try {
      return _barrelsBox.values.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Add a new barrel
  Future<void> addBarrel(Barrel barrel) async {
    await _barrelsBox.put(barrel.id, barrel);
  }

  /// Update an existing barrel
  Future<void> updateBarrel(Barrel barrel) async {
    await _barrelsBox.put(barrel.id, barrel);
  }

  /// Delete a barrel and its transactions
  Future<void> deleteBarrel(String barrelId) async {
    await _barrelsBox.delete(barrelId);

    // Delete all transactions for this barrel
    final transactionsToDelete = _transactionsBox.values
        .where((t) => t.barrelId == barrelId)
        .toList();

    for (final transaction in transactionsToDelete) {
      await transaction.delete();
    }
  }

  // ==================== Transactions ====================

  /// Get all transactions for a specific barrel
  List<Transaction> getTransactionsForBarrel(String barrelId) {
    return _transactionsBox.values
        .where((t) => t.barrelId == barrelId)
        .toList()
        .reversed
        .toList();
  }

  /// Add a new transaction
  Future<void> addTransaction(Transaction transaction) async {
    await _transactionsBox.add(transaction);
  }

  /// Clear all transactions for a barrel
  Future<void> clearTransactionsForBarrel(String barrelId) async {
    final transactionsToDelete = _transactionsBox.values
        .where((t) => t.barrelId == barrelId)
        .toList();

    for (final transaction in transactionsToDelete) {
      await transaction.delete();
    }
  }

  /// Close all boxes
  Future<void> close() async {
    await _barrelsBox.close();
    await _transactionsBox.close();
  }
}
