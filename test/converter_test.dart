import 'package:flutter_test/flutter_test.dart';
import 'package:metric_converter/models/converter.dart';
import 'package:metric_converter/models/unit.dart';

void main() {
  group('convertValue', () {
    test('converts meters to feet', () {
      final result = convertValue(100, Unit.meters, Unit.feet);
      expect(result, closeTo(328.084, 0.001));
    });

    test('converts miles to kilometers', () {
      final result = convertValue(1, Unit.miles, Unit.kilometers);
      expect(result, closeTo(1.609344, 0.000001));
    });

    test('converts kilograms to pounds', () {
      final result = convertValue(1, Unit.kilograms, Unit.pounds);
      expect(result, closeTo(2.2046226, 0.0001));
    });

    test('same unit is a no-op', () {
      expect(convertValue(42, Unit.grams, Unit.grams), 42);
    });

    test('throws when converting across categories', () {
      expect(
        () => convertValue(1, Unit.meters, Unit.kilograms),
        throwsArgumentError,
      );
    });
  });

  group('Unit.compatibleUnits', () {
    test('only returns units in the same category', () {
      expect(Unit.meters.compatibleUnits, everyElement(isA<Unit>()));
      expect(
        Unit.meters.compatibleUnits.every(
          (u) => u.category == MeasurementCategory.length,
        ),
        isTrue,
      );
      expect(Unit.meters.compatibleUnits.contains(Unit.kilograms), isFalse);
    });
  });
}
