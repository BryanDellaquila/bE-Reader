import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pdf_reader/main.dart';

void main() {
  testWidgets('Testa se a Base do App Configurada é exibida', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PdfReaderApp());

    // Verify that our message is displayed.
    expect(find.text('Base do App Configurada'), findsOneWidget);
  });
}
