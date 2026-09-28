import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:pdf_reader/main.dart';
import 'package:pdf_reader/features/library/models/book.dart';

void main() {
  // Configuração necessária para testes com Hive
  setUpAll(() async {
    // Para testes no ambiente de linha de comando, precisamos inicializar o hive
    // com um diretório de testes, mas como só queremos testar a renderização da UI base,
    // usaremos o Hive na memória e mockaremos o mínimo possível.
    Hive.init('test_hive');
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(BookAdapter());
    }
  });

  tearDownAll(() async {
    await Hive.close();
  });

  testWidgets('Testa se a LibraryScreen é carregada corretamente', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PdfReaderApp());
    // Esperamos o Future das inicializações do provider
    await tester.pumpAndSettle();

    // Verify that our AppBar title is displayed.
    expect(find.text('Minha Biblioteca'), findsOneWidget);

    // Verify that the empty state is displayed initially.
    expect(find.text('Sua estante está vazia.'), findsOneWidget);
  });
}
