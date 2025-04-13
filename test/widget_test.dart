import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vet_app/main.dart';

void main() {
  testWidgets('App renders without errors', (WidgetTester tester) async {
    // Просто проверяем, что приложение запускается без ошибок
    await tester.pumpWidget(const VetMobileApp());
  });
}