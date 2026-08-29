/// The family of units a [Unit] belongs to. Only units within the same
/// category can be meaningfully converted between each other.
enum MeasurementCategory {
  length('Length'),
  weight('Weight');

  const MeasurementCategory(this.label);

  /// Human-readable label for display in the UI.
  final String label;
}

/// A single unit of measurement.
///
/// Each unit knows its [category] and its [factorToBase]: the multiplier
/// that converts a value expressed in this unit into the category's base
/// unit (meters for length, grams for weight). Converting between any two
/// units of the same category is then a simple two-step multiplication —
/// see [convertValue] in `converter.dart`.
enum Unit {
  // Length units — base unit is meters.
  millimeters('millimeters', MeasurementCategory.length, 0.001),
  centimeters('centimeters', MeasurementCategory.length, 0.01),
  meters('meters', MeasurementCategory.length, 1.0),
  kilometers('kilometers', MeasurementCategory.length, 1000.0),
  inches('inches', MeasurementCategory.length, 0.0254),
  feet('feet', MeasurementCategory.length, 0.3048),
  yards('yards', MeasurementCategory.length, 0.9144),
  miles('miles', MeasurementCategory.length, 1609.344),

  // Weight units — base unit is grams.
  milligrams('milligrams', MeasurementCategory.weight, 0.001),
  grams('grams', MeasurementCategory.weight, 1.0),
  kilograms('kilograms', MeasurementCategory.weight, 1000.0),
  ounces('ounces', MeasurementCategory.weight, 28.349523125),
  pounds('pounds', MeasurementCategory.weight, 453.59237);

  const Unit(this.displayName, this.category, this.factorToBase);

  /// Name shown to the user in dropdowns and results.
  final String displayName;

  /// The measurement family this unit belongs to.
  final MeasurementCategory category;

  /// Multiplier that converts a value in this unit to the category's base
  /// unit (meters for length, grams for weight).
  final double factorToBase;

  /// All units that belong to the same [category] as this one.
  List<Unit> get compatibleUnits =>
      Unit.values.where((unit) => unit.category == category).toList();
}
