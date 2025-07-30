import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:vincu_app/model/departamento.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RouterDepartamento {
  RouterDepartamento();

  Future<List<Departamento>> traerDepa() async {
    final uri = Uri.parse('https://api-vinculacion-0309.onrender.com/api/departamento');
     final response = await http.get(
      uri,
      headers: {'x-api-key': dotenv.env['API_KEY']!},
    );
    List<Departamento> depatartamentos = [];

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      depatartamentos =
          data.map((json) => Departamento.fromJson(json)).toList();
    } else {
      print('Error: ${response.statusCode}');
    }

    return depatartamentos;
  }

  Future<Departamento?> traerDepaPorId(int id) async {
    final uri = Uri.parse('https://api-vinculacion-0309.onrender.com/api/departamento/$id');
    final response = await http.get(
      uri,
      headers: {'x-api-key': dotenv.env['API_KEY']!},
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      Departamento depa = Departamento.fromJson(data);

      return depa;
    } else {
      print('Error: ${response.statusCode}');
      return null;
    }
  }
}
