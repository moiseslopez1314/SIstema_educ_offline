import '../models/curso.dart';
import 'contenido_service.dart';
import 'progreso_service.dart';

class Resumen {
  final List<Curso> cursos;
  final Map<String, int> puntajes;
  final int lecciones;
  final int hechas;
  final int perfectas;
  final int cursosCompletos;
  final int promedio;

  Resumen({
    required this.cursos,
    required this.puntajes,
    required this.lecciones,
    required this.hechas,
    required this.perfectas,
    required this.cursosCompletos,
    required this.promedio,
  });

  double get avance => lecciones == 0 ? 0.0 : hechas / lecciones;

  String get nivel =>
      hechas >= 7 ? 'Avanzado' : (hechas >= 3 ? 'Intermedio' : 'Principiante');

  int hechasDe(Curso c) =>
      c.lecciones.where((l) => puntajes.containsKey(l.id)).length;
}

class EstadisticasService {
  Future<Resumen> cargar() async {
    final cursos = await ContenidoService().cargarCursos();
    final puntajes = await ProgresoService().obtenerPuntajes();

    int total = 0;
    int hechas = 0;
    int perfectas = 0;
    int completos = 0;
    double suma = 0;

    for (final c in cursos) {
      int hechasCurso = 0;
      for (final l in c.lecciones) {
        total++;
        final p = puntajes[l.id];
        if (p != null) {
          hechas++;
          hechasCurso++;
          if (l.preguntas.isNotEmpty) {
            suma += p / l.preguntas.length;
            if (p >= l.preguntas.length) perfectas++;
          }
        }
      }
      if (c.lecciones.isNotEmpty && hechasCurso == c.lecciones.length) {
        completos++;
      }
    }

    final promedio = hechas == 0 ? 0 : (suma / hechas * 100).round();

    return Resumen(
      cursos: cursos,
      puntajes: puntajes,
      lecciones: total,
      hechas: hechas,
      perfectas: perfectas,
      cursosCompletos: completos,
      promedio: promedio,
    );
  }
}