class Termino {
  final String termino;
  final String definicion;
  final String ejemplo;

  Termino({
    required this.termino,
    required this.definicion,
    required this.ejemplo,
  });

  factory Termino.fromJson(Map<String, dynamic> json) => Termino(
        termino: json['termino'],
        definicion: json['definicion'],
        ejemplo: json['ejemplo'],
      );
}