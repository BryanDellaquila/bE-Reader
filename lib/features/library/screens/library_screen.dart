import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf_reader/features/library/providers/library_provider.dart';
import 'package:pdf_reader/features/library/models/book.dart';

/// Esta é a tela principal do nosso aplicativo: a Estante (Library).
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold nos dá a estrutura básica de tela (Appbar, body e botões flutuantes).
    return Scaffold(
      backgroundColor: Colors.grey[50], // Uma cor de fundo bem suave para descanso visual.

      // A barra no topo da tela.
      appBar: AppBar(
        title: const Text('Minha Biblioteca', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5, // Adiciona uma pequena sombra sutil.
      ),

      // Aqui usamos o Consumer. Ele "escuta" as mudanças do nosso LibraryProvider.
      // Toda vez que a lista de livros for atualizada (notifyListeners for chamado),
      // este Consumer redesenhará apenas esta parte da tela automaticamente!
      body: Consumer<LibraryProvider>(
        builder: (context, libraryProvider, child) {
          final books = libraryProvider.books;

          // Se a lista estiver vazia, mostramos nosso "Empty State" (Mensagem amigável).
          if (books.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.book, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Sua estante está vazia.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Toque no + para adicionar um PDF.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Se tiver livros, mostramos a GridView.
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            // Quantidade de colunas e espaçamento
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 livros por linha
              childAspectRatio: 0.75, // Altura um pouco maior que a largura
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: books.length, // Total de itens
            itemBuilder: (context, index) {
              final book = books[index];
              return _BookCard(book: book); // Nosso widget customizado desenhado abaixo!
            },
          );
        },
      ),

      // Botão flutuante no canto inferior direito para adicionar novos PDFs.
      floatingActionButton: FloatingActionButton(
        // Quando o usuário tocar, chamamos o método do nosso Provider!
        // Como estamos num callback, precisamos passar o listen: false.
        onPressed: () {
          Provider.of<LibraryProvider>(context, listen: false).pickAndImportPdf();
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(CupertinoIcons.add, color: Colors.white),
      ),
    );
  }
}

/// Widget privado ([_]) que desenha o visual de cada livro na estante (MVP).
class _BookCard extends StatelessWidget {
  final Book book;

  const _BookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    // Um Card dá o formato de cartãozinho, com cantos arredondados e sombreado.
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias, // Garante que o conteúdo não vaze as bordas arredondadas.
      child: InkWell(
        // O InkWell nos dá o efeito de "onda" ao tocar, e permite o [onTap].
        onTap: () {
          // No futuro, aqui iremos para a tela de leitura de fato (ReaderScreen).
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Abrir: ${book.title}')),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Área da capa provisória (um ícone grande ocupando maior parte do card).
            Expanded(
              child: Container(
                color: Colors.blue.withAlpha(25), // Um tom azul muito clarinho
                child: const Icon(
                  CupertinoIcons.book_solid,
                  size: 48,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            // Área do título (parte inferior).
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                book.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 2, // Se o nome for muito grande, quebra no máximo 2 linhas.
                overflow: TextOverflow.ellipsis, // Se passar de 2 linhas, põe "...".
              ),
            ),
          ],
        ),
      ),
    );
  }
}
