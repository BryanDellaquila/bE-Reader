import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'package:pdf_reader/features/library/models/book.dart';
import 'package:pdf_reader/features/library/providers/library_provider.dart';
import 'package:pdf_reader/features/library/screens/library_screen.dart';

/// O método [main] é o ponto de partida (a porta de entrada) de qualquer aplicativo Flutter.
void main() async {
  // 1. Garante que a ponte entre o Flutter e o sistema nativo esteja pronta.
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicializa o Hive.
  await Hive.initFlutter();

  // 3. Registramos o nosso "tradutor" (Adapter) para o Hive saber salvar a classe Book.
  Hive.registerAdapter(BookAdapter());

  // 4. Depois de tudo configurado, chamamos o método [runApp] para desenhar o app na tela.
  runApp(const PdfReaderApp());
}

/// O [PdfReaderApp] é o "esqueleto" principal do nosso aplicativo.
class PdfReaderApp extends StatelessWidget {
  const PdfReaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 5. Precisamos envolver nosso MaterialApp com um MultiProvider.
    // Isso injeta nossos "Providers" (os cérebros do app) na árvore de widgets,
    // permitindo que qualquer tela consiga acessar os dados.
    return MultiProvider(
      providers: [
        // Disponibilizamos o LibraryProvider para todo o aplicativo!
        ChangeNotifierProvider(create: (_) => LibraryProvider()),
      ],
      child: MaterialApp(
        title: 'PDF Reader',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // Agora, a nossa tela inicial é a Estante (LibraryScreen) em vez daquela provisória!
        home: const LibraryScreen(),
      ),
    );
  }
}
