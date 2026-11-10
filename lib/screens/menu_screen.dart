import 'package:flutter/material.dart';
import '../theme/colores.dart';
import 'inicio_screen.dart';
import 'tarjetas_screen.dart';
import 'diccionario_screen.dart';
import 'estadisticas_screen.dart';
import 'logros_screen.dart';
import 'perfil_screen.dart';

class _OpcionMenu {
  final String titulo;
  final IconData icono;
  final Color color;
  final Widget? destino;

  _OpcionMenu(this.titulo, this.icono, this.color, this.destino);
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
       final opciones = <_OpcionMenu>[
      _OpcionMenu('Mis cursos', Icons.menu_book_rounded, Colores.curso(0),
          const InicioScreen()),
      _OpcionMenu('Tarjetas de estudio', Icons.style_rounded,
          Colores.curso(1), const TarjetasScreen()),
      _OpcionMenu('Diccionario', Icons.spellcheck_rounded, Colores.curso(2),
          const DiccionarioScreen()),
      _OpcionMenu('Estadísticas', Icons.bar_chart_rounded, Colores.curso(0),
          const EstadisticasScreen()),
      _OpcionMenu('Mis logros', Icons.emoji_events_rounded, Colores.curso(1),
          const LogrosScreen()),
      _OpcionMenu('Mi perfil', Icons.person_rounded, Colores.curso(2),
          const PerfilScreen()),
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sistema Educativo',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colores.texto,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Aprende desde cualquier lugar, sin Internet.',
                style: TextStyle(fontSize: 14, color: Colores.textoSuave),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.05,
                  children: [
                    for (final o in opciones) _TarjetaMenu(opcion: o),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TarjetaMenu extends StatelessWidget {
  final _OpcionMenu opcion;

  const _TarjetaMenu({required this.opcion});

  @override
  Widget build(BuildContext context) {
    final radio = BorderRadius.circular(20);
    return Material(
      color: Colors.white,
      elevation: 2,
      shadowColor: const Color(0x334F46E5),
      borderRadius: radio,
      child: InkWell(
        borderRadius: radio,
        onTap: () {
          if (opcion.destino == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${opcion.titulo}: próximamente')),
            );
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => opcion.destino!),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: opcion.color,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(opcion.icono, color: Colors.white),
              ),
              const SizedBox(height: 12),
              Text(
                opcion.titulo,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colores.texto,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}