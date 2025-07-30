import 'package:flutter/material.dart';
import 'package:vincu_app/model/contenido.dart';

class ContenidoEditable extends StatelessWidget {
  final Contenido contenido;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  const ContenidoEditable({
    super.key,
    required this.contenido,
    required this.onEditar,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              contenido.tituloContenido,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (contenido.subtituloContenido.trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  contenido.subtituloContenido,
                  style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                ),
              ),
            const SizedBox(height: 8),
            Text(
              contenido.descripcionContenido,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onEditar,
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  label: const Text("Editar", style: TextStyle(color: Colors.blue)),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: onEliminar,
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text("Eliminar", style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
