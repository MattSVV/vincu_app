import 'dart:io';
import 'package:flutter/material.dart';

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

  Future<String> guardarContenido(
    String titulo,
    String subtitulo,
    String descripcion,
    String pantalla,
    String departamento,
  ) async {
    try {
      if (titulo.isEmpty ||
          descripcion.isEmpty ||
          pantalla.isEmpty ||
          departamento.isEmpty) {
        print("Contenido vacío, no se guardará.");
        return "Contenido vacío";
      }

      List<Pantalla> pantallas = await cargarPantallas();
      List<Departamento> departamentos = await cargarDepartamentos();

      Pantalla pantallaObj = pantallas.firstWhere(
        (p) => p.nombrePantalla == pantalla,
        orElse: () => Pantalla.defaultPantalla(),
      );

      Departamento departamentoObj = departamentos.firstWhere(
        (d) => d.nombreDepartamento == departamento,
        orElse: () => Departamento.defaultDepartamento(),
      );

      Contenido contenido = Contenido(
        0,
        titulo,
        subtitulo,
        descripcion,
        departamentoObj,
        pantallaObj,
      );

      await rtCont.guardarContenido(contenido);
      return "Contenido guardado";
    } catch (e) {
      print("Error al guardar contenido: $e");
      return "Error al guardar contenido";
    }
  }

  Future<String> actualizarContenido(
    int idContenido,
    String titulo,
    String subtitulo,
    String descripcion,
    String pantallaSeleccionada,
    String departamentoSeleccionado,
  ) async {
    try {
      if (titulo.isEmpty || descripcion.isEmpty) {
        print("Contenido vacío, no se actualizará.");
        return "Contenido vacío";
      }

      List<Pantalla> pantallas = await cargarPantallas();
      List<Departamento> departamentos = await cargarDepartamentos();

      Pantalla pantallaObj = pantallas.firstWhere(
        (p) => p.nombrePantalla == pantallaSeleccionada,
        orElse: () => Pantalla.defaultPantalla(),
      );

      Departamento departamentoObj = departamentos.firstWhere(
        (d) => d.nombreDepartamento == departamentoSeleccionado,
        orElse: () => Departamento.defaultDepartamento(),
      );

      Contenido contenido = Contenido(
        idContenido,
        titulo,
        subtitulo,
        descripcion,
        departamentoObj,
        pantallaObj,
      );

      await rtCont.actualizarContenido(contenido);
      return "Contenido actualizado";
    } catch (e) {
      print("Error al actualizar contenido: $e");
      return "Error al actualizar contenido";
    }
  }

  Future<String> eliminarContenido(int idContenido) async {
    final hive = DBHive();
    await hive.initDB('contenidos');
    try {
      if (idContenido <= 0) {
        return 'ID de contenido inválido';
      }
      final localData = hive.readData();
      final contenidos = localData.values.cast<Contenido>().toList();
      if (contenidos.isNotEmpty) {
        final contenido = contenidos.firstWhere(
          (c) => c.idContenido == idContenido,
          orElse: () => Contenido.defaultContenido(),
        );
        if (contenido != Contenido.defaultContenido()) {
          await hive.deleteData(contenido.idContenido);
        }
      }
      await rtCont.eliminarContenido(idContenido);
      print("Contenido con ID $idContenido eliminado");
      return 'Contenido Eliminado';
    } catch (e) {
      print("Error al eliminar contenido: $e");
      return 'Error al eliminar contenido';
    }
  }

  //Funciones generales
  Future<bool> verificarConexionInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<void> mostrarMensaje(
    String mensaje,
    BuildContext context,
    String uso,
  ) async {
    final error = Colors.red[700];
    final success = Colors.green[700];
    final info = Colors.blue[700];

    switch (uso) {
      case 'error':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(mensaje),
            backgroundColor: error,
            behavior: SnackBarBehavior.floating,
          ),
        );
        break;
      case 'success':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(mensaje),
            backgroundColor: success,
            behavior: SnackBarBehavior.floating,
          ),
        );
        break;
      case 'info':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(mensaje),
            backgroundColor: info,
            behavior: SnackBarBehavior.floating,
          ),
        );
        break;
    };

    // Mostrar un SnackBar con el mensaje
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), behavior: SnackBarBehavior.floating),
    );
  }

  Future<List<Contenido>> cargarContenidosPorDepartamento(
    int idDepartamento,
  ) async {
    try {
      final hasInternet = await verificarConexionInternet();
      if (!hasInternet) {
        print("Sin conexión a internet");
        return [];
      }

      final contenidos = await rtCont.cargarContenidosPorDepartamento(
        idDepartamento,
      );
      if (contenidos.isEmpty) {
        print(
          "No se encontraron contenidos para el departamento: $idDepartamento",
        );
      }

      return contenidos;
    } catch (e) {
      print("Error al cargar contenidos por departamento: $e");
      return [];
    }
  }
}
