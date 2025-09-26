import 'package:flutter/foundation.dart';
import '../models/item.dart';
import '../repositories/base_repository.dart';

/// ItemController: منطق الأعمال لقائمة العناصر (CRUD).
class ItemController extends ChangeNotifier {
  final ItemRepository _repo;

  List<Item> _items = [];
  bool _loading = false;
  String? _error;

  ItemController(this._repo);

  /// قائمة للقراءة فقط (حماية للتغليف)
  List<Item> get items => List.unmodifiable(_items);
  bool get isLoading => _loading;
  String? get error => _error;

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _items = await _repo.getAll();
    } catch (e) {
      _error = 'فشل تحميل العناصر.';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> add(String title, String? description) async {
    try {
      final created = await _repo.create(
        Item(
          title: title,
          description: description,
          createdAt: DateTime.now(),
        ),
      );
      _items = [created, ..._items];
      notifyListeners();
    } catch (e) {
      _error = 'تعذّر إضافة العنصر.';
      notifyListeners();
    }
  }

  /// الدالة المتوقعة من شاشة الفورم
  Future<void> updateItem(
      Item item, {
        required String title,
        String? desc,
      }) async {
    try {
      final updated = await _repo.update(
        item.copyWith(
          title: title,
          description: desc,
          createdAt: item.createdAt,
        ),
      );
      final idx = _items.indexWhere((i) => i.id == updated.id);
      if (idx != -1) {
        _items[idx] = updated;
      }
      notifyListeners();
    } catch (e) {
      _error = 'تعذّر تعديل العنصر.';
      notifyListeners();
    }
  }

  Future<void> remove(int id) async {
    try {
      await _repo.delete(id);
      _items.removeWhere((i) => i.id == id);
      notifyListeners();
    } catch (e) {
      _error = 'تعذّر حذف العنصر.';
      notifyListeners();
    }
  }
}
