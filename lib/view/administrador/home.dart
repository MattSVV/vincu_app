/// -----------------------------------------------------------------------------
/// Archivo: home.dart
/// Descripción:
/// Pantalla principal para administradores en la aplicación Vincu App.
///
/// Esta pantalla permite a los administradores visualizar y gestionar el contenido
/// asignado a diferentes pantallas y departamentos. Incluye un modo de "Vista" para
/// observar el contenido y un modo "Editar" para agregar, modificar o eliminar elementos.
///
/// Características principales:
/// - Visualización dinámica de pestañas (TabBar) por pantalla.
/// - Filtro por departamento con Drawer lateral.
/// - Cambio entre modos "Vista" y "Editar".
/// - Soporte para carga dinámica de datos desde la clase `Controladora`.
/// - Composición modular del contenido por pantalla, con funciones separadas para:
///   - `_buildContenidoVista`: muestra el contenido de solo lectura.
///   - `_buildEditor`: permite agregar, editar o eliminar contenido.
/// - Gestión automática del ciclo de vida del `TabController`.
///
/// Autor: [Mateo Velasco y Mike Velasco]
/// -----------------------------------------------------------------------------
library;

import 'package:flutter/material.dart';
import 'package:vincu_app/controller/controladora.dart';
import 'package:vincu_app/model/contenido.dart';
import 'package:vincu_app/view/administrador/CreateAndUpdate/eliminarContenido.dart';
import 'package:vincu_app/widgets/ContenidoCard.dart';
import 'package:vincu_app/widgets/ContenidoEditable.dart';
import 'package:vincu_app/model/departamento.dart';
import 'package:vincu_app/model/pantalla.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> with TickerProviderStateMixin {
  List<Contenido> listaContenido = [];
  List<String> _tabs = [];
  List<String> _departamentos = [];
  String? _departamentoSeleccionado;
  bool _cargando = true;
  String _modoActual = 'Vista';
  final List<String> _modos = ['Vista', 'Editar'];
  bool _tabControllerInicializado = false;
  final control = Controladora();
  late List<Departamento> _listaDepartamentos;

  late TabController _tabController;

  final Color morado = const Color(0xFF4B2E83);
  final Color amarillo = const Color(0xFFF5C400);
  final Color grisClaro = const Color(0xFFF5F5F5);
  final String fuenteTitulo = 'Montserrat';
  final String fuenteCuerpo = 'OpenSans';

  @override
  void initState() {
    super.initState();
    cargarContenidoGeneral();
  }

  void _crearTabController() {
    if (_tabControllerInicializado) {
      _tabController.dispose();
      _tabControllerInicializado = false;
    }
    if (_tabs.isNotEmpty) {
      _tabController = TabController(length: _tabs.length, vsync: this);
      _tabControllerInicializado = true;
    }
  }

  @override
  void dispose() {
    if (_tabControllerInicializado) {
      _tabController.dispose();
    }
    super.dispose();
  }

  Future<void> cargarContenidoGeneral({bool soloDepartamento = false}) async {
  setState(() => _cargando = true);

  try {
    // Cargar departamentos y pantallas
    final departamentos = await control.cargarDepartamentos();
    final pantallas = await control.cargarPantallas();

    // Establecer departamentos únicos
    final departamentosUnicos = departamentos
        .map((d) => d.nombreDepartamento)
        .toSet()
        .toList();

    _departamentoSeleccionado ??=
        departamentosUnicos.isNotEmpty ? departamentosUnicos.first : null;

    // Obtener ID del departamento seleccionado
    final departamentoSeleccionado = departamentos.firstWhere(
      (d) => d.nombreDepartamento == _departamentoSeleccionado,
      orElse: () => Departamento.defaultDepartamento(),
    );

    // Obtener contenidos
    List<Contenido> contenidos;

    if (soloDepartamento) {
      contenidos = await control
          .cargarContenidosPorDepartamento(departamentoSeleccionado.idDepartamento);
    } else {
      contenidos = await control.cargarContenidos(
        onUpdate: (nuevosDatos) {
          setState(() {
            listaContenido = nuevosDatos;
          });
        },
      );
    }

    // Obtener pantallas únicas
    final pantallasUnicas = pantallas
        .map((p) => p.nombrePantalla)
        .toSet()
        .toList();

    // Actualizar estado
    setState(() {
      listaContenido = contenidos;
      _tabs = [...pantallasUnicas, 'Cronograma'];
      _departamentos = departamentosUnicos;
      _cargando = false;
    });
    _crearTabController();
  } catch (e) {
    print("Error al cargar contenido: $e");
    setState(() => _cargando = false);
  }
}

