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
    return Scaffold(
      appBar: AppBar(title: const Text('Measures Converter')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
              ),
              const SizedBox(height: 24),
              const _SectionLabel('From'),
              _UnitDropdown(
                key: const Key('fromUnitDropdown'),
                value: _fromUnit,
                units: Unit.values,
                onChanged: _onFromUnitChanged,
              ),
              const SizedBox(height: 24),
              const _SectionLabel('To'),
              _UnitDropdown(
                key: const Key('toUnitDropdown'),
                value: _toUnit,
                units: _fromUnit.compatibleUnits,
                onChanged: _onToUnitChanged,
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _convert,
                  child: const Text('Convert'),
                ),
              ),
              const SizedBox(height: 24),
              if (_errorText != null)
                Center(
                  child: Text(
                    _errorText!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              if (_resultText != null)
                Center(
                  child: Text(
                    _resultText!,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
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
