import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:coralis_auth_app/app/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Login'), findsOneWidget);
  });
}
