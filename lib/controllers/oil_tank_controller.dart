import 'package:flutter/material.dart';
import '../models/barrel.dart';
import '../models/transaction.dart';
import '../services/storage_service.dart';
import '../services/audio_service.dart';

/// Controller that manages a single oil tank/barrel state and business logic
class OilTankController extends ChangeNotifier {
  final StorageService _storageService;
  final String barrelId;

  Barrel? _barrel;
  List<Transaction> _history = [];
  bool _isLoading = true;

  final AudioService _audioService = AudioService();

  OilTankController(this._storageService, this.barrelId);

  /// Whether data is still loading
  bool get isLoading => _isLoading;

  /// The current barrel
  Barrel? get barrel => _barrel;

  /// Current oil level in liters
  double get currentLevel => _barrel?.currentLevel ?? 0.0;

  /// Maximum tank capacity
  double get maxLevel => _barrel?.maxLevel ?? 200.0;

  /// Barrel name
  String get barrelName => _barrel?.name ?? '';

  /// Barrel usage type
  String get barrelUsage => _barrel?.usage ?? '';

  /// Percentage of tank filled (0.0 to 1.0)
  double get percentage => _barrel?.percentage ?? 0.0;

  /// Whether the tank level is low (below 20%)
  bool get isLowLevel => _barrel?.isLowLevel ?? false;

  /// Unmodifiable list of transaction history
  List<Transaction> get history => List.unmodifiable(_history);

  /// Initialize the controller by loading data from storage
  Future<void> init() async {
    _barrel = _storageService.getBarrel(barrelId);
    _history = _storageService.getTransactionsForBarrel(barrelId);
    _isLoading = false;
    notifyListeners();
  }

  /// Add oil to the tank
  Future<bool> addOil(
    double amount, {
    String? personName,
    String? notes,
  }) async {
    if (amount <= 0 || _barrel == null) return false;

    _barrel!.currentLevel = (_barrel!.currentLevel + amount).clamp(
      0,
      _barrel!.maxLevel,
    );
    await _storageService.updateBarrel(_barrel!);
    await _addTransaction(amount, personName: personName, notes: notes);
    _audioService.playSuccess();
    notifyListeners();
    return true;
  }

  /// Withdraw oil from the tank
  /// Returns true if successful, false if amount is invalid or exceeds available
  Future<bool> withdrawOil(
    double amount, {
    String? personName,
    String? notes,
  }) async {
    if (amount <= 0 || _barrel == null) return false;

    // Validation: لا يمكن سحب أكثر من المتاح
    if (amount > _barrel!.currentLevel) {
      return false;
    }

    _barrel!.currentLevel = (_barrel!.currentLevel - amount).clamp(
      0,
      _barrel!.maxLevel,
    );
    await _storageService.updateBarrel(_barrel!);
    await _addTransaction(-amount, personName: personName, notes: notes);
    _audioService.playWithdraw();
    notifyListeners();
    return true;
  }

  Future<void> _addTransaction(
    double amount, {
    String? personName,
    String? notes,
  }) async {
    final transaction = Transaction(
      amount: amount,
      date: DateTime.now(),
      remaining: _barrel!.currentLevel,
      barrelId: barrelId,
      personName: personName,
      notes: notes,
    );

    await _storageService.addTransaction(transaction);
    _history.insert(0, transaction);
  }

  /// Update barrel details
  Future<void> updateBarrelDetails({
    String? name,
    String? usage,
    double? maxLevel,
    String? notes,
  }) async {
    if (_barrel == null) return;

    if (name != null) _barrel!.name = name;
    if (usage != null) _barrel!.usage = usage;
    if (maxLevel != null) {
      _barrel!.maxLevel = maxLevel;
      _barrel!.currentLevel = _barrel!.currentLevel.clamp(0, maxLevel);
    }
    if (notes != null) _barrel!.notes = notes;

    await _storageService.updateBarrel(_barrel!);
    notifyListeners();
  }

  /// Reset barrel level and clear history
  Future<void> resetBarrel() async {
    if (_barrel == null) return;

    _barrel!.currentLevel = 0.0;
    _history.clear();

    await _storageService.updateBarrel(_barrel!);
    await _storageService.clearTransactionsForBarrel(barrelId);
    notifyListeners();
  }
}
