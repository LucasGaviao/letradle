import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:diacritic/diacritic.dart';

class Game extends StatefulWidget {
  final int wordLength;
  final int attempts;

  const Game({
    super.key,
    required this.wordLength,
    required this.attempts,
  });

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
    // Inicia o carregamento do dicionário e a configuração do jogo
    _initializeGame();
  }

  Future<void> _initializeGame() async {
    final content = await rootBundle.loadString('assets/lexico.txt');
    final allWords = content.split('\n').map((w) => removeDiacritics(w.trim().toUpperCase())).toList();
    final validWords = allWords.where((w) => w.length == widget.wordLength).toList();
    
    _dictionary = Set.from(validWords);

    _secretWord = validWords[Random().nextInt(validWords.length)];
    // print("Palavra secreta: $_secretWord");

    setState(() {
      _isLoading = false;
    });
  }

  void _submitGuess(String value) {
    value = removeDiacritics(value.toUpperCase());

    if (value.length != widget.wordLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('A palavra deve ter ${widget.wordLength} letras.')),
      );
      return;
    }

    if (!_dictionary.contains(value)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Palavra não encontrada no dicionário.'),),
      );
      return;
    }
    
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

        letters.add(
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Text(
              ' ${value[i]}',
              style: TextStyle(
                color: Colors.white,
                backgroundColor: bgColor,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
      _attempts.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: letters,
        ),
      );
      _attemptControler.clear();

      if (value == _secretWord) {
        _showEndGameDialog("Você Venceu!", "A palavra era: $_secretWord");
      } else if (_attempts.length >= widget.attempts) {
        _showEndGameDialog("Você Perdeu!", "A palavra era: $_secretWord");
      }
    });
  }

  void _showEndGameDialog(String title, String content) {
    showDialog(
      context: context,
      barrierDismissible: false, // Impede o usuário de fechar clicando fora
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('Jogar Novamente'),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
                Navigator.of(context).pop(); // Volta para a tela inicial
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

    // --- TELA PRINCIPAL DO JOGO ---
    return Scaffold(
      appBar: AppBar(
        title: const Text("LETRADLE"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: _attempts,
              ),
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
      ),
    );
  }
}