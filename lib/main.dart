import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// O método [main] é o ponto de partida (a porta de entrada) de qualquer aplicativo Flutter.
/// Tudo começa por aqui!
void main() async {
  // 1. Antes de iniciar qualquer configuração que dependa do Flutter ou de bibliotecas nativas,
  // precisamos garantir que a "ponte" entre o código Flutter e o sistema nativo esteja pronta.
  // Fazemos isso chamando a linha abaixo:
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicializamos o banco de dados local chamado Hive.
  // O Hive é ótimo para armazenar dados pequenos e configurações de forma muito rápida.
  // A versão `hive_flutter` já traz um método preparado para iniciar tudo facilmente no Flutter.
  await Hive.initFlutter();

  // 3. Depois de tudo configurado, chamamos o método [runApp] para finalmente desenhar o app na tela.
  // Passamos o nosso widget principal, o [PdfReaderApp].
  runApp(const PdfReaderApp());
}

/// O [PdfReaderApp] é o "esqueleto" principal do nosso aplicativo.
/// Ele herda de [StatelessWidget] porque as configurações básicas (como tema e rotas) não mudam
/// ativamente com interações do usuário nesta camada.
class PdfReaderApp extends StatelessWidget {
  const PdfReaderApp({super.key});

  // O método [build] é responsável por "desenhar" a interface na tela.
  @override
  Widget build(BuildContext context) {
    // Retornamos um [MaterialApp], que é um widget que já traz muitas configurações prontas
    // baseadas no Material Design (o estilo visual padrão do Google).
    return MaterialApp(
      // Título do nosso app. Em algumas plataformas ele aparece ao minimizar.
      title: 'PDF Reader',

      // Aqui podemos remover aquela faixinha de 'DEBUG' que aparece no canto superior direito.
      debugShowCheckedModeBanner: false,

      // O [theme] define as cores principais e estilos padrão. Vamos deixar o padrão no momento.
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      // O [home] é a tela inicial que será mostrada quando o app abrir.
      // Por enquanto, usaremos uma tela provisória (um esqueleto temporário).
      home: const InitialScreen(),
    );
  }
}

/// Esta é a nossa tela inicial temporária.
/// Usamos para garantir que a base do projeto está funcionando perfeitamente!
class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // O [Scaffold] é como se fosse a tela em branco padrão de uma página do app.
    // Ele já prepara a estrutura para termos barra no topo, corpo da página, etc.
    return Scaffold(
      // [backgroundColor] define a cor de fundo da nossa tela. Vamos usar branco,
      // garantindo um visual limpo e focando no conforto visual depois.
      backgroundColor: Colors.white,

      // [body] é o recheio da tela.
      // Aqui usamos o [Center] para que tudo que estiver dentro dele fique bem no meio da tela.
      body: Center(
        // O [Text] é responsável por mostrar uma frase escrita.
        child: const Text(
          'Base do App Configurada',
          // [style] nos permite mudar o visual do texto (tamanho, cor, negrito, etc).
          style: TextStyle(
            fontSize: 24, // Tamanho da fonte
            color: Colors.black, // Cor da fonte
            fontWeight: FontWeight.bold, // Deixa o texto mais "gordinho" (negrito)
          ),
        ),
      ),
    );
  }
}
