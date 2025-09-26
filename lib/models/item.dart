import 'base_model.dart';

/// Item: نموذج بسيط لعناصر CRUD.
/// يعرض الوراثة من BaseModel والتغليف عبر استخدام final والإنشاء المنضبط.
class Item extends BaseModel {
  final String title;
  final String? description;
  final DateTime createdAt;

  Item({
    int? id,
    required this.title,
    this.description,
    required this.createdAt,
  }) : super(id: id);

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'created_at': createdAt.toIso8601String(),
  };

  factory Item.fromMap(Map<String, dynamic> map) => Item(
    id: map['id'] as int?,
    title: map['title'] as String,
    description: map['description'] as String?,
    createdAt: DateTime.parse(map['created_at'] as String),
  );

  Item copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? createdAt,
  }) {
    return Item(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
