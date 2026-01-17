import 'package:hive/hive.dart';
import 'transaction_model.dart';

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final int typeId = 2;

  @override
  Category read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Category(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as TransactionType,
      colorValue: fields[3] as int,
      icon: fields[4] as String,
      isDefault: fields[5] as bool? ?? false,
      parentCategoryId: fields[6] as String?,
      isCustom: fields[7] as bool? ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.colorValue)
      ..writeByte(4)
      ..write(obj.icon)
      ..writeByte(5)
      ..write(obj.isDefault)
      ..writeByte(6)
      ..write(obj.parentCategoryId)
      ..writeByte(7)
      ..write(obj.isCustom);
  }
}

class Category extends HiveObject {
  String id;
  String name;
  TransactionType type;
  int colorValue;
  String icon;
  bool isDefault;
  String? parentCategoryId;
  bool isCustom;

  Category({
    required this.id,
    required this.name,
    required this.type,
    required this.colorValue,
    required this.icon,
    this.isDefault = false,
    this.parentCategoryId,
    this.isCustom = false,
  });

  Category copyWith({
    String? id,
    String? name,
    TransactionType? type,
    int? colorValue,
    String? icon,
    bool? isDefault,
    String? parentCategoryId,
    bool? isCustom,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      colorValue: colorValue ?? this.colorValue,
      icon: icon ?? this.icon,
      isDefault: isDefault ?? this.isDefault,
      parentCategoryId: parentCategoryId ?? this.parentCategoryId,
      isCustom: isCustom ?? this.isCustom,
    );
  }
}
