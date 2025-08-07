import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vincu_app/model/pantalla.dart';

class RouterPantalla {
  RouterPantalla();

  Future<List<Pantalla>> traerPantalla() async {
    final uri = Uri.parse('https://api-vinculacion-0309.onrender.com/api/pantalla');
     final response = await http.get(
      uri,
      headers: {'x-api-key': dotenv.env['API_KEY']!},
    );
    List<Pantalla> pantallas = [];

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      pantallas = data.map((json) => Pantalla.fromJson(json)).toList();
    }
    return pantallas;
  }
}
