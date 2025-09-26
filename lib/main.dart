import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'controllers/auth_controller.dart';
import 'controllers/item_controller.dart';
import 'repositories/sqlite_auth_repository.dart';
import 'repositories/sqlite_item_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة المستودعات (Repositories) التي تتعامل مع البيانات (SQLite الآن)
  final authRepo = SqliteAuthRepository();
  final itemRepo = SqliteItemRepository();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthController(authRepo)),
      ChangeNotifierProvider(create: (_) => ItemController(itemRepo)),
    ],
    child: const MyApp(),
  ));
}
