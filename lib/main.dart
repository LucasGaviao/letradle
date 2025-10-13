import 'package:flutter/material.dart';
import 'package:letradle/home.dart';

void main() {
  runApp(MaterialApp(title: 'LETRADLE',
    home: Home(),
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 255, 255), brightness: Brightness.dark)
    ),
    
    )
  
  );
}
