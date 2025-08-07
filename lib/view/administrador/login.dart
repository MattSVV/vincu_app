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
  final control = Controladora();

  List<Usuario> listaUsuarios = [];
  bool isLoading = false;
  bool _mostrarPassword = false;

  @override
  void initState() {
    super.initState();
  }

  void _validarCredenciales() async {
  final cedula = cedulaController.text.trim();
  final password = passwordController.text;

  if (cedula.isEmpty || password.isEmpty) {
    control.mostrarMensaje('Por favor ingrese la cédula y la contraseña', context, 'error');
    return;
  }

  setState(() => isLoading = true);

  try {
    
    listaUsuarios = await control.cargarUsuarios();

    final usuarioValido = listaUsuarios.any(
      (usuario) =>
          usuario.cedulaUsuario == cedula &&
          usuario.contraUsuario == password,
    );

    if (usuarioValido) {
      Navigator.pushReplacementNamed(context, '/admin-home');
    } else {
      control.mostrarMensaje('La cédula o contraseña no coinciden', context, 'error');
    }
  } catch (e) {
      control.mostrarMensaje('Ocurrió un error: $e', context, 'error');
  } finally {
    setState(() => isLoading = false);
  }
}

  

  @override
Widget build(BuildContext context) {
  final double screenHeight = MediaQuery.of(context).size.height;
  final double screenWidth = MediaQuery.of(context).size.width;

  return Scaffold(
    backgroundColor: Colors.white,
    resizeToAvoidBottomInset: true, // IMPORTANTE para que el teclado no cause overflow
    body: SafeArea(
      child: SingleChildScrollView( // Scroll automático si el teclado aparece
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.06),
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
                obscureText: !_mostrarPassword,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  labelStyle: TextStyle(color: colorPurple),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _mostrarPassword ? Icons.visibility : Icons.visibility_off,
                      color: colorPurple,
                    ),
                    onPressed: () {
                      setState(() {
                        _mostrarPassword = !_mostrarPassword;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.06),
              isLoading
                  ? const CircularProgressIndicator()
                  : CustomButton(
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
              SizedBox(height: 20), // Espacio adicional al fondo
            ],
          ),
        ),
      ),
    ),
  );
}

}
