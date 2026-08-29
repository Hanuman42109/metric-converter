import 'unit.dart';

/// Converts [value] expressed in [from] into the equivalent value in [to].
///
/// Both units must belong to the same [MeasurementCategory] (e.g. you can't
/// convert meters to kilograms). Throws an [ArgumentError] otherwise.
double convertValue(double value, Unit from, Unit to) {
  if (from.category != to.category) {
    throw ArgumentError(
      'Cannot convert between ${from.category.label} and '
      '${to.category.label} units.',
    );
  }
  // Convert to the category's base unit, then from the base unit to the
  // target unit.
  final double valueInBaseUnit = value * from.factorToBase;
  return valueInBaseUnit / to.factorToBase;
}
