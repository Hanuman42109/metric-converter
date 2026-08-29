import 'package:flutter/material.dart';

import 'widgets/converter_page.dart';

void main() {
  runApp(const MeasuresConverterApp());
}

/// Root widget of the Measures Converter app.
class MeasuresConverterApp extends StatelessWidget {
  const MeasuresConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Measures Converter',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      home: const ConverterPage(),
    );
  }
}
