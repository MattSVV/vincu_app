import 'dart:io';


import 'package:vincu_app/db/database.dart';
import 'package:vincu_app/model/contenido.dart';
import 'package:vincu_app/model/usuario.dart';
import 'package:vincu_app/router/routerContenido.dart';
import 'package:vincu_app/router/routerUsuario.dart';

class Controladora {
  RouterContenido rtCont = RouterContenido();
  RouterUsuario rtUsu = RouterUsuario();

  Future<List<Contenido>> cargarContenidos() async {
    bool tieneInternet = await verificarConexionInternet();
    final hive = DBHive();
    await hive.initDB('contenidos');

    if (tieneInternet) {
      List<Contenido> contenidos = await rtCont.listaContenido();
      await hive.box.clear();
      for (var contenido in contenidos) {
        await hive.addData<Contenido>(contenido);
      }
      return contenidos;
    } else {
      final data = hive.readData();
      if (data.isEmpty) {
        print("No hay conexión ni datos locales.");
        return [];
      }
      return data.values.cast<Contenido>().toList();
    }
  }

  Future<List<Usuario>> cargarUsuarios() async {
    bool tieneInternet = await verificarConexionInternet();
    final hive = DBHive();
    await hive.initDB('usuarios');

    if (tieneInternet) {
      List<Usuario> usuarios = await rtUsu.leerUsuario();
      await hive.box.clear();
      for (var usuario in usuarios) {
        await hive.addData<Usuario>(usuario);
      }
      return usuarios;
    } else {
      final data = hive.readData();
      if (data.isEmpty) {
        print("No hay conexión ni datos locales.");
        return [];
      }
      return data.values.cast<Usuario>().toList();
    }
  }
}

Future<bool> verificarConexionInternet() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } catch (_) {
    return false;
  }
}
