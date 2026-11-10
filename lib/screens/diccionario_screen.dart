import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/termino.dart';
import '../theme/colores.dart';

class DiccionarioScreen extends StatefulWidget {
  const DiccionarioScreen({super.key});

  @override
  State<DiccionarioScreen> createState() => _DiccionarioScreenState();
}

class _DiccionarioScreenState extends State<DiccionarioScreen> {
  List<Termino> _todos = [];
  String _busqueda = '';
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final texto = await rootBundle.loadString('assets/diccionario.json');
    final lista = (jsonDecode(texto) as List)
        .map((t) => Termino.fromJson(t))
        .toList();
    lista.sort((a, b) => a.termino.compareTo(b.termino));
    if (!mounted) return;
    setState(() {
      _todos = lista;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final q = _busqueda.toLowerCase().trim();
    final filtrados = _todos
        .where((t) =>
            t.termino.toLowerCase().contains(q) ||
            t.definicion.toLowerCase().contains(q))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Diccionario')),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                  child: TextField(
                    onChanged: (v) => setState(() => _busqueda = v),
                    decoration: InputDecoration(
                      hintText: 'Buscar un concepto',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: filtrados.isEmpty
                      ? const Center(
                          child: Text(
                            'Sin resultados',
                            style: TextStyle(color: Colores.textoSuave),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(24),
                          itemCount: filtrados.length,
                          itemBuilder: (context, i) =>
                              _TarjetaTermino(termino: filtrados[i]),
                        ),
                ),
              ],
            ),
    );
  }
}

class _TarjetaTermino extends StatelessWidget {
  final Termino termino;

  const _TarjetaTermino({required this.termino});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            termino.termino,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colores.primario,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            termino.definicion,
            style: const TextStyle(
                fontSize: 15, height: 1.5, color: Colores.texto),
          ),
          const SizedBox(height: 8),
          Text(
            'Ejemplo: ${termino.ejemplo}',
            style: const TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: Colores.textoSuave,
            ),
          ),
        ],
      ),
    );
  }
}