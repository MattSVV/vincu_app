import 'package:flutter/material.dart';
import 'package:vincu_app/controller/controladora.dart';

class CrearEnlace extends StatefulWidget {
  final String departamentoSeleccionado;

  const CrearEnlace({
    super.key,
    required this.departamentoSeleccionado,
  });

  @override
  State<CrearEnlace> createState() => _CrearEnlaceState();
}

class _CrearEnlaceState extends State<CrearEnlace> {
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final Controladora control = Controladora();

  @override
  Widget build(BuildContext context) {
    const azulInstitucional = Color(0xFF1A237E);
    const amarilloInstitucional = Color(0xFFFFC107);
    const fondoClaro = Color(0xFFFAFAFA);

    return Scaffold(
      backgroundColor: fondoClaro,
      appBar: AppBar(
        title: const Text("Crear Enlace"),
        backgroundColor: azulInstitucional,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Crear enlace",
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
                    labelText: "Título del enlace",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    prefixIcon: Icon(Icons.link, color: amarilloInstitucional),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: urlController,
                  decoration: InputDecoration(
                    labelText: "URL del enlace",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    prefixIcon: Icon(Icons.public, color: amarilloInstitucional),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  icon: const Icon(Icons.save, color: amarilloInstitucional),
                  label: const Text("Guardar enlace", style: TextStyle(color: fondoClaro)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: azulInstitucional,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () async {
                    String titulo = tituloController.text.trim();
                    String url = urlController.text.trim();
                    // Lógica para guardar el enlace

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const Center(child: CircularProgressIndicator()),
                      );

                      final respuesta = await control.crearEnlace(
                        widget.departamentoSeleccionado,
                        titulo,
                        url,
                      );

                      Navigator.pop(context); // Cerrar el diálogo de carga

                      if(respuesta == "Enlace guardado"){
                        tituloController.clear();
                        urlController.clear();
                        await control.mostrarMensaje(respuesta, context, 'success');
                        Navigator.pop(context);
                      }else{
                        await control.mostrarMensaje(respuesta, context, 'error');
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