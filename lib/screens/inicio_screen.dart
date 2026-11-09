import 'package:flutter/material.dart';
import '../models/curso.dart';
import '../services/contenido_service.dart';
import '../services/progreso_service.dart';
import '../theme/colores.dart';
import '../widgets/barra_progreso.dart';
import 'curso_screen.dart';

class _Datos {
  final List<Curso> cursos;
  final Map<String, int> puntajes;
  _Datos(this.cursos, this.puntajes);
}

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  late Future<_Datos> _datos;

  @override
  void initState() {
    super.initState();
    _datos = _cargar();
  }

  Future<_Datos> _cargar() async {
    final cursos = await ContenidoService().cargarCursos();
    final puntajes = await ProgresoService().obtenerPuntajes();
    return _Datos(cursos, puntajes);
  }

  Future<void> _abrirCurso(Curso curso, Color color) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CursoScreen(curso: curso, color: color),
      ),
    );
    if (!mounted) return;
    setState(() {
      _datos = _cargar();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<_Datos>(
          future: _datos,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final datos = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: datos.cursos.length + 1,
              itemBuilder: (context, i) {
                if (i == 0) {
                  return const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bienvenido',
                          style: TextStyle(
                              fontSize: 14, color: Colores.textoSuave),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Mis cursos',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colores.texto,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                final curso = datos.cursos[i - 1];
                final color = Colores.curso(i - 1);
                final hechas = curso.lecciones
                    .where((l) => datos.puntajes.containsKey(l.id))
                    .length;
                final progreso = curso.lecciones.isEmpty
                    ? 0.0
                    : hechas / curso.lecciones.length;
                return _TarjetaCurso(
                  curso: curso,
                  color: color,
                  progreso: progreso,
                  onTap: () => _abrirCurso(curso, color),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _TarjetaCurso extends StatelessWidget {
  final Curso curso;
  final Color color;
  final double progreso;
  final VoidCallback onTap;

  const _TarjetaCurso({
    required this.curso,
    required this.color,
    required this.progreso,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radio = BorderRadius.circular(20);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.white,
        elevation: 2,
        shadowColor: const Color(0x334F46E5),
        borderRadius: radio,
        child: InkWell(
          borderRadius: radio,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.menu_book_rounded,
                          color: Colors.white),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            curso.titulo,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colores.texto,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            curso.descripcion,
                            style: const TextStyle(
                                fontSize: 13, color: Colores.textoSuave),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${curso.lecciones.length} lecciones',
                      style: const TextStyle(
                          fontSize: 13, color: Colores.textoSuave),
                    ),
                    Text(
                      '${(progreso * 100).round()}%',
                      style: const TextStyle(
                          fontSize: 13, color: Colores.textoSuave),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                BarraProgreso(valor: progreso, color: color),
              ],
            ),
          ),
        ),
      ),
    );
  }
}