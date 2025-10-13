import 'package:flutter/material.dart';
import 'package:letradle/game.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  TextEditingController userName = TextEditingController();
  
  String? _difficulty = "Fácil";

  double _wordSize = 5;
  final double _wordSizeMin = 5;
  final double _wordSizeMax = 10;
  Navigator navigator = Navigator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('LETRADLE')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
          Text(
            'Qual seu nome?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
            ),
          ),
          Padding(
            padding: EdgeInsetsGeometry.only(left: 150, right: 150), 
            child: TextField(
            controller: userName, 
            // onChanged: (context){print(userName.text);},
            ),
          ),
          Text(
            'Dificuldade:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
            ),
          ),
          RadioGroup<String?>(
            groupValue: _difficulty, 
            onChanged: (String? value){setState(() { _difficulty = value;});}, 
            child: const Column(children: [
              ListTile(title: Text("Fácil"), leading: Radio<String?>(value: "Fácil"),),
              ListTile(title: Text("Médio"), leading: Radio<String?>(value: "Médio"),),
              ListTile(title: Text("Difícil"), leading: Radio<String?>(value: "Difícil"),),
              ],),
            ),
          Text(
            'Número de Letras:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
            ),
          ),
          Slider(
            value: _wordSize, 
            onChanged: (value){setState(() {_wordSize = value;});}, 
            min: 5, 
            max: 10, 
            divisions: (_wordSizeMin%_wordSizeMax).toInt(),
            label: _wordSize.toString(),
          ),
          ElevatedButton(onPressed: (){
              int attempts = 15;
              if (_difficulty == "Fácil"){
                attempts = 20;
              }else if(_difficulty == "Médio"){
                attempts = 15;
              }else if(_difficulty == "Difícil"){
                attempts = 6;
              }
              // print("name=${userName.text},  _difficulty=$_difficulty, _wordSize=$_wordSize.");
              Navigator.of(context).push(MaterialPageRoute<void>(builder: (context)=>Game(wordLength: _wordSize.toInt(), attempts: attempts,)));
            }, 
            child: Text(
              'Jogar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
              ),
            )
          ),
    ],)),);
  }
}