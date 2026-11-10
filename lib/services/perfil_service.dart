import 'package:shared_preferences/shared_preferences.dart';

class Perfil {
  final String nombre;
  final int avatar;
  Perfil(this.nombre, this.avatar);
}

class PerfilService {
  Future<Perfil> obtener() async {
    final prefs = await SharedPreferences.getInstance();
    return Perfil(
      prefs.getString('perfil_nombre') ?? '',
      prefs.getInt('perfil_avatar') ?? 0,
    );
  }

  Future<void> guardar(String nombre, int avatar) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('perfil_nombre', nombre);
    await prefs.setInt('perfil_avatar', avatar);
  }
}