import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:financial_tracker/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('adds a transaction through the real app flow', (tester) async {
    await app.main();
    await tester.pumpAndSettle();

    final uniqueTitle = 'Integration ${DateTime.now().millisecondsSinceEpoch}';

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(OutlinedButton));
    await tester.pumpAndSettle();

    final textFields = find.byType(TextFormField);
    expect(textFields, findsNWidgets(3));

    await tester.enterText(textFields.at(0), uniqueTitle);
    await tester.enterText(textFields.at(1), '42.50');
    await tester.enterText(textFields.at(2), 'Integration test description');

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.text(uniqueTitle), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text(uniqueTitle), findsWidgets);
  });
}