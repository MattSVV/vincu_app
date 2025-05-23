import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vincu_app/model/contenido.dart';
import 'package:vincu_app/model/departamento.dart';
import 'package:vincu_app/model/pantalla.dart';
import 'package:vincu_app/router/routerDepartamento.dart';
import 'package:vincu_app/router/routerPantalla.dart';

class RouterContenido {
  RouterContenido();
  RouterDepartamento rtDep = RouterDepartamento();
  RouterPantalla rtPantalla = RouterPantalla();

  Future<List<Contenido>> listaContenido() async {
    final url = Uri.parse('https://api-vinculacion-0309.onrender.com/api/contenido');
    final response = await http.get(
      url,
      headers: {'x-api-key': dotenv.env['API_KEY']!},
    );
    List<Contenido> contenidos = [];
    List<Pantalla> pantallas = await rtPantalla.traerPantalla();
    List<Departamento> departamentos = await rtDep.traerDepa();

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      contenidos =
          data.map((json) {
            // Obtener los ID del JSON
            int idPantalla = json['id_Pantalla'];
            int idDepartamento = json['id_Departamento'];

            // Buscar los objetos completos
            Pantalla? pantalla = pantallas.firstWhere(
              (p) => p.idPantalla == idPantalla,
              orElse: () => Pantalla.defaultPantalla(),
            );

            Departamento? departamento = departamentos.firstWhere(
              (d) => d.idDepartamento == idDepartamento,
              orElse: () => Departamento.defaultDepartamento(),
            );

            // Crear objeto Contenido manualmente
            return Contenido(
              json['id_Contenido'],
              json['titulo_Contenido'],
              json['Subtitulo_Contenido'],
              json['descripcion_Contenido'],
              departamento,
              pantalla,
            );
          }).toList();
    } else {
      print("Error: ${response.statusCode}");
    }
    return contenidos;
  }
}
