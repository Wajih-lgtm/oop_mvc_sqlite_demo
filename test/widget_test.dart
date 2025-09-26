import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oop_mvc_sqlite_demo/app.dart';
import 'package:oop_mvc_sqlite_demo/routes.dart';

void main() {
  testWidgets('Login screen is the first screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // تحقق أن نص "تسجيل الدخول" ظاهر
    expect(find.text('تسجيل الدخول'), findsOneWidget);

    // تحقق أن زر "دخول" موجود
    expect(find.text('دخول'), findsOneWidget);
  });
}
