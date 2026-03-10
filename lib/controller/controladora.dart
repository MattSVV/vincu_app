
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:vincu_app/db/database.dart';
import 'package:vincu_app/model/archivo.dart';
import 'package:vincu_app/model/contenido.dart';
import 'package:vincu_app/model/departamento.dart';
import 'package:vincu_app/model/pantalla.dart';
import 'package:vincu_app/model/usuario.dart';

import 'package:vincu_app/router/routerContenido.dart';
import 'package:vincu_app/router/routerDepartamento.dart';
import 'package:vincu_app/router/routerPantalla.dart';
import 'package:vincu_app/router/routerUsuario.dart';
import 'package:vincu_app/router/routerArchivo.dart';


class Controladora {
  // Singleton
  Controladora._internal();
  static final Controladora _instance = Controladora._internal();
  factory Controladora() => _instance;

  // Routers
  final RouterContenido rtCont = RouterContenido();
  final RouterUsuario rtUsu = RouterUsuario();
  final RouterDepartamento rtDep = RouterDepartamento();
  final RouterPantalla rtPant = RouterPantalla();
  final RouterArchivo rtArchivo = RouterArchivo();

  /* -------------------------------------------------------------
  *  CENTRALIZADOR DE LECTURA HIVE
  * ----------------------------------------------------------- */
  Future<List<T>> cargarHive<T>(String boxName) async {
    final hive = DBHive();
    await hive.initDB(boxName);

    final local = hive.readData();
    final datos = local.values.cast<T>().toList();

    hive.dispose();
    return datos;
  }

  /* -------------------------------------------------------------
  *  CENTRALIZADOR DE LÓGICA OFFLINE - ONLINE
  * ----------------------------------------------------------- */
  Future<List<T>> cargarDatos<T>(
    String boxName,
    Future<List<T>> Function() fetchRemote, {
    void Function(List<T>)? onUpdate,
  }) async {
    final hive = DBHive();
    await hive.initDB(boxName);

    try {
      final localMap = hive.readData();
      final local = localMap.values.cast<T>().toList();

      final tieneInternet = await verificarConexionInternet();

      // Si hay datos locales, primero se devuelven
      if (local.isNotEmpty) {
        onUpdate?.call(local);

        if (tieneInternet) {
          try {
    final remote = await fetchRemote();
    
    if (remote.isNotEmpty) {
      await hive.box.clear(); 
      for (var item in remote) {
        await hive.addData(item);
      }
      onUpdate?.call(remote);
      return remote;
    }
  } catch (e) {
    debugPrint("Fallo fetch remoto, manteniendo locales");
  }
        }

        return local;
      }

      // Si no hay datos locales → intenta desde el servidor
      if (tieneInternet) {
        final remote = await fetchRemote();

        await hive.box.clear();
        for (var item in remote) {
          await hive.addData(item);
        }

        return remote;
      }

      return [];
    } catch (e, stack) {
      debugPrint("Error en cargarDatos($boxName): $e\n$stack");
      return [];
    } finally {
      hive.dispose();
    }
  }

  /* -------------------------------------------------------------
  *  MÉTODOS DE CARGA (BÁSICOS)
  * ----------------------------------------------------------- */

  Future<List<Contenido>> cargarContenidos({void Function(List<Contenido>)? onUpdate}) {
    return cargarDatos<Contenido>('contenidos', rtCont.listaContenido, onUpdate: onUpdate);
  }

  Future<List<Departamento>> cargarDepartamentos() {
    return cargarDatos<Departamento>('departamentos', rtDep.traerDepa);
  }

  Future<List<Pantalla>> cargarPantallas() {
    return cargarDatos<Pantalla>('pantallas', rtPant.traerPantalla);
  }

  Future<List<Usuario>> cargarUsuarios() async {
    try {
      return await rtUsu.leerUsuario();
    } catch (e) {
      debugPrint("Error al cargar usuarios: $e");
      return [];
    }
  }

  Future<List<Archivo>> cargarArchivos() async {
    try {
      return await rtArchivo.listaArchivo();
    } catch (e) {
      debugPrint("Error al cargar archivos: $e");
      return [];
    }
  }
  /* -------------------------------------------------------------
  *  CRUD - CONTENIDOS
  * ----------------------------------------------------------- */

