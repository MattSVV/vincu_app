import 'package:flutter/material.dart';
import 'package:vincu_app/controller/controladora.dart';
import 'package:vincu_app/model/contenido.dart';
import 'package:vincu_app/widgets/ContenidoCard.dart';
import 'package:vincu_app/widgets/ContenidoEditable.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin>
    with SingleTickerProviderStateMixin {
  List<Contenido> listaContenido = [];
  List<String> _tabs = [];
  List<String> _departamentos = [];
  String? _departamentoSeleccionado;
  bool _cargando = true;
  String _modoActual = 'Vista';
  final List<String> _modos = ['Vista', 'Editar'];

  late TabController _tabController;

  final Color morado = const Color(0xFF4B2E83);
  final Color amarillo = const Color(0xFFF5C400);
  final Color grisClaro = const Color(0xFFF5F5F5);
  final String fuenteTitulo = 'Montserrat';
  final String fuenteCuerpo = 'OpenSans';

  @override
  void initState() {
    super.initState();
    _cargarContenido();
  }

  Future<void> _cargarContenido() async {
    setState(() => _cargando = true);

    try {
      final control = Controladora();
      final contenidos = await control.cargarContenidos();

      final pantallasUnicas =
          contenidos.map((c) => c.pantalla.nombrePantalla).toSet().toList();
      final departamentosUnicos =
          contenidos
              .map((c) => c.departamento.nombreDepartamento)
              .toSet()
              .toList();

      setState(() {
        listaContenido = contenidos;
        _tabs = [...pantallasUnicas, 'Cronograma'];
        _departamentos = departamentosUnicos;
        _departamentoSeleccionado ??= departamentosUnicos.first;
        _tabController = TabController(length: _tabs.length, vsync: this);
      });
    } catch (e) {
      print("Error al cargar contenidos: $e");
    } finally {
      setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grisClaro,
      appBar: AppBar(
        title: Text(
          'Inicio',
          style: TextStyle(fontFamily: fuenteTitulo, color: Colors.white),
        ),
        backgroundColor: morado,
        actions: [
          if (_departamentos.isNotEmpty)
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _modoActual,
                dropdownColor: morado,
                icon: Icon(Icons.edit, color: Colors.white),
                items:
                    _modos.map((modo) {
                      return DropdownMenuItem(
                        value: modo,
                        child: Text(
                          modo,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: fuenteTitulo,
                          ),
                        ),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _modoActual = value!;
                  });
                },
              ),
            ),
        ],
        bottom:
            _cargando
                ? null
                : TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorColor: amarillo,
                  labelColor: amarillo,
                  unselectedLabelColor: Colors.white70,
                  labelStyle: TextStyle(
                    fontFamily: fuenteTitulo,
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
                ),
      ),
      drawer: Drawer(
        backgroundColor: morado,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: morado),
              child: Text(
                'Vincu App',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: fuenteTitulo,
                ),
              ),
            ),
            ..._departamentos.map(
              (dep) => ListTile(
                title: Text(
                  dep,
                  style: TextStyle(
                    color:
                        dep == _departamentoSeleccionado
                            ? amarillo
                            : Colors.white,
                    fontFamily: fuenteTitulo,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                selected: dep == _departamentoSeleccionado,
                selectedTileColor: morado.withAlpha((0.2 * 255).round()),
                onTap: () {
                  setState(() {
                    _departamentoSeleccionado = dep;
                  });
                  Navigator.pop(context); // cerrar drawer
                },
              ),
            ),
          ],
        ),
      ),
      body:
          _cargando
              ? Center(child: CircularProgressIndicator(color: morado))
              : TabBarView(
                controller: _tabController,
                children:
                    _tabs.map((pantalla) {
                      return _buildTabContent(pantalla, _modoActual);
                    }).toList(),
              ),
    );
  }

  Widget _buildTabContent(String pantallaSeleccionada, String modoActual) {
    if (pantallaSeleccionada == 'Cronograma') {
      return Center(
        child: Text(
          'Aquí va el cronograma',
          style: TextStyle(
            fontFamily: fuenteTitulo,
            fontSize: 22,
            color: morado,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    final contenidosFiltrados =
        listaContenido
            .where(
              (c) =>
                  c.departamento.nombreDepartamento ==
                      _departamentoSeleccionado &&
                  c.pantalla.nombrePantalla == pantallaSeleccionada,
            )
            .toList();

    if (contenidosFiltrados.isEmpty) {
      return Column(
        children: [
          if (modoActual == 'Editar')
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Acción para agregar
                      print('Agregar nuevo contenido');
                    },
                    icon: Icon(Icons.add),
                    label: Text("Agregar", style: TextStyle(color: amarillo)),
                    style: ElevatedButton.styleFrom(backgroundColor: morado),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Acción para eliminar (podría estar deshabilitada aquí si no hay nada)
                      print('No hay contenido para eliminar');
                    },
                    icon: Icon(Icons.delete),
                    label: Text("Eliminar", style: TextStyle(color: amarillo)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Center(
              child: Text(
                'No hay contenido para esta pantalla',
                style: TextStyle(
                  fontFamily: fuenteCuerpo,
                  fontSize: 16,
                  color: morado,
                ),
              ),
            ),
          ),
        ],
      );
    }
    return Column(
      children: [
        if (modoActual == 'Editar')
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                // Acción para agregar
                print('Agregar nuevo contenido');
              },
              icon: Icon(Icons.add),
              label: Text("Agregar", style: TextStyle(color: amarillo)),
              style: ElevatedButton.styleFrom(backgroundColor: morado),
            ),
          ),
          Expanded(child: 
          ListView.builder(
      itemCount: contenidosFiltrados.length,
      itemBuilder: (context, index) {
        final contenido = contenidosFiltrados[index];
        if (modoActual == 'Editar') {
          return ContenidoEditable(
            contenido: contenido,
            onEditar: () {
              print("Editar contenido: ${contenido.tituloContenido}");
            },
            onEliminar: () {
              print("Eliminar contenido: ${contenido.tituloContenido}");
            },
          );
        }

        return ContenidoCard(contenido: contenidosFiltrados[index]);
      },
        )
        ) //Expandede
      ],
    );
  }
}
