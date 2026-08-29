# Measures Converter

A small Flutter app for converting values between units of **length** and **weight**.

## Features

- Enter a value and pick a "From" and "To" unit
- Length: millimeters, centimeters, meters, kilometers, inches, feet, yards, miles
- Weight: milligrams, grams, kilograms, ounces, pounds
- The "To" dropdown only shows units compatible with the selected "From" category
- Runs on web and Windows desktop

## Project structure

- [lib/models/unit.dart](lib/models/unit.dart) — `Unit` enum and `MeasurementCategory` (length/weight), each unit's conversion factor to its category's base unit
- [lib/models/converter.dart](lib/models/converter.dart) — `convertValue()`, the core conversion logic
- [lib/widgets/converter_page.dart](lib/widgets/converter_page.dart) — the app's single screen (input field, unit dropdowns, convert button, result)
- [lib/main.dart](lib/main.dart) — app entry point and theming
- [test/](test/) — unit tests for the conversion logic and a widget test for the page

## Getting started

Requires the [Flutter SDK](https://docs.flutter.dev/get-started/install).

```bash
flutter pub get
flutter run           # pick a device, e.g. Chrome or Windows
```

Run tests:

```bash
flutter test
```
