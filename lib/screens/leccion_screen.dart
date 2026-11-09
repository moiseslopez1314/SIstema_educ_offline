import 'package:flutter/material.dart';
import '../models/leccion.dart';
import '../theme/colores.dart';
import 'quiz_screen.dart';

class LeccionScreen extends StatelessWidget {
  final Leccion leccion;
  final int numero;

  const LeccionScreen({super.key, required this.leccion, required this.numero});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(leccion.titulo)),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colores.pista,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Lección $numero',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3730A3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    leccion.titulo,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Colores.texto,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    leccion.texto,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Color(0xFF2E2B5E),
                    ),
                  ),
                ],
              ),
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuizScreen(leccion: leccion),
                    ),
                  );
                },
                child: const Text('Hacer quiz'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}