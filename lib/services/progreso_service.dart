import 'package:shared_preferences/shared_preferences.dart';

class ProgresoService {
  static const _prefijo = 'puntaje_';

  Future<void> guardarPuntaje(String leccionId, int puntaje) async {
    final prefs = await SharedPreferences.getInstance();
    final actual = prefs.getInt('$_prefijo$leccionId');
    if (actual == null || puntaje > actual) {
      await prefs.setInt('$_prefijo$leccionId', puntaje);
    }
  }

  Future<Map<String, int>> obtenerPuntajes() async {
    final prefs = await SharedPreferences.getInstance();
    final mapa = <String, int>{};
    for (final clave in prefs.getKeys()) {
      if (clave.startsWith(_prefijo)) {
        final valor = prefs.getInt(clave);
        if (valor != null) {
          mapa[clave.substring(_prefijo.length)] = valor;
        }
      }
    }
    return mapa;
  }
}