void _cambiarDepartamento(String nuevoDepartamento) async {
  setState(() {
    _departamentoSeleccionado = nuevoDepartamento;
  });
  Navigator.pop(context); // cerrar drawer
  await cargarContenidoGeneral(soloDepartamento: true);
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
            (_cargando || !_tabControllerInicializado)
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
                onTap: () => _cambiarDepartamento(dep),
              ),
            ),
          ],
        ),
      ),
      body: (_cargando || !_tabControllerInicializado)
          ? Center(child: CircularProgressIndicator(color: morado))
          : TabBarView(
              controller: _tabController,
              children: _tabs.map((pantalla) {
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

    final contenidosFiltrados = _filtrarContenidos(pantallaSeleccionada);

    if (modoActual == 'Vista') {
      return _buildContenidoVista(contenidosFiltrados);
    } else {
      return _buildEditor(contenidosFiltrados, pantallaSeleccionada);
    }
  }

  List<Contenido> _filtrarContenidos(String pantallaSeleccionada) {
    return listaContenido
        .where(
          (c) =>
              c.departamento.nombreDepartamento == _departamentoSeleccionado &&
              c.pantalla.nombrePantalla == pantallaSeleccionada,
        )
        .toList();
  }

  Widget _buildContenidoVista(List<Contenido> contenidosFiltrados) {
    if (contenidosFiltrados.isEmpty) {
      return Center(
        child: Text(
          'No hay contenido disponible para esta pantalla.',
          style: TextStyle(
            fontSize: 16,
            color: morado,
            fontFamily: fuenteCuerpo,
          ),
        ),
      );
    }
    return ListView.builder(
      itemCount: contenidosFiltrados.length,
      itemBuilder: (context, index) {
        final contenido = contenidosFiltrados[index];
        return ContenidoCard(contenido: contenido);
      },
    );
  }

  Widget _buildEditor(
    List<Contenido> contenidosFiltrados,
    String pantallaSeleccionada,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            onPressed: () async {
              final result = await Navigator.pushNamed(
                context,
                '/crearContenido',
                arguments: {
                  'pantalla': pantallaSeleccionada,
                  'departamento': _departamentoSeleccionado,
                },
              );
              if (result == true) {
                await control.mostrarMensaje("Contenido creado correctamente", context, 'success');
                await cargarContenidoGeneral(soloDepartamento: true);
              }
            },
            icon: Icon(Icons.add),
            label: Text("Agregar", style: TextStyle(color: amarillo)),
            style: ElevatedButton.styleFrom(backgroundColor: morado),
          ),
        ),
        if (contenidosFiltrados.isEmpty)
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
          )
        else
          Expanded(
            child: ListView.builder(
              itemCount: contenidosFiltrados.length,
              itemBuilder: (context, index) {
                final contenido = contenidosFiltrados[index];
                return ContenidoEditable(
                  contenido: contenido,
                  onEditar: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      '/actualizarContenido',
                      arguments: {
                        'id': contenido.idContenido,
                        'titulo': contenido.tituloContenido,
                        'subtitulo': contenido.subtituloContenido,
                        'descripcion': contenido.descripcionContenido,
                        'pantalla': contenido.pantalla.nombrePantalla,
                        'departamento':
                            contenido.departamento.nombreDepartamento,
                      },
                    );
                    if (result == true) {
                      await control.mostrarMensaje("Contenido actualizado correctamente", context, 'success');
                      await cargarContenidoGeneral(soloDepartamento: true);
                    }
                  },
                  onEliminar: () async {
  final result = await Navigator.of(context).push(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => AdvertenciaEliminar(
        onAceptar: (ctx) async {
          String respuesta = await control.eliminarContenido(contenido.idContenido);
          if (!ctx.mounted) return;
          if (respuesta == 'Contenido Eliminado') {
            Navigator.of(ctx).pop(true);
          } else {
            Navigator.of(ctx).pop(false);
          }
        },
      ),
    ),
  );

  if (result == true) {
    await control.mostrarMensaje("Contenido eliminado correctamente", context, 'success');
    await cargarContenidoGeneral(soloDepartamento: true);
  }
},
                );
              },
            ),
          ),
      ],
    );
  }
}
