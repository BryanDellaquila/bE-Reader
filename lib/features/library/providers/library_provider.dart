import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pdf_reader/features/library/models/book.dart';

/// O [LibraryProvider] atua como o "cérebro" da nossa estante.
/// Ele herda de [ChangeNotifier], o que significa que ele pode "avisar" a tela
/// toda vez que um novo livro for adicionado, fazendo a tela se atualizar sozinha.
class LibraryProvider extends ChangeNotifier {
  // O nome da "caixa" (tabela) onde o Hive vai guardar nossos livros.
  static const String _boxName = 'libraryBox';

  // A lista local de livros que será mostrada na tela.
  List<Book> _books = [];

  // Um getter (forma segura de ler a lista de fora) que retorna os livros atuais.
  List<Book> get books => _books;

  /// Ao inicializar o provider, queremos carregar os livros já salvos.
  LibraryProvider() {
    _loadBooks();
  }

  /// Método responsável por buscar os dados salvos no Hive e colocar na lista [_books].
  Future<void> _loadBooks() async {
    // Abre a caixa (caso ainda não esteja aberta).
    final box = await Hive.openBox<Book>(_boxName);

    // Converte os dados do Hive para uma lista padrão do Dart.
    _books = box.values.toList();

    // Avisa a tela (UI) que a lista mudou e ela precisa se redesenhar!
    notifyListeners();
  }

  /// O grande método que importa um novo PDF para a estante.
  Future<void> pickAndImportPdf() async {
    try {
      // 1. Abrimos o explorador de arquivos do celular permitindo APENAS arquivos PDF.
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      // Se o usuário cancelou a escolha, não fazemos nada.
      if (result == null || result.files.isEmpty) return;

      // Pegamos o arquivo original selecionado pelo usuário.
      final selectedFile = File(result.files.single.path!);

      // Pegamos o nome do arquivo (ex: "Aventura.pdf").
      final fileName = result.files.single.name;

      // 2. Segurança! Para evitar que o app perca o livro se o usuário deletar dos 'Downloads',
      // copiamos o arquivo para a "pasta segura e secreta" do nosso app.
      final appDir = await getApplicationDocumentsDirectory();

      // Criamos o caminho final onde o livro vai morar no nosso app.
      final savedFilePath = '${appDir.path}/$fileName';

      // Fazemos a cópia de fato!
      await selectedFile.copy(savedFilePath);

      // 3. Criamos o "objeto" Book com as informações do novo livro.
      final newBook = Book(
        // O ID será o horário exato de agora, garantindo ser único.
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: fileName,
        filePath: savedFilePath,
      );

      // 4. Salvamos o novo livro permanentemente no Hive.
      final box = await Hive.openBox<Book>(_boxName);
      await box.put(newBook.id, newBook); // Usamos o ID como chave (key).

      // 5. Atualizamos a lista local e avisamos a tela para exibir o novo livro!
      _books.add(newBook);
      notifyListeners();

    } catch (e) {
      // Caso ocorra qualquer erro (ex: falta de permissão), mostramos no console.
      debugPrint("Erro ao importar PDF: $e");
    }
  }
}
