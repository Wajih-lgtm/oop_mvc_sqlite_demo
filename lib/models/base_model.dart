/// BaseModel: تجريد (Abstraction) لنماذج البيانات.
/// يعرّف واجهات مشتركة يمكن أن ترثها النماذج الأخرى (Inheritance).
abstract class BaseModel {
  final int? id; // تغليف: نجعل الحقل نهائيًا مع إمكانية كونه null قبل الحفظ
  const BaseModel({this.id});

  Map<String, dynamic> toMap(); // لكل نموذج تحويل لـ Map
}
