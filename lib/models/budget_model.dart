import 'package:hive/hive.dart';

enum BudgetStatus { ok, warning, exceeded }

class BudgetProgress {
  final Budget budget;
  final double spent;
  final double percentage;
  final double remaining;
  final BudgetStatus status;

  const BudgetProgress({
    required this.budget,
    required this.spent,
    required this.percentage,
    required this.remaining,
    required this.status,
  });
}

class BudgetAdapter extends TypeAdapter<Budget> {
  @override
  final int typeId = 3;

  @override
  Budget read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return Budget(
      id: fields[0] as String,
      categoryId: fields[1] as String,
      limitAmount: fields[2] as double,
      monthKey: fields[3] as String,
      createdAt: DateTime.parse(fields[4] as String),
      updatedAt: DateTime.parse(fields[5] as String),
    );
  }

  @override
  void write(BinaryWriter writer, Budget obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.categoryId)
      ..writeByte(2)
      ..write(obj.limitAmount)
      ..writeByte(3)
      ..write(obj.monthKey)
      ..writeByte(4)
      ..write(obj.createdAt.toIso8601String())
      ..writeByte(5)
      ..write(obj.updatedAt.toIso8601String());
  }
}

class Budget extends HiveObject {
  String id;
  String categoryId;
  double limitAmount;
  String monthKey;
  DateTime createdAt;
  DateTime updatedAt;

  static String createId(String categoryId, String monthKey) {
    return '${categoryId}_$monthKey';
  }

  Budget({
    required this.id,
    required this.categoryId,
    required this.limitAmount,
    required this.monthKey,
    required this.createdAt,
    required this.updatedAt,
  });

  Budget copyWith({
    String? id,
    String? categoryId,
    double? limitAmount,
    String? monthKey,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Budget(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      limitAmount: limitAmount ?? this.limitAmount,
      monthKey: monthKey ?? this.monthKey,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}