import 'package:flutter/material.dart';
import '../models/barrel.dart';
import '../services/storage_service.dart';

/// Controller that manages all barrels
class BarrelsController extends ChangeNotifier {
  final StorageService _storageService;

  List<Barrel> _barrels = [];
  bool _isLoading = true;

  BarrelsController(this._storageService);

  /// Whether data is still loading
  bool get isLoading => _isLoading;

  /// List of all barrels
  List<Barrel> get barrels => List.unmodifiable(_barrels);

  /// Total number of barrels
  int get barrelCount => _barrels.length;

  /// Initialize the controller by loading data from storage
  Future<void> init() async {
    _barrels = _storageService.getBarrels();
    _isLoading = false;
    notifyListeners();
  }

  /// Add a new barrel
  Future<void> addBarrel({
    required String name,
    required String usage,
    double currentLevel = 0.0,
    double maxLevel = 200.0,
    String? notes,
  }) async {
    final barrel = Barrel(
      id: Barrel.generateId(),
      name: name,
      usage: usage,
      currentLevel: currentLevel,
      maxLevel: maxLevel,
      notes: notes,
    );

    await _storageService.addBarrel(barrel);
    _barrels.add(barrel);
    notifyListeners();
  }

  /// Update an existing barrel
  Future<void> updateBarrel(Barrel barrel) async {
    await _storageService.updateBarrel(barrel);

    final index = _barrels.indexWhere((b) => b.id == barrel.id);
    if (index != -1) {
      _barrels[index] = barrel;
      notifyListeners();
    }
  }

  /// Delete a barrel
  Future<void> deleteBarrel(String barrelId) async {
    await _storageService.deleteBarrel(barrelId);
    _barrels.removeWhere((b) => b.id == barrelId);
    notifyListeners();
  }

  /// Get a barrel by ID
  Barrel? getBarrel(String id) {
    try {
      return _barrels.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Refresh barrels from storage
  Future<void> refresh() async {
    _barrels = _storageService.getBarrels();
    notifyListeners();
  }
}
