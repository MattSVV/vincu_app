import 'package:flutter/material.dart';
import 'package:vincu_app/controller/controladora.dart';

class ActualizarEnlace extends StatefulWidget {
  final int idEnlace;
  final String tituloActual;
  final String urlActual;

  const ActualizarEnlace({
    super.key,
    required this.idEnlace,
    required this.tituloActual,
    required this.urlActual,
  });

  @override
  State<ActualizarEnlace> createState() => _ActualizarEnlaceState();
}

class _ActualizarEnlaceState extends State<ActualizarEnlace> {
  late TextEditingController tituloController;
  late TextEditingController urlController;

  final Controladora control = Controladora();

  @override
  void initState() {
    super.initState();

    // Precargar datos actuales
    tituloController = TextEditingController(text: widget.tituloActual);
    urlController = TextEditingController(text: widget.urlActual);
  }

  @override
  void dispose() {
    tituloController.dispose();
    urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const azulInstitucional = Color(0xFF1A237E);
    const amarilloInstitucional = Color(0xFFFFC107);
    const fondoClaro = Color(0xFFFAFAFA);

    return Scaffold(
      backgroundColor: fondoClaro,
      appBar: AppBar(
        title: const Text("Actualizar Enlace"),
        backgroundColor: azulInstitucional,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Actualizar enlace",
                  style: TextStyle(
                    color: azulInstitucional,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // TÍTULO
                TextField(
                  controller: tituloController,
                  decoration: InputDecoration(
                    labelText: "Título del enlace",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    prefixIcon:
                        Icon(Icons.link, color: amarilloInstitucional),
                  ),
                ),

                const SizedBox(height: 20),

                // URL
                TextField(
                  controller: urlController,
                  decoration: InputDecoration(
                    labelText: "URL del enlace",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    prefixIcon:
                        Icon(Icons.public, color: amarilloInstitucional),
                  ),
                ),

                const SizedBox(height: 30),

                ElevatedButton.icon(
                  icon: const Icon(Icons.update, color: amarilloInstitucional),
                  label: const Text("Actualizar enlace", style: TextStyle(color: fondoClaro )),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: azulInstitucional,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () async {
                    String titulo = tituloController.text.trim();
                    String url = urlController.text.trim();

                    if (titulo.isEmpty || url.isEmpty) {
                      await control.mostrarMensaje(
                          "Todos los campos son obligatorios",
                          context,
                          'error');
                      return;
                    }

                    // Loader
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) =>
                          const Center(child: CircularProgressIndicator()),
                    );

                    final respuesta = await control.actualizarEnlace(
                      widget.idEnlace,
                      titulo,
                      url,
                    );

                    Navigator.pop(context); // cerrar loader

                    if (respuesta == "Enlace actualizado") {
                      await control.mostrarMensaje(
                          respuesta, context, 'success');
                      Navigator.pop(context, true); // regresar y refrescar
                    } else {
                      await control.mostrarMensaje(
                          respuesta, context, 'error');
                    }
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