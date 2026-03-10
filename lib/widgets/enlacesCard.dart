import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vincu_app/model/archivo.dart';

class EnlacesCard extends StatelessWidget {
  final Archivo archivo;

  const EnlacesCard({
    super.key,
    required this.archivo,
  });

  Future<void> _launchURL(BuildContext context) async {
    final Uri uri = Uri.tryParse(archivo.urlArchivo) ?? Uri();
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'No se pudo abrir el enlace';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Usamos LayoutBuilder para conocer el ancho disponible en tiempo real
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determinamos si es una pantalla ancha (Tablet/Desktop) o angosta (Phone)
        bool esPantallaAncha = constraints.maxWidth > 600;

        return Card(
          margin: EdgeInsets.symmetric(
            horizontal: esPantallaAncha ? constraints.maxWidth * 0.1 : 16, 
            vertical: 8
          ),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            onTap: () => _launchURL(context),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(esPantallaAncha ? 24 : 16),
              child: Row(
                children: [
                  // Contenedor del icono con tamaño responsivo
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4B2E83).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.open_in_new_rounded,
                      color: const Color(0xFF4B2E83),
                      size: esPantallaAncha ? 32 : 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Contenido de texto flexible
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          archivo.tituloArchivo,
                          style: TextStyle(
                            fontSize: esPantallaAncha ? 20 : 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat', // Coherente con tu HomeUser
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          archivo.urlArchivo,
                          style: TextStyle(
                            fontSize: esPantallaAncha ? 14 : 12,
                            color: Colors.blueGrey,
                            decoration: TextDecoration.underline,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Flecha indicadora (solo si hay espacio suficiente)
                  if (constraints.maxWidth > 300)
                    const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}