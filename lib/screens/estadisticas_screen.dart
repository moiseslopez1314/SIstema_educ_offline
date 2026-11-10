import 'package:flutter/material.dart';
import '../services/estadisticas_service.dart';
import '../theme/colores.dart';
import '../widgets/barra_progreso.dart';

class EstadisticasScreen extends StatefulWidget {
  const EstadisticasScreen({super.key});

  @override
  State<EstadisticasScreen> createState() => _EstadisticasScreenState();
}

class _EstadisticasScreenState extends State<EstadisticasScreen> {
  late Future<Resumen> _resumen;

  @override
  void initState() {
    super.initState();
    _resumen = EstadisticasService().cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estadísticas')),
      body: FutureBuilder<Resumen>(
        future: _resumen,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final r = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Row(
                children: [
                  Expanded(
                      child: _Dato(
                          valor: '${r.hechas}/${r.lecciones}',
                          etiqueta: 'Lecciones')),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _Dato(
                          valor: '${(r.avance * 100).round()}%',
                          etiqueta: 'Avance')),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _Dato(
                          valor: '${r.promedio}%', etiqueta: 'Aciertos')),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Aciertos: promedio de respuestas correctas en tus quizzes.',
                style: TextStyle(fontSize: 12, color: Colores.textoSuave),
              ),
              const SizedBox(height: 24),
              Text(
                'Cursos pendientes: ${r.cursos.length - r.cursosCompletos}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colores.texto,
                ),
              ),
              const SizedBox(height: 12),
              for (int i = 0; i < r.cursos.length; i++)
                _FilaCurso(
                  titulo: r.cursos[i].titulo,
                  hechas: r.hechasDe(r.cursos[i]),
                  total: r.cursos[i].lecciones.length,
                  color: Colores.curso(i),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _Dato extends StatelessWidget {
  final String valor;
  final String etiqueta;

  const _Dato({required this.valor, required this.etiqueta});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
              color: Color(0x1A4F46E5), blurRadius: 12, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          Text(
            valor,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colores.primario,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            etiqueta,
            style: const TextStyle(fontSize: 12, color: Colores.textoSuave),
          ),
        ],
      ),
    );
  }
}

class _FilaCurso extends StatelessWidget {
  final String titulo;
  final int hechas;
  final int total;
  final Color color;

  const _FilaCurso({
    required this.titulo,
    required this.hechas,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colores.texto,
                  ),
                ),
              ),
              Text(
                '$hechas/$total',
                style: const TextStyle(
                    fontSize: 13, color: Colores.textoSuave),
              ),
            ],
          ),
          const SizedBox(height: 10),
          BarraProgreso(
            valor: total == 0 ? 0.0 : hechas / total,
            color: color,
          ),
        ],
      ),
    );
  }
}