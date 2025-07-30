import 'dart:io';

import 'package:vincu_app/db/database.dart';
import 'package:vincu_app/model/contenido.dart';
import 'package:vincu_app/model/departamento.dart';
import 'package:vincu_app/model/pantalla.dart';
import 'package:vincu_app/model/usuario.dart';
import 'package:vincu_app/router/routerContenido.dart';
import 'package:vincu_app/router/routerDepartamento.dart';
import 'package:vincu_app/router/routerPantalla.dart';
import 'package:vincu_app/router/routerUsuario.dart';

class Controladora {
  RouterContenido rtCont = RouterContenido();
  RouterUsuario rtUsu = RouterUsuario();
  RouterDepartamento rtDep = RouterDepartamento();
  RouterPantalla rtPant = RouterPantalla();

  //Datos del contenido de la aplicación

  Future<List<Contenido>> cargarContenidos({
    void Function(List<Contenido>)? onUpdate,
  }) async {
    final hive = DBHive();
    try {
      await hive.initDB('contenidos');

      // Paso 1: mostrar datos locales si existen
      final localData = hive.readData();
      if (localData.isNotEmpty) {
        final listaLocal = localData.values.cast<Contenido>().toList();

        // Notifica a la UI con los datos locales
        if (onUpdate != null) {
          onUpdate(listaLocal);
        }

        // Paso 2: intenta actualizar en segundo plano si hay internet
        bool tieneInternet = await verificarConexionInternet();
        if (tieneInternet) {
          final nuevosDatos = await rtCont.listaContenido();
          await hive.box.clear();
          for (var contenido in nuevosDatos) {
            await hive.addData<Contenido>(contenido);
          }

          // Notifica actualización con datos nuevos
          if (onUpdate != null) {
            onUpdate(nuevosDatos);
          }
        }

        return listaLocal;
      }

      // Si no hay datos locales, intenta cargar desde internet
      bool tieneInternet = await verificarConexionInternet();
      if (tieneInternet) {
        final contenidos = await rtCont.listaContenido();
        await hive.box.clear();
        for (var contenido in contenidos) {
          await hive.addData<Contenido>(contenido);
        }
        return contenidos;
      }

      print("No hay conexión ni datos locales.");
      return [];
    } catch (e) {
      print("Error al cargar contenidos: $e");
      return [];
    } finally {
      hive.dispose();
    }
  }

  Future<List<Departamento>> cargarDepartamentos() async {
    final hive = DBHive();
    try {
      await hive.initDB('departamentos');
      final hasInternet = await verificarConexionInternet();
      if (hasInternet) {
        final departamentos = await rtDep.traerDepa();
        await hive.box.clear();
        for (var departamento in departamentos) {
          await hive.addData<Departamento>(departamento);
        }
        return departamentos;
      } else {
        final localData = hive.readData();
        if (localData.isNotEmpty) {
          return localData.values.cast<Departamento>().toList();
        }
        return [];
      }
    } catch (e) {
      print("Error al cargar departamentos: $e");
      return [];
    }
  }

  Future<List<Pantalla>> cargarPantallas() async {
    try {
      final hive = DBHive();
      await hive.initDB('pantallas');
      final hasInternet = await verificarConexionInternet();
      if (hasInternet) {
        final pantallas = await rtPant.traerPantalla();
        await hive.box.clear();
        for (var pantalla in pantallas) {
          await hive.addData<Pantalla>(pantalla);
        }
        return pantallas;
      } else {
        final localData = hive.readData();
        if (localData.isNotEmpty) {
          return localData.values.cast<Pantalla>().toList();
        }
        return [];
      }
    } catch (e) {
      print("Error al cargar pantallas: $e");
      return [];
    }
  }

  //Pantalla login

  Future<List<Usuario>> cargarUsuarios() async {
    try {
      List<Usuario> usuarios = await rtUsu.leerUsuario();
      return usuarios;
    } catch (e) {
      print("Error al cargar usuarios: $e");
      return [];
    }
  }

  //Controladores del Crud

  Future<String> guardarContenido(Contenido contenido) async {
    try {
      if (contenido.tituloContenido.isEmpty ||
          contenido.descripcionContenido.isEmpty) {
        print("Contenido vacío, no se guardará.");
        return "Contenido vacío";
      }
      await rtCont.guardarContenido(contenido);
      return "Contenido guardado";
    } catch (e) {
      print("Error al guardar contenido: $e");
      return "Error al guardar contenido";
    }
  }

  //Funcion general
  Future<bool> verificarConexionInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
