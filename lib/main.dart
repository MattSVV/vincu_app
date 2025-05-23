import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:vincu_app/model/departamento.dart';
import 'package:vincu_app/model/pantalla.dart';
import 'package:vincu_app/model/contenido.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vincu_app/model/usuario.dart';


Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  Hive.registerAdapter(ContenidoAdapter());
  Hive.registerAdapter(DepartamentoAdapter());
  Hive.registerAdapter(PantallaAdapter());
  Hive.registerAdapter(UsuarioAdapter());

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: Text('Hello World!'))),
    );
  }
}
