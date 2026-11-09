class Pregunta {
  final String enunciado;
  final List<String> opciones;
  final int correcta;

  Pregunta({
    required this.enunciado,
    required this.opciones,
    required this.correcta,
  });

  factory Pregunta.fromJson(Map<String, dynamic> json) => Pregunta(
        enunciado: json['enunciado'],
        opciones: List<String>.from(json['opciones']),
        correcta: json['correcta'],
      );
}