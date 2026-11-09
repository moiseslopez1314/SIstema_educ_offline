import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/curso.dart';

class ContenidoService {
  Future<List<Curso>> cargarCursos() async {
    final texto = await rootBundle.loadString('assets/contenido.json');
    final data = jsonDecode(texto);
    return (data['cursos'] as List).map((c) => Curso.fromJson(c)).toList();
  }
}