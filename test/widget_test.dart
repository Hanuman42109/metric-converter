import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:metric_converter/main.dart';
import 'package:metric_converter/models/unit.dart';

void main() {
  testWidgets('converts 100 meters to feet on Convert tap', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MeasuresConverterApp());

    // Default From/To is meters -> feet; enter a value and convert.
    await tester.enterText(find.byType(TextField), '100');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Convert'));
    await tester.pump();

    expect(find.text('100.0 meters are 328.084 feet'), findsOneWidget);
  });

  testWidgets('changing From to a weight unit filters the To dropdown', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MeasuresConverterApp());

    // Selecting a unit through the Material dropdown's overlay route is
    // notoriously flaky to drive from widget tests, so invoke the
    // dropdown's onChanged callback directly instead.
    final fromDropdown = tester.widget<DropdownButtonFormField<Unit>>(
      find.descendant(
        of: find.byKey(const Key('fromUnitDropdown')),
        matching: find.byType(DropdownButtonFormField<Unit>),
      ),
    );
    fromDropdown.onChanged!(Unit.kilograms);
    await tester.pump();

    // "To" should no longer offer "feet" (a length unit).
    expect(find.text('feet'), findsNothing);
  });

  testWidgets('invalid input shows an error instead of crashing', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MeasuresConverterApp());

    await tester.enterText(find.byType(TextField), 'not a number');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Convert'));
    await tester.pump();

    expect(find.text('Please enter a valid number.'), findsOneWidget);
  });
}
