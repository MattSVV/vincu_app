import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vincu_app/model/departamento.dart';
import 'package:vincu_app/model/pantalla.dart';
import 'package:vincu_app/model/contenido.dart';
import 'package:vincu_app/model/usuario.dart';
import 'package:vincu_app/view/administrador/home.dart';
import 'package:vincu_app/view/administrador/login.dart';
import 'package:vincu_app/view/index.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vincu_app/view/usuario/homeUser.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await getApplicationSupportDirectory();
  Hive.init(directory.path);
  print("mirame aqui estoy");
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
        //rutas admministrador
        '/loginAdministrador': (context) => const AdminLoginPage(),
        '/admin-home' : (context) => const HomeAdmin(),

        //rutas usuarios
        '/homeUsuario': (context) => const HomeUser(),
      },
    );
  }
}

