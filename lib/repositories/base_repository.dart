import '../models/user.dart';
import '../models/item.dart';

/// الواجهات (Abstraction) تفصل منطق البيانات عن بقية التطبيق:

abstract class AuthRepository {
  Future<User?> login(String email, String password);
  Future<User> register(String email, String name, String password);
  Future<User?> findByEmail(String email);
}

abstract class ItemRepository {
  Future<List<Item>> getAll();
  Future<Item> create(Item item);
  Future<Item> update(Item item);
  Future<void> delete(int id);
}

/// بفضل هذه الواجهات يمكن تبديل SQLite بـ REST/MySQL لاحقًا (Polymorphism).
