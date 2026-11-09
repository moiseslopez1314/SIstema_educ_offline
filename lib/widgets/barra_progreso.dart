import 'package:flutter/material.dart';
import '../theme/colores.dart';

class BarraProgreso extends StatelessWidget {
  final double valor;
  final Color color;
  final Color fondo;

  const BarraProgreso({
    super.key,
    required this.valor,
    required this.color,
    this.fondo = Colores.pista,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: valor,
        minHeight: 8,
        color: color,
        backgroundColor: fondo,
      ),
    );
  }
}