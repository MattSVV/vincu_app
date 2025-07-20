import 'package:flutter/material.dart';
import '../widgets/custom_button.dart'; // Importa el botón personalizado

class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color colorPurple = const Color(0xFF4B2384);
    final Color colorYellow = const Color(0xFFF2C800);
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
                CustomButton(
                  text: 'Usuario',
                  color: colorPurple,
                  onPressed: () {
                    Navigator.pushNamed(context, '/usuario');
                  },
                ),
                SizedBox(height: screenHeight * 0.025),
                CustomButton(
                  text: 'Administrador',
                  color: colorYellow,
                  textColor: Colors.black,
                  onPressed: () {
                    Navigator.pushNamed(context, '/loginAdministrador');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
