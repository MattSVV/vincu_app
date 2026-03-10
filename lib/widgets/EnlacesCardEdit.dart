import 'package:flutter/material.dart';
import 'package:vincu_app/model/archivo.dart';

class EnlacesCardEdit extends StatelessWidget {
  final Archivo archivo;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  const EnlacesCardEdit({
    super.key,
    required this.archivo,
    required this.onEditar,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              archivo.tituloArchivo,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              archivo.urlArchivo,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.blueGrey,
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onEditar,
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  label: const Text(
                    "Editar",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: onEliminar,
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text(
                    "Eliminar",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}