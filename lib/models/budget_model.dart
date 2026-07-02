<<<<<<< HEAD
import 'package:hive/hive.dart';

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
      year: fields[3] as int,
      month: fields[4] as int,
      createdAt: fields[5] as DateTime,
      updatedAt: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Budget obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.categoryId)
      ..writeByte(2)
      ..write(obj.limitAmount)
      ..writeByte(3)
      ..write(obj.year)
      ..writeByte(4)
      ..write(obj.month)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt);
  }
}

enum BudgetStatus { ok, warning, exceeded }

class Budget extends HiveObject {
  String id;
  String categoryId;
  double limitAmount;
  int year;
  int month;
  DateTime createdAt;
  DateTime? updatedAt;

  Budget({
    required this.id,
    required this.categoryId,
    required this.limitAmount,
    required this.year,
    required this.month,
    required this.createdAt,
    this.updatedAt,
  });

  static String createId(String categoryId, int year, int month) {
    return '${categoryId}_${year}_$month';
  }

  Budget copyWith({
    String? id,
    String? categoryId,
    double? limitAmount,
    int? year,
    int? month,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Budget(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      limitAmount: limitAmount ?? this.limitAmount,
      year: year ?? this.year,
      month: month ?? this.month,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class BudgetProgress {
  final Budget budget;
  final double spent;
  final double percentage;
  final BudgetStatus status;
  final double remaining;

  const BudgetProgress({
    required this.budget,
    required this.spent,
    required this.percentage,
    required this.status,
    required this.remaining,
  });
}
=======
import 'package:hive/hive.dart';

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
>>>>>>> 0341b2aace011fd5299e50e2816cd34a66c588a9
