import 'package:hive/hive.dart';

enum TransactionType {
  income,
  expense,
}

class TransactionTypeAdapter extends TypeAdapter<TransactionType> {
  @override
  final int typeId = 0;

  @override
  TransactionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TransactionType.income;
      case 1:
        return TransactionType.expense;
      default:
        return TransactionType.expense;
    }
  }

  @override
  void write(BinaryWriter writer, TransactionType obj) {
    switch (obj) {
      case TransactionType.income:
        writer.writeByte(0);
        break;
      case TransactionType.expense:
        writer.writeByte(1);
        break;
    }
  }
}

class TransactionAdapter extends TypeAdapter<Transaction> {
  @override
  final int typeId = 1;

  @override
  Transaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transaction(
      id: fields[0] as String,
      title: fields[1] as String,
      amount: fields[2] as double,
      categoryId: fields[3] as String,
      date: DateTime.parse(fields[4] as String),
      type: fields[5] as TransactionType,
      description: fields[6] as String?,
      createdAt: DateTime.parse(fields[7] as String),
      updatedAt: DateTime.parse(fields[8] as String),
    );
  }

  @override
  void write(BinaryWriter writer, Transaction obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.categoryId)
      ..writeByte(4)
      ..write(obj.date.toIso8601String())
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.createdAt.toIso8601String())
      ..writeByte(8)
      ..write(obj.updatedAt.toIso8601String());
  }
}

class Transaction extends HiveObject {
  String id;
  String title;
  double amount;
  String categoryId;
  DateTime date;
  TransactionType type;
  String? description;
  DateTime createdAt;
  DateTime updatedAt;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.categoryId,
    required this.date,
    required this.type,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  Transaction copyWith({
    String? id,
    String? title,
    double? amount,
    String? categoryId,
    DateTime? date,
    TransactionType? type,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      date: date ?? this.date,
      type: type ?? this.type,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

