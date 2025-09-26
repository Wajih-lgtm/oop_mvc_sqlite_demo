import 'package:sqflite/sqflite.dart';
import '../core/db/database_helper.dart';
import '../models/user.dart';
import 'base_repository.dart';

/// تنفيذ واجهة المصادقة باستخدام SQLite.
/// يمكن لاحقًا إنشاء MySqlAuthRepository بنفس الواجهة بدون تغيير الواجهات/الشاشات.
class SqliteAuthRepository implements AuthRepository {
  @override
  Future<User?> login(String email, String password) async {
    final db = await DatabaseHelper.instance.database;
    final rows = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    if (rows.isEmpty) return null;

    final user = User.fromMap(rows.first);
    return user.verifyPassword(password) ? user : null;
  }

  @override
  Future<User> register(String email, String name, String password) async {
    final db = await DatabaseHelper.instance.database;
    final hash = User.hashPassword(password);

    final id = await db.insert('users', {
      'email': email,
      'name': name,
      'password_hash': hash,
    });

    return User(id: id, email: email, name: name, passwordHash: hash);
  }

  @override
  Future<User?> findByEmail(String email) async {
    final db = await DatabaseHelper.instance.database;
    final rows = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return User.fromMap(rows.first);
  }
}
