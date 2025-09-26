import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

/// DatabaseHelper: نمط Singleton لإدارة SQLite من مكان واحد.
/// - إنشاء الجداول (users, items)
/// - زرع مستخدم افتراضي عند أول تشغيل (admin@example.com / 123456) مع تشفير SHA-256
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _db;
  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _init();
    return _db!;
  }

  Future<Database> _init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_oop_mvc.sqlite');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // جدول المستخدمين
        await db.execute('''
        CREATE TABLE users(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          email TEXT UNIQUE NOT NULL,
          name TEXT NOT NULL,
          password_hash TEXT NOT NULL
        );
        ''');

        // جدول العناصر (مثلاً ملاحظات/منتجات…)
        await db.execute('''
        CREATE TABLE items(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          description TEXT,
          created_at TEXT NOT NULL
        );
        ''');

        // زرع مستخدم افتراضي
        final defaultEmail = 'admin@example.com';
        final defaultName = 'Admin';
        final defaultPassword = '123456';
        final hash = sha256.convert(utf8.encode(defaultPassword)).toString();

        await db.insert('users', {
          'email': defaultEmail,
          'name': defaultName,
          'password_hash': hash,
        });
      },
    );
  }
}
