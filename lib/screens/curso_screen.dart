import 'package:flutter/material.dart';
import '../models/curso.dart';
import '../services/progreso_service.dart';
import '../theme/colores.dart';
import '../widgets/barra_progreso.dart';
import 'leccion_screen.dart';

class CursoScreen extends StatefulWidget {
  final Curso curso;
  final Color color;

  const CursoScreen({super.key, required this.curso, required this.color});

  @override
  State<CursoScreen> createState() => _CursoScreenState();
}

class _CursoScreenState extends State<CursoScreen> {
  late Future<Map<String, int>> _puntajes;

  @override
  void initState() {
    super.initState();
    _puntajes = ProgresoService().obtenerPuntajes();
  }

  Future<void> _abrirLeccion(int indice) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LeccionScreen(
          leccion: widget.curso.lecciones[indice],
          numero: indice + 1,
        ),
      ),
    );
    if (!mounted) return;
    setState(() {
      _puntajes = ProgresoService().obtenerPuntajes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final curso = widget.curso;
    return Scaffold(
      appBar: AppBar(title: Text(curso.titulo)),
      body: FutureBuilder<Map<String, int>>(
        future: _puntajes,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final puntajes = snapshot.data!;
          final hechas =
              curso.lecciones.where((l) => puntajes.containsKey(l.id)).length;
          final total = curso.lecciones.length;
          final progreso = total == 0 ? 0.0 : hechas / total;

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tu progreso',
                        style: TextStyle(fontSize: 14, color: Colors.white)),
                    const SizedBox(height: 4),
                    Text(
                      '$hechas de $total lecciones',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    BarraProgreso(
                      valor: progreso,
                      color: Colors.white,
                      fondo: const Color(0x4DFFFFFF),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              for (int i = 0; i < total; i++)
                _TarjetaLeccion(
                  numero: i + 1,
                  titulo: curso.lecciones[i].titulo,
                  totalPreguntas: curso.lecciones[i].preguntas.length,
                  puntaje: puntajes[curso.lecciones[i].id],
                  onTap: () => _abrirLeccion(i),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _TarjetaLeccion extends StatelessWidget {
  final int numero;
  final String titulo;
  final int totalPreguntas;
  final int? puntaje;
  final VoidCallback onTap;

  const _TarjetaLeccion({
    required this.numero,
    required this.titulo,
    required this.totalPreguntas,
    required this.puntaje,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final completada = puntaje != null;
    final radio = BorderRadius.circular(16);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        elevation: 1,
        shadowColor: const Color(0x334F46E5),
        borderRadius: radio,
        child: InkWell(
          borderRadius: radio,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor:
                      completada ? Colores.acierto : Colores.pista,
                  child: completada
                      ? const Icon(Icons.check_rounded, color: Colors.white)
                      : Text(
                          '$numero',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF3730A3),
                          ),
                        ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colores.texto,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        completada
                            ? '$totalPreguntas preguntas · Mejor puntaje $puntaje/$totalPreguntas'
                            : '$totalPreguntas preguntas · Sin intentar',
                        style: const TextStyle(
                            fontSize: 13, color: Colores.textoSuave),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colores.textoSuave),
              ],
            ),
          ),
        ),
      ),
    );
  }
}