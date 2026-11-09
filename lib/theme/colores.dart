import 'package:flutter/material.dart';

class Colores {
  static const primario = Color(0xFF4F46E5);
  static const fondo = Color(0xFFF7F6FF);
  static const texto = Color(0xFF1E1B4B);
  static const textoSuave = Color(0xFF5B5A7A);
  static const pista = Color(0xFFE4E2FF);
  static const acierto = Color(0xFF15803D);
  static const aciertoFondo = Color(0xFFDCFCE7);
  static const error = Color(0xFFB91C1C);
  static const errorFondo = Color(0xFFFEE2E2);

  static const _cursos = [
    Color(0xFF4F46E5),
    Color(0xFF0F766E),
    Color(0xFFB45309),
  ];

  static Color curso(int i) => _cursos[i % _cursos.length];
}