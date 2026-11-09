import 'package:flutter/material.dart';
import '../models/leccion.dart';
import '../services/progreso_service.dart';
import '../theme/colores.dart';
import '../widgets/barra_progreso.dart';
import 'resultado_screen.dart';

class QuizScreen extends StatefulWidget {
  final Leccion leccion;

  const QuizScreen({super.key, required this.leccion});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _actual = 0;
  int _aciertos = 0;
  int? _elegida;

  void _elegir(int i) {
    if (_elegida != null) return;
    final pregunta = widget.leccion.preguntas[_actual];
    setState(() {
      _elegida = i;
      if (i == pregunta.correcta) _aciertos++;
    });
  }

  Future<void> _siguiente() async {
    final total = widget.leccion.preguntas.length;
    if (_actual < total - 1) {
      setState(() {
        _actual++;
        _elegida = null;
      });
      return;
    }
    await ProgresoService().guardarPuntaje(widget.leccion.id, _aciertos);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultadoScreen(
          leccion: widget.leccion,
          aciertos: _aciertos,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final preguntas = widget.leccion.preguntas;
    final pregunta = preguntas[_actual];
    final esUltima = _actual == preguntas.length - 1;

    return Scaffold(
      appBar: AppBar(title: Text('Quiz · ${widget.leccion.titulo}')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  'Pregunta ${_actual + 1} de ${preguntas.length}',
                  style: const TextStyle(
                      fontSize: 13, color: Colores.textoSuave),
                ),
                const SizedBox(height: 8),
                BarraProgreso(
                  valor: (_actual + 1) / preguntas.length,
                  color: Colores.primario,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1A4F46E5),
                        blurRadius: 16,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    pregunta.enunciado,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                      color: Colores.texto,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                for (int i = 0; i < pregunta.opciones.length; i++)
                  _Opcion(
                    texto: pregunta.opciones[i],
                    estado: _estadoOpcion(i, pregunta.correcta),
                    onTap: () => _elegir(i),
                  ),
                if (_elegida != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Respuesta correcta: ${pregunta.opciones[pregunta.correcta]}',
                      style: const TextStyle(
                          fontSize: 14, color: Colores.textoSuave),
                    ),
                  ),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                onPressed: _elegida == null ? null : _siguiente,
                child: Text(esUltima ? 'Ver resultado' : 'Siguiente'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _EstadoOpcion _estadoOpcion(int i, int correcta) {
    if (_elegida == null) return _EstadoOpcion.neutra;
    if (i == correcta) return _EstadoOpcion.correcta;
    if (i == _elegida) return _EstadoOpcion.incorrecta;
    return _EstadoOpcion.neutra;
  }
}

enum _EstadoOpcion { neutra, correcta, incorrecta }

class _Opcion extends StatelessWidget {
  final String texto;
  final _EstadoOpcion estado;
  final VoidCallback onTap;

  const _Opcion({
    required this.texto,
    required this.estado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color fondo = Colors.white;
    Color borde = const Color(0xFFD9D7F5);
    Color letra = Colores.texto;
    Widget? icono;

    if (estado == _EstadoOpcion.correcta) {
      fondo = Colores.aciertoFondo;
      borde = Colores.acierto;
      letra = const Color(0xFF14532D);
      icono = const Icon(Icons.check_rounded, color: Colores.acierto);
    } else if (estado == _EstadoOpcion.incorrecta) {
      fondo = Colores.errorFondo;
      borde = Colores.error;
      letra = const Color(0xFF7F1D1D);
      icono = const Icon(Icons.close_rounded, color: Colores.error);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: fondo,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borde, width: 2),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  texto,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: letra,
                  ),
                ),
              ),
              if (icono != null) icono,
            ],
          ),
        ),
      ),
    );
  }
}