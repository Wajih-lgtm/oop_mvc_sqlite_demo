import 'package:flutter/material.dart';
import 'views/login_screen.dart';
import 'views/items_list_screen.dart';
import 'views/item_form_screen.dart';

class Routes {
  static const login = '/';
  static const items = '/items';
  static const itemForm = '/itemForm';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case items:
        return MaterialPageRoute(builder: (_) => const ItemsListScreen());
      case itemForm:
      // تمرير عنصر للتحرير (اختياري)
        final args = settings.arguments;
        return MaterialPageRoute(builder: (_) => ItemFormScreen(itemArg: args));
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}
