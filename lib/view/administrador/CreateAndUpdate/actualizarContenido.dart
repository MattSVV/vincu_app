import 'package:flutter/material.dart';
import 'package:vincu_app/controller/controladora.dart';

class ActualizarContenido extends StatefulWidget {
  final String pantallaSeleccionada;
  final String departamentoSeleccionado;
  final int idContenido;
  final String tituloContenido;
  final String subtituloContenido;
  final String descripcionContenido;

  const ActualizarContenido({
    super.key,
    required this.pantallaSeleccionada,
    required this.departamentoSeleccionado,
    required this.idContenido,
    required this.tituloContenido,
    required this.subtituloContenido,
    required this.descripcionContenido,
  });

  @override
  State<ActualizarContenido> createState() => _ActualizarContenidoState();
}

class _ActualizarContenidoState extends State<ActualizarContenido> {
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController subtituloController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final Controladora control = Controladora();

  @override
  void initState() {
    super.initState();
    tituloController.text = widget.tituloContenido;
    subtituloController.text = widget.subtituloContenido;
    descripcionController.text = widget.descripcionContenido;
  }

  @override
  Widget build(BuildContext context) {
    const azulInstitucional = Color(0xFF1A237E);
    const amarilloInstitucional = Color(0xFFFFC107);
    const fondoClaro = Color(0xFFFAFAFA);

    return Scaffold(
      backgroundColor: fondoClaro,
      appBar: AppBar(
        title: const Text("Actualizar Contenido"),
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
                  "Actualizar contenido",
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
                    String titulo = tituloController.text;
                    String subtitulo = subtituloController.text;
                    String descripcion = descripcionController.text;

                    if (titulo.isEmpty || descripcion.isEmpty) {
                      await control.mostrarMensaje(
                          'Título y descripción son obligatorios', context, 'error');
                      return;
                    }

                    String respuesta = await control.actualizarContenido(
                      widget.idContenido,
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
    );
  }
}
