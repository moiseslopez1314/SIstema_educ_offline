import 'package:flutter/material.dart';
import '../services/estadisticas_service.dart';
import '../services/perfil_service.dart';
import '../theme/colores.dart';

const List<IconData> _avatares = [
  Icons.face_rounded,
  Icons.rocket_launch_rounded,
  Icons.school_rounded,
  Icons.code_rounded,
  Icons.pets_rounded,
  Icons.star_rounded,
];

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final _controller = TextEditingController();
  int _avatar = 0;
  Resumen? _resumen;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _cargar() async {
    final perfil = await PerfilService().obtener();
    final resumen = await EstadisticasService().cargar();
    if (!mounted) return;
    setState(() {
      _controller.text = perfil.nombre;
      _avatar = perfil.avatar;
      _resumen = resumen;
    });
  }

  Future<void> _guardar() async {
    await PerfilService().guardar(_controller.text.trim(), _avatar);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perfil guardado')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = _resumen;
    return Scaffold(
      appBar: AppBar(title: const Text('Mi perfil')),
      body: r == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: Colores.primario,
                    child: Icon(_avatares[_avatar],
                        size: 48, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colores.pista,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      'Nivel: ${r.nivel}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3730A3),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _Dato(
                          valor: '${r.hechas}', etiqueta: 'Lecciones hechas'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _Dato(
                          valor: '${r.cursosCompletos}',
                          etiqueta: 'Cursos completados'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _controller,
                  maxLength: 24,
                  decoration: InputDecoration(
                    labelText: 'Tu nombre',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Elige tu avatar',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colores.texto,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    for (int i = 0; i < _avatares.length; i++)
                      GestureDetector(
                        onTap: () => setState(() => _avatar = i),
                        child: CircleAvatar(
                          radius: 26,
                          backgroundColor:
                              i == _avatar ? Colores.primario : Colores.pista,
                          child: Icon(
                            _avatares[i],
                            color: i == _avatar
                                ? Colors.white
                                : Colores.textoSuave,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  onPressed: _guardar,
                  child: const Text('Guardar'),
                ),
              ],
            ),
    );
  }
}

class _Dato extends StatelessWidget {
  final String valor;
  final String etiqueta;

  const _Dato({required this.valor, required this.etiqueta});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            valor,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colores.primario,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            etiqueta,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colores.textoSuave),
          ),
        ],
      ),
    );
  }
}