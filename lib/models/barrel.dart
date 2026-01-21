import 'package:hive/hive.dart';

part 'barrel.g.dart';

/// Model class representing an oil barrel
@HiveType(typeId: 1)
class Barrel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String usage; // نوع الاستخدام (مثل: زيت هيدروليك، زيت محرك، إلخ)

  @HiveField(3)
  double currentLevel;

  @HiveField(4)
  double maxLevel;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  String? notes;

  Barrel({
    required this.id,
    required this.name,
    required this.usage,
    this.currentLevel = 0.0,
    this.maxLevel = 200.0,
    DateTime? createdAt,
    this.notes,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Percentage of barrel filled (0.0 to 1.0)
  double get percentage =>
      maxLevel > 0 ? (currentLevel / maxLevel).clamp(0.0, 1.0) : 0.0;

  /// Whether the barrel level is low (below 20%)
  bool get isLowLevel => percentage < 0.2;

  /// Generate a unique ID for new barrels
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// Create a copy of the barrel with updated values
  Barrel copyWith({
    String? name,
    String? usage,
    double? currentLevel,
    double? maxLevel,
    String? notes,
  }) {
    return Barrel(
      id: id,
      name: name ?? this.name,
      usage: usage ?? this.usage,
      currentLevel: currentLevel ?? this.currentLevel,
      maxLevel: maxLevel ?? this.maxLevel,
      createdAt: createdAt,
      notes: notes ?? this.notes,
    );
  }
}
