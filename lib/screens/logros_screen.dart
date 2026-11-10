import 'package:flutter/material.dart';
import '../services/estadisticas_service.dart';
import '../theme/colores.dart';

class _Logro {
  final String titulo;
  final String descripcion;
  final IconData icono;
  final bool Function(Resumen) cumple;

  _Logro(this.titulo, this.descripcion, this.icono, this.cumple);
}

final List<_Logro> _logros = [
  _Logro('Primer paso', 'Completa tu primera lección', Icons.flag_rounded,
      (r) => r.hechas >= 1),
  _Logro('Constante', 'Completa 5 lecciones',
      Icons.local_fire_department_rounded, (r) => r.hechas >= 5),
  _Logro('Puntaje perfecto', 'Acierta todo en un quiz', Icons.star_rounded,
      (r) => r.perfectas >= 1),
  _Logro('Experto', 'Logra 5 quizzes perfectos',
      Icons.workspace_premium_rounded, (r) => r.perfectas >= 5),
  _Logro('Curso completo', 'Termina un curso entero', Icons.school_rounded,
      (r) => r.cursosCompletos >= 1),
  _Logro('Graduado', 'Termina todos los cursos', Icons.emoji_events_rounded,
      (r) => r.lecciones > 0 && r.hechas == r.lecciones),
];

class LogrosScreen extends StatefulWidget {
  const LogrosScreen({super.key});

  @override
  State<LogrosScreen> createState() => _LogrosScreenState();
}

class _LogrosScreenState extends State<LogrosScreen> {
  late Future<Resumen> _resumen;

  @override
  void initState() {
    super.initState();
    _resumen = EstadisticasService().cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis logros')),
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
          final obtenidos = _logros.where((l) => l.cumple(r)).length;
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$obtenidos de ${_logros.length} logros',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colores.texto,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.85,
                    children: [
                      for (int i = 0; i < _logros.length; i++)
                        _TarjetaLogro(
                          logro: _logros[i],
                          logrado: _logros[i].cumple(r),
                          color: Colores.curso(i),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TarjetaLogro extends StatelessWidget {
  final _Logro logro;
  final bool logrado;
  final Color color;

  const _TarjetaLogro({
    required this.logro,
    required this.logrado,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: logrado ? color : Colores.pista,
            child: Icon(
              logrado ? logro.icono : Icons.lock_rounded,
              color: logrado ? Colors.white : Colores.textoSuave,
              size: 28,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            logro.titulo,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colores.texto,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            logro.descripcion,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colores.textoSuave),
          ),
          const SizedBox(height: 8),
          Text(
            logrado ? 'Logrado' : 'Bloqueado',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: logrado ? Colores.acierto : Colores.textoSuave,
            ),
          ),
        ],
      ),
    );
  }
}