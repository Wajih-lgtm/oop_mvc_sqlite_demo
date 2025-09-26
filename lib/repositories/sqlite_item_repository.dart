import 'package:sqflite/sqflite.dart';
import '../core/db/database_helper.dart';
import '../models/item.dart';
import 'base_repository.dart';

class SqliteItemRepository implements ItemRepository {
  @override
  Future<List<Item>> getAll() async {
    final db = await DatabaseHelper.instance.database;
    final rows = await db.query('items', orderBy: 'id DESC');
    return rows.map((e) => Item.fromMap(e)).toList();
  }

  @override
  Future<Item> create(Item item) async {
    final db = await DatabaseHelper.instance.database;
    final id = await db.insert('items', item.toMap());
    return item.copyWith(id: id);
  }

  @override
  Future<Item> update(Item item) async {
    final db = await DatabaseHelper.instance.database;
    await db.update('items', item.toMap(), where: 'id = ?', whereArgs: [item.id]);
    return item;
  }

  @override
  Future<void> delete(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('items', where: 'id = ?', whereArgs: [id]);
  }
}
