import 'package:hive/hive.dart';

/// O modelo [Book] representa um único livro (PDF) dentro do nosso aplicativo.
/// Esta classe guarda as informações mais importantes que precisamos lembrar
/// mesmo depois de o usuário fechar o aplicativo.
class Book {
  /// Um identificador único para cada livro. Usaremos o carimbo de data/hora de quando foi adicionado.
  final String id;

  /// O nome que vai aparecer na tela (extraído do nome do arquivo).
  final String title;

  /// O caminho exato de onde o arquivo PDF está guardado na memória do celular.
  final String filePath;

  /// A última página que o usuário leu, para que ele volte exatamente de onde parou.
  /// Começamos sempre da página 1.
  int currentPage;

  Book({
    required this.id,
    required this.title,
    required this.filePath,
    this.currentPage = 1,
  });
}

/// O [BookAdapter] é um "tradutor" para o banco de dados Hive.
/// O Hive não sabe salvar objetos customizados automaticamente.
/// Ele precisa desse tradutor para saber como pegar a classe [Book]
/// e transformar em dados salváveis (write) e como pegar os dados salvos
/// e transformar de volta na classe [Book] (read).
class BookAdapter extends TypeAdapter<Book> {
  // O typeId precisa ser um número único (de 0 a 223). Ele identifica que esse dado é da classe Book.
  @override
  final int typeId = 0;

  @override
  Book read(BinaryReader reader) {
    // Quando lemos os dados, precisamos resgatar na exata mesma ordem que salvamos!
    return Book(
      id: reader.readString(),
      title: reader.readString(),
      filePath: reader.readString(),
      currentPage: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, Book obj) {
    // Escrevemos cada atributo no banco de dados. A ordem importa!
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeString(obj.filePath);
    writer.writeInt(obj.currentPage);
  }
}
