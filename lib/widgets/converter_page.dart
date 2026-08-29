import 'package:flutter/material.dart';

import '../models/converter.dart';
import '../models/unit.dart';

/// The main (and only) screen of the app: lets the user enter a value,
/// choose a "from" and "to" unit, and shows the converted result.
class ConverterPage extends StatefulWidget {
  const ConverterPage({super.key});

  @override
  State<ConverterPage> createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {
  final TextEditingController _valueController = TextEditingController();

  Unit _fromUnit = Unit.meters;
  Unit _toUnit = Unit.feet;

  String? _resultText;
  String? _errorText;

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  /// Handles a change of the "from" unit, keeping the "to" unit valid: if
  /// the newly selected category no longer matches, snap "to" to the first
  /// compatible unit other than the new "from" unit (falling back to it if
  /// the category only has one member).
  void _onFromUnitChanged(Unit? newUnit) {
    if (newUnit == null) return;
    setState(() {
      _fromUnit = newUnit;
      if (_toUnit.category != _fromUnit.category) {
        final compatible = _fromUnit.compatibleUnits;
        _toUnit = compatible.firstWhere(
          (unit) => unit != _fromUnit,
          orElse: () => compatible.first,
        );
      }
    });
  }

  void _onToUnitChanged(Unit? newUnit) {
    if (newUnit == null) return;
    setState(() => _toUnit = newUnit);
  }

  /// Swaps the "from" and "to" units. Always valid since [_toUnit] is
  /// already guaranteed to share [_fromUnit]'s category.
  void _swapUnits() {
    setState(() {
      final previousFrom = _fromUnit;
      _fromUnit = _toUnit;
      _toUnit = previousFrom;
      _resultText = null;
      _errorText = null;
    });
  }

  void _convert() {
    final double? inputValue = double.tryParse(_valueController.text);
    setState(() {
      if (inputValue == null) {
        _errorText = 'Please enter a valid number.';
        _resultText = null;
        return;
      }
      _errorText = null;
      final double result = convertValue(inputValue, _fromUnit, _toUnit);
      _resultText =
          '$inputValue ${_fromUnit.displayName} are '
          '${result.toStringAsFixed(3)} ${_toUnit.displayName}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.straighten),
            SizedBox(width: 8),
            Text('Measures Converter'),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 28,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _SectionLabel('Value'),
                  TextField(
                    controller: _valueController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Enter a value',
                      prefixIcon: Icon(Icons.numbers),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const _SectionLabel('From'),
                  _UnitDropdown(
                    key: const Key('fromUnitDropdown'),
                    value: _fromUnit,
                    units: Unit.values,
                    onChanged: _onFromUnitChanged,
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: IconButton.filledTonal(
                      onPressed: _swapUnits,
                      tooltip: 'Swap units',
                      icon: const Icon(Icons.swap_vert),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const _SectionLabel('To'),
                  _UnitDropdown(
                    key: const Key('toUnitDropdown'),
                    value: _toUnit,
                    units: _fromUnit.compatibleUnits,
                    onChanged: _onToUnitChanged,
                  ),
                  const SizedBox(height: 28),
                  ElevatedButton(
                    onPressed: _convert,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      foregroundColor: colorScheme.primary,
                      elevation: 3,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Convert'),
                  ),
                  const SizedBox(height: 24),
                  if (_errorText != null)
                    _ResultBanner(
                      text: _errorText!,
                      icon: Icons.error_outline,
                      backgroundColor: colorScheme.errorContainer,
                      foregroundColor: colorScheme.onErrorContainer,
                    ),
                  if (_resultText != null)
                    _ResultBanner(
                      text: _resultText!,
                      icon: Icons.check_circle,
                      backgroundColor: colorScheme.primaryContainer,
                      foregroundColor: colorScheme.onPrimaryContainer,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A centered, muted section heading (e.g. "Value", "From", "To").
class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}

/// A colored, rounded banner used to show the conversion result or an
/// input error, with a leading icon reinforcing success/failure.
class _ResultBanner extends StatelessWidget {
  const _ResultBanner({
    required this.text,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String text;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: foregroundColor),
          const SizedBox(height: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: foregroundColor),
          ),
        ],
      ),
    );
  }
}

/// Icon representing a [MeasurementCategory], used to give each dropdown a
/// quick visual cue of which family of units it's showing.
IconData _categoryIcon(MeasurementCategory category) {
  switch (category) {
    case MeasurementCategory.length:
      return Icons.straighten;
    case MeasurementCategory.weight:
      return Icons.scale;
  }
}

/// A full-width dropdown for selecting a [Unit] from a given list.
class _UnitDropdown extends StatelessWidget {
  const _UnitDropdown({
    super.key,
    required this.value,
    required this.units,
    required this.onChanged,
  });

  final Unit value;
  final List<Unit> units;
  final ValueChanged<Unit?> onChanged;

  @override
  Widget build(BuildContext context) {
    final unitTextStyle = TextStyle(
      color: Theme.of(context).colorScheme.primary,
    );
    return DropdownButtonFormField<Unit>(
      initialValue: value,
      isExpanded: true,
      style: unitTextStyle,
      decoration: InputDecoration(
        prefixIcon: Icon(_categoryIcon(value.category)),
        filled: true,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      items: [
        for (final unit in units)
          DropdownMenuItem(
            value: unit,
            child: Text(unit.displayName, style: unitTextStyle),
          ),
      ],
      onChanged: onChanged,
    );
  }
}
