import 'package:flutter/material.dart';
import 'package:vincu_app/controller/controladora.dart';

class CrearContenido extends StatefulWidget {
  final String pantallaSeleccionada;
  final String departamentoSeleccionado;

  const CrearContenido({
    super.key,
    required this.pantallaSeleccionada,
    required this.departamentoSeleccionado,
  });

  @override
  State<CrearContenido> createState() => _CrearContenidoState();
}

class _CrearContenidoState extends State<CrearContenido> {
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController subtituloController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final Controladora control = Controladora();

  @override
  Widget build(BuildContext context) {
    const azulInstitucional = Color(0xFF1A237E); // Azul ITSJ
    const amarilloInstitucional = Color(0xFFFFC107); // Amarillo ITSJ
    const fondoClaro = Color(0xFFFAFAFA); // Fondo neutro claro

    return Scaffold(
      backgroundColor: fondoClaro,
      appBar: AppBar(
        title: const Text("Crear Contenido"),
        backgroundColor: azulInstitucional,
        foregroundColor: Colors.white,
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Crear contenido",
                    style: TextStyle(
                      color: azulInstitucional,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: tituloController,
                    decoration: InputDecoration(
                      labelText: 'Título',
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: azulInstitucional),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: subtituloController,
                    decoration: InputDecoration(
                      labelText: 'Subtítulo',
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: azulInstitucional),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descripcionController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: 'Descripción',
                      alignLabelWithHint: true,
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: azulInstitucional),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final titulo = tituloController.text.trim();
                      final subtitulo = subtituloController.text.trim();
                      final descripcion = descripcionController.text.trim();

                      if (titulo.isEmpty || descripcion.isEmpty) {
                        await control.mostrarMensaje(
                            'Título y descripción son obligatorios', context, 'error');
                        return;
                      }

                      final respuesta = await control.guardarContenido(
                        titulo,
                        subtitulo,
                        descripcion,
                        widget.pantallaSeleccionada,
                        widget.departamentoSeleccionado,
                      );

                      if (respuesta == "Contenido guardado") {
                        tituloController.clear();
                        subtituloController.clear();
                        descripcionController.clear();
                        Navigator.pop(context);
                      } else {
                        await control.mostrarMensaje(respuesta, context, 'error');
                      }
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Guardar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: amarilloInstitucional,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

