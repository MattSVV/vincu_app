import 'package:flutter/material.dart';
import 'package:vincu_app/controller/controladora.dart';
import 'package:vincu_app/model/usuario.dart';
import 'package:vincu_app/widgets/custom_button.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final Color colorPurple = const Color(0xFF4B2384);
  final TextEditingController cedulaController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  List<Usuario> listaUsuarios = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _cargarUsuarios();
  }

  Future<void> _cargarUsuarios() async {
    final control = Controladora();
    final usuarios = await control.cargarUsuarios();
    setState(() {
      listaUsuarios = usuarios;
    });
  }

  void _validarCredenciales() {
    final cedula = cedulaController.text.trim();
    final password = passwordController.text;

    if (cedula.isEmpty || password.isEmpty) {
      _mostrarMensaje('Por favor ingrese la cédula y la contraseña');
      return;
    }

    final usuarioValido = listaUsuarios.any((usuario) =>
        usuario.cedulaUsuario == cedula &&
        usuario.contraUsuario == password);

    if (usuarioValido) {
      // Navigator.pushNamed(context, '/admin-dashboard');
      _mostrarMensaje('Usuario coincide entre a la aplicacion');
    } else {
      _mostrarMensaje('La cédula o contraseña no coinciden');
    }
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/universitario_Japon-EscudoNombreHorizontalRelleno.png',
                  width: screenWidth * 0.7,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: screenHeight * 0.06),
                TextField(
                  controller: cedulaController,
                  decoration: InputDecoration(
                    labelText: 'Número de Cédula',
                    labelStyle: TextStyle(color: colorPurple),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: screenHeight * 0.025),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    labelStyle: TextStyle(color: colorPurple),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: screenHeight * 0.06),
                CustomButton(
                  text: 'Iniciar sesión',
                  color: colorPurple,
                  onPressed: _validarCredenciales,
                ),
                SizedBox(height: screenHeight * 0.02),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Volver al inicio',
                    style: TextStyle(color: colorPurple),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
