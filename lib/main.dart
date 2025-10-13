import 'package:flutter/material.dart';
import 'package:letradle/home.dart';
import 'package:diacritic/diacritic.dart';

void main() {
  print("${removeDiacritics("Fácil, gg, mão, água, cachaça, experência!")}");
  runApp(MaterialApp(title: 'LETRADLE',
    home: Home(),
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 255, 255), brightness: Brightness.dark)
    ),
    
    )
  
  );
}