  Future<String> guardarContenido(
    String titulo,
    String subtitulo,
    String descripcion,
    String pantalla,
    String departamento,
  ) async {
    try {
      if (titulo.isEmpty || descripcion.isEmpty || pantalla.isEmpty || departamento.isEmpty) {
        return "Campos incompletos";
      }

      final pantallas = await cargarPantallas();
      final departamentos = await cargarDepartamentos();

      final pantallaObj = pantallas.firstWhere(
        (p) => p.nombrePantalla == pantalla,
        orElse: () => Pantalla.defaultPantalla(),
      );

      final departamentoObj = departamentos.firstWhere(
        (d) => d.nombreDepartamento == departamento,
        orElse: () => Departamento.defaultDepartamento(),
      );

      final contenido = Contenido(
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
      debugPrint("Error al guardar contenido: $e");
      return "Error al guardar contenido";
    }
  }

  Future<String> actualizarContenido(
    int idContenido,
    String titulo,
    String subtitulo,
    String descripcion,
    String pantalla,
    String departamento,
  ) async {
    try {
      if (titulo.isEmpty || descripcion.isEmpty) {
        return "Campos incompletos";
      }

      final pantallas = await cargarPantallas();
      final departamentos = await cargarDepartamentos();

      final pantallaObj = pantallas.firstWhere(
        (p) => p.nombrePantalla == pantalla,
        orElse: () => Pantalla.defaultPantalla(),
      );

      final departamentoObj = departamentos.firstWhere(
        (d) => d.nombreDepartamento == departamento,
        orElse: () => Departamento.defaultDepartamento(),
      );

      final contenido = Contenido(
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
      debugPrint("Error al actualizar contenido: $e");
      return "Error al actualizar contenido";
    }
  }

  Future<String> eliminarContenido(int idContenido) async {
    if (idContenido <= 0) return "ID inválido";

    final hive = DBHive();
    await hive.initDB('contenidos');

    try {
      
      final result = await rtCont.eliminarContenido(idContenido);

      if(result){
      final local = hive.readData().values.cast<Contenido>().toList();
      final contenido = local.firstWhere(
        (c) => c.idContenido == idContenido,
        orElse: () => Contenido.defaultContenido(),
      );

      if (contenido.idContenido != -1) {
        await hive.deleteData(contenido.idContenido);
      }
      return "Contenido eliminado";
      } else {
        return "Error al eliminar contenido";
      }
      
    } catch (e) {
      debugPrint("Error al eliminar contenido: $e");
      return "Error al eliminar contenido";
    } finally {
      hive.dispose();
    }
  }

  /* -------------------------------------------------------------
  *  FILTRO POR DEPARTAMENTO
  * ----------------------------------------------------------- */
  Future<List<Contenido>> cargarContenidosPorDepartamento(int idDepartamento) async {
  final hive = DBHive();
  await hive.initDB('contenidos');

  try {
    final hayInternet = await verificarConexionInternet();
    
    if (hayInternet) {
      // 1. Traer datos frescos del servidor
      final remotos = await rtCont.cargarContenidosPorDepartamento(idDepartamento);
      
      if (remotos.isNotEmpty) {
        // 2. ACTUALIZAR HIVE: Solo borramos y guardamos si recibimos algo del servidor
        // Para no borrar TODO lo de otras pantallas, podrías filtrar o usar putAll
        for (var item in remotos) {
          await hive.addData(item); 
        }
      }
      return remotos;
    }
  } catch (e) {
    debugPrint("Error remoto, intentando local... $e");
  } finally {
    // Importante: No cierres la box aquí si la vas a usar abajo, 
    // o asegúrate de que cargarHive la abra de nuevo.
    hive.dispose();
  }

  // 3. FALLBACK: Si no hay internet o falló la red, leemos de Hive
  final locales = await cargarHive<Contenido>('contenidos');
  return locales.where((c) => c.departamento.idDepartamento == idDepartamento).toList();
}

/* -------------------------------------------------------------
  *  CRUD de ENLACES
  * ----------------------------------------------------------- */

Future<String> crearEnlace(String departamentoSeleccionado, String titulo, String url) async {
    try {
    if (titulo.isEmpty || url.isEmpty) {
      return "Por favor, llena todos los campos";
    }

    if (!url.startsWith('http')) {
      url = 'https://$url';
    }

    final departamentos = await cargarDepartamentos();
    final departamentoObj = departamentos.firstWhere(
      (d) => d.nombreDepartamento == departamentoSeleccionado,
      orElse: () => Departamento.defaultDepartamento(),
    );
    
    Archivo nuevoArchivo = Archivo.defaultArchivo();
    nuevoArchivo.tituloArchivo = titulo;
    nuevoArchivo.urlArchivo = url;
    nuevoArchivo.departamentoArchivo = departamentoObj;
    
    await rtArchivo.crearArchivo(nuevoArchivo);
    return "Enlace guardado";
    } catch (e) {
      debugPrint("Error al crear enlace: $e");
      return "Error al guardar enlace";
    }
    
  }

Future<String> eliminarEnlace(int idEnlace) async {
   try{
      final result = await rtArchivo.eliminarArchivo(idEnlace);
      if(result){
        return "Enlace eliminado";
      } else {
        return "Error al eliminar enlace";
      }
   }catch(e){
     debugPrint("Error al eliminar enlace: $e");
     return "Error al eliminar enlace";
   } 
  }

Future<String> actualizarEnlace(int idEnlace, String titulo, String url) async {
    try {

      if (titulo.isEmpty || url.isEmpty) {
        return "Por favor, llena todos los campos";
      }

      if (!url.startsWith('http')) {
        url = 'https://$url';
      }

      final archivoActualizado = Archivo(
        idEnlace,
        titulo,
        url,
        Departamento.defaultDepartamento(), // Aquí podrías querer mantener el mismo departamento
      );
      await rtArchivo.actualizarArchivo(archivoActualizado);
      return "Enlace actualizado";
    } catch (e) {
      debugPrint("Error al actualizar enlace: $e");
      return "Error al actualizar enlace";
    }
}


  /* -------------------------------------------------------------
  *  UTILIDADES
  * ----------------------------------------------------------- */

  Future<bool> verificarConexionInternet() async {
  try {
    // 1. Verificación rápida de la interfaz (Wi-Fi/Datos)
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }

    // 2. "Ping" real a Google (resolución de DNS)
    // Usamos un timeout para que la app no se quede colgada si el internet es muy lento
    final result = await InternetAddress.lookup('google.com')
        .timeout(const Duration(seconds: 3));

    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    // Si hay un error de socket, es que no hay salida a internet
    return false;
  } on TimeoutException catch (_) {
    // Si tarda demasiado, mejor tratarlo como offline
    return false;
  } catch (e) {
    debugPrint("Error verificando conexión: $e");
    return false;
  }
}

  Future<void> mostrarMensaje(
    String mensaje,
    BuildContext context,
    String tipo,
  ) async {
    final colores = {
      'error': Colors.red[700],
      'success': Colors.green[700],
      'info': Colors.blue[700],
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: colores[tipo] ?? Colors.black87,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  
}
