import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:financial_tracker/widgets/app_empty_state.dart';

void main() {
  testWidgets('renders empty state title and subtitle', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppEmptyState(
            title: 'No entries yet',
            subtitle: 'Start by creating your first transaction.',
            icon: Icons.receipt_long,
          ),
        ),
      ),
    );

    expect(find.text('No entries yet'), findsOneWidget);
    expect(find.text('Start by creating your first transaction.'), findsOneWidget);
  });
}
