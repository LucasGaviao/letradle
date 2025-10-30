import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:diacritic/diacritic.dart';
import 'package:http/http.dart' as http;

class Game extends StatefulWidget {
  final int wordLength;
  final int attempts;

  const Game({super.key, required this.wordLength, required this.attempts});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  bool _isLoading = true;
  String _secretWord = '';
  Set<String> _dictionary = {};
  final List<Row> _attempts = [];
  final TextEditingController _attemptControler = TextEditingController();
  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  Future<void> _initializeGame() async {
    // carregando conteudo do arquivo com palavras
    final content = await rootBundle.loadString('assets/lexico.txt');
    final allWords = content
        .split('\n')
        .map((w) => removeDiacritics(w.trim().toUpperCase()))
        .toList();

    // lista de palavras validas para o jogo
    final validWords = allWords
        .where((w) => w.length == widget.wordLength)
        .toList();

    // caso de algo errado
    if (validWords.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      print(
        "Nenhuma palavra encontrada em lexico.txt com o tamanho ${widget.wordLength}",
      );
      return;
    }

    // dicionario das palavras validas
    _dictionary = Set.from(validWords);
    // palavra a ser adivinhada
    _secretWord = validWords[Random().nextInt(validWords.length)];

    // print("_secretWord: $_secretWord");

    setState(() {
      _isLoading = false;
    });
  }

  Future<bool> _checkWordOnline(String word) async {
    try {
      // busca word na "API"
      final response = await http.get(
        Uri.parse(
          'https://api.dicionario-aberto.net/word/${word.toLowerCase()}',
        ),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        // verdade se encontrou algo
        return data.isNotEmpty;
      }
      // não deu bom
      return false;
    } catch (e) {
      print("Erro ao checar palavra online: $e");
      return false;
    }
  }

  Future<void> _submitGuess(String value) async {
    // palavra sem tratamento para realizar busca na API
    String valueDiacritic = value;
    // palavra com tratamento para facilitar operações
    value = removeDiacritics(value.toUpperCase());

    // não é possivel enviar uma palavra de tamanho diferente da predefinida
    if (value.length != widget.wordLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('A palavra deve ter ${widget.wordLength} letras.'),
        ),
      );
      return;
    }

    // esta no dicionario local
    bool isLocallyValid = _dictionary.contains(value);

    if (isLocallyValid) {
      _processValidGuess(value);
    } else {
      // caso n exista no meu dicionario da decada de 80 kk
      _showLoadingDialog("Verificando palavra online...");
      bool isOnlineValid = await _checkWordOnline(valueDiacritic);
      Navigator.of(context).pop();

      if (isOnlineValid) {
        // se é valido online traz para o local pra facilitar
        setState(() {
          _dictionary.add(value);
        });
        _processValidGuess(value);
      } else {
        // acho q n existe ent né
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Palavra não encontrada no dicionário.'),
          ),
        );
      }
    }
  }

  void _processValidGuess(String value) {
    setState(() {
      final List<Widget> letters = [];
      for (int i = 0; i < value.length; i++) {
        Color bgColor = Colors.grey.shade800;
        final char = value[i];
        if (_secretWord.contains(char)) {
          bgColor = Colors.amber.shade700;
        }
        if (_secretWord[i] == char) {
          bgColor = Colors.green.shade700;
        }
        // cada quadrado com letra sera adicionado nesta lista

        double? _fontSize = 25.0 - widget.wordLength;
        letters.add(
          Padding(
            padding: const EdgeInsets.all(3),
            child: Container(
              width: 60 - 3.1 * widget.wordLength,
              height: 60 - 2.2 * widget.wordLength,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(
                  3 + (widget.wordLength % 5),
                ),
              ),
              child: Text(
                value[i],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: _fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }
      // composição das letras que formam uma palavra/tentativa
      _attempts.add(
        Row(mainAxisAlignment: MainAxisAlignment.center, children: letters),
      );
      _attemptControler.clear();

      if (value == _secretWord) {
        _showEndGameDialog("Você Venceu!", "A palavra era: $_secretWord");
      } else if (_attempts.length >= widget.attempts) {
        _showEndGameDialog("Você Perdeu!", "A palavra era: $_secretWord");
      }
    });
  }

  void _showLoadingDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 24),
              Text(message),
            ],
          ),
        );
      },
    );
  }

  void _showEndGameDialog(String title, String content) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('Jogar Novamente'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("LETRADLE")),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Carregando dicionário..."),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("LETRADLE")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _attempts.length,
                itemBuilder: (context, index) {
                  return _attempts[index];
                },
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _attemptControler,
              decoration: const InputDecoration(
                labelText: 'Sua tentativa',
                border: OutlineInputBorder(),
              ),
              maxLength: widget.wordLength,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, letterSpacing: 4),
              onSubmitted: _submitGuess,
            ),
          ],
        ),
      ),
    );
  }
}
