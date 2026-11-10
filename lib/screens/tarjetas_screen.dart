import 'package:flutter/material.dart';
import '../models/pregunta.dart';
import '../services/contenido_service.dart';
import '../theme/colores.dart';

class _Item {
  final String tema;
  final Pregunta pregunta;
  _Item(this.tema, this.pregunta);
}

class TarjetasScreen extends StatefulWidget {
  const TarjetasScreen({super.key});

  @override
  State<TarjetasScreen> createState() => _TarjetasScreenState();
}

class _TarjetasScreenState extends State<TarjetasScreen> {
  late Future<List<_Item>> _items;
  int _pagina = 0;

  @override
  void initState() {
    super.initState();
    _items = _cargar();
  }

  Future<List<_Item>> _cargar() async {
    final cursos = await ContenidoService().cargarCursos();
    final items = <_Item>[];
    for (final c in cursos) {
      for (final l in c.lecciones) {
        for (final p in l.preguntas) {
          items.add(_Item(l.titulo, p));
        }
      }
    }
    items.shuffle();
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tarjetas de estudio')),
      body: FutureBuilder<List<_Item>>(
        future: _items,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data!;
          if (items.isEmpty) {
            return const Center(child: Text('No hay tarjetas'));
          }
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  '${_pagina + 1} / ${items.length}',
                  style: const TextStyle(
                      fontSize: 14, color: Colores.textoSuave),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: PageView.builder(
                    itemCount: items.length,
                    onPageChanged: (i) => setState(() => _pagina = i),
                    itemBuilder: (context, i) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: _TarjetaVolteable(
                        key: ValueKey(i),
                        item: items[i],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Toca la tarjeta para ver la respuesta.\nDesliza para pasar a la siguiente.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colores.textoSuave),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TarjetaVolteable extends StatefulWidget {
  final _Item item;

  const _TarjetaVolteable({super.key, required this.item});

  @override
  State<_TarjetaVolteable> createState() => _TarjetaVolteableState();
}

class _TarjetaVolteableState extends State<_TarjetaVolteable> {
  bool _atras = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.item.pregunta;
    return GestureDetector(
      onTap: () => setState(() => _atras = !_atras),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _atras
            ? _Cara(
                key: const ValueKey('atras'),
                etiqueta: 'Respuesta',
                texto: p.opciones[p.correcta],
                fondo: Colores.primario,
                colorTexto: Colors.white,
                colorEtiqueta: Colores.pista,
              )
            : _Cara(
                key: const ValueKey('frente'),
                etiqueta: widget.item.tema,
                texto: p.enunciado,
                fondo: Colors.white,
                colorTexto: Colores.texto,
                colorEtiqueta: Colores.textoSuave,
              ),
      ),
    );
  }
}

class _Cara extends StatelessWidget {
  final String etiqueta;
  final String texto;
  final Color fondo;
  final Color colorTexto;
  final Color colorEtiqueta;

  const _Cara({
    super.key,
    required this.etiqueta,
    required this.texto,
    required this.fondo,
    required this.colorTexto,
    required this.colorEtiqueta,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
              color: Color(0x264F46E5), blurRadius: 20, offset: Offset(0, 6)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            etiqueta,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colorEtiqueta,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            texto,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              height: 1.4,
              color: colorTexto,
            ),
          ),
        ],
      ),
    );
  }
}