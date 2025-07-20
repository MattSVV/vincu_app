import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:vincu_app/model/usuario.dart';

class RouterUsuario {
  final String _urlApi = 'https://api-vinculacion-0309.onrender.com/api/usuarios/';

  Future<List<Usuario>> leerUsuario() async {
    final uri = Uri.parse(_urlApi);
    final response = await http.get(
      uri,
      headers: {'x-api-key': dotenv.env['API_KEY']!},
    );

    List<Usuario> usuarios = [];

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      usuarios = data.map((json) => Usuario.fromJson(json)).toList();
    }

    return usuarios;
  }
}
