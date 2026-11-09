import 'package:flutter/material.dart';
import '../models/leccion.dart';
import '../theme/colores.dart';
import 'quiz_screen.dart';

class ResultadoScreen extends StatelessWidget {
  final Leccion leccion;
  final int aciertos;

  const ResultadoScreen({
    super.key,
    required this.leccion,
    required this.aciertos,
  });

  @override
  Widget build(BuildContext context) {
    final total = leccion.preguntas.length;
    final valor = total == 0 ? 0.0 : aciertos / total;
    final mensaje = valor >= 1
        ? '¡Excelente!'
        : valor >= 0.5
            ? '¡Buen trabajo!'
            : 'Sigue practicando';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 180,
                      height: 180,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CircularProgressIndicator(
                            value: valor,
                            strokeWidth: 14,
                            color: Colores.primario,
                            backgroundColor: Colores.pista,
                          ),
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '$aciertos/$total',
                                  style: const TextStyle(
                                    fontSize: 44,
                                    fontWeight: FontWeight.w700,
                                    color: Colores.texto,
                                  ),
                                ),
                                const Text(
                                  'aciertos',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colores.textoSuave),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      mensaje,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colores.texto,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Lección: ${leccion.titulo}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 15, color: Colores.textoSuave),
                    ),
                  ],
                ),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  int n = 0;
                  Navigator.popUntil(context, (_) => n++ >= 2);
                },
                child: const Text('Volver al curso'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  side: const BorderSide(color: Colores.primario, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuizScreen(leccion: leccion),
                    ),
                  );
                },
                child: const Text('Reintentar quiz'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}