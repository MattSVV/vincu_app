import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vincu_app/model/departamento.dart';
import 'package:vincu_app/model/pantalla.dart';
import 'package:vincu_app/model/contenido.dart';
import 'package:vincu_app/model/usuario.dart';
import 'package:vincu_app/view/administrador/login.dart';
import 'package:vincu_app/view/index.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await getApplicationSupportDirectory();
  Hive.init(directory.path);

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
    return MaterialApp(
      title: 'Vinculación Japón',
      initialRoute: '/',
      routes: {
        '/': (context) => const IndexPage(), 
        '/loginAdministrador': (context) => const AdminLoginPage(),
      },
    );
  }
}

