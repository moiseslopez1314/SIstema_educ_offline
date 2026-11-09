
import 'pregunta.dart';

class Leccion {
  final String id;
  final String titulo;
  final String texto;
  final List<Pregunta> preguntas;

  Leccion({
    required this.id,
    required this.titulo,
    required this.texto,
    required this.preguntas,
  });

  factory Leccion.fromJson(Map<String, dynamic> json) => Leccion(
        id: json['id'],
        titulo: json['titulo'],
        texto: json['texto'],
        preguntas: (json['preguntas'] as List)
            .map((p) => Pregunta.fromJson(p))
            .toList(),
      );
}