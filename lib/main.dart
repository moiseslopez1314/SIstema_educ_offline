import 'package:flutter/material.dart';
import 'screens/menu_screen.dart';
import 'theme/colores.dart';

void main() {
  runApp(const MiniCursosApp());
}

class MiniCursosApp extends StatelessWidget {
  const MiniCursosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Cursos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colores.primario,
        scaffoldBackgroundColor: Colores.fondo,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colores.fondo,
          foregroundColor: Colores.texto,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colores.texto,
          ),
        ),
      ),
     home: const MenuScreen(), 
    );
  }
}