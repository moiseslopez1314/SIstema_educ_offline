import 'leccion.dart';

class Curso {
  final String id;
  final String titulo;
  final String descripcion;
  final List<Leccion> lecciones;

  Curso({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.lecciones,
  });

  factory Curso.fromJson(Map<String, dynamic> json) => Curso(
        id: json['id'],
        titulo: json['titulo'],
        descripcion: json['descripcion'],
        lecciones: (json['lecciones'] as List)
            .map((l) => Leccion.fromJson(l))
            .toList(),
      );
}