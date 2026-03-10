import 'package:flutter/material.dart';
import 'package:vincu_app/controller/controladora.dart';
import 'package:vincu_app/model/archivo.dart';
import 'package:vincu_app/model/contenido.dart';
import 'package:vincu_app/model/departamento.dart';
import 'package:vincu_app/widgets/ContenidoCard.dart';
import 'package:vincu_app/widgets/enlacesCard.dart';

class HomeUser extends StatefulWidget {
  const HomeUser({super.key});

  @override
  State<HomeUser> createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> with TickerProviderStateMixin {
  List<Contenido> listaContenido = [];
  List<String> _tabs = [];
  List<String> _departamentos = [];
  String? _departamentoSeleccionado;
  bool _cargando = true;
  List<Archivo> listaEnlaces = [];


  late TabController _tabController;

  final Color morado = const Color(0xFF4B2E83);
  final Color amarillo = const Color(0xFFF5C400);
  final Color grisClaro = const Color(0xFFF5F5F5);
  final String fuenteTitulo = 'Montserrat';
  final String fuenteCuerpo = 'OpenSans';
  final control = Controladora();

  @override
  void initState() {
    super.initState();
    _cargarInicial();
    cargarEnlaces();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> cargarEnlaces() async {
    try {
      final enlaces = await control.cargarArchivos();
      setState(() {
        listaEnlaces = enlaces;
      });
    } catch (e) {
      print("Error al cargar enlaces: $e");
    }
  }

  Future<void> _cargarInicial() async {
    setState(() => _cargando = true);

    try {
      // 1. Primero esperamos a que los metadatos (tabs y departamentos) estén listos
      await _iniciarDatos();

      // 2. Luego cargamos el contenido inicial
      final contenidosIniciales = await control.cargarContenidos(
        onUpdate: (nuevosDatos) {
          if (mounted) {
            setState(() {
              listaContenido = nuevosDatos;
            });
          }
        },
      );

      if (mounted) {
        setState(() {
          listaContenido = contenidosIniciales;
          _cargando = false;
        });
      }
    } catch (e) {
      print("Error en carga inicial: $e");
      if (mounted) setState(() => _cargando = false);
    }
  }

  Future<void> _iniciarDatos() async {
    final pantallasUnicas = await control.cargarPantallas();
    final departamentosUnicos = await control.cargarDepartamentos();

    _tabs = [
      ...pantallasUnicas.map((p) => p.nombrePantalla).toList(), 
      'Enlaces',
      'Cronograma',
    ];
    _departamentos =
        departamentosUnicos.map((d) => d.nombreDepartamento).toList();

    if (_departamentos.isNotEmpty) {
      _departamentoSeleccionado ??= _departamentos.first;
    }

    // Inicializamos el controlador con la longitud real de los tabs obtenidos
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  Future<void> _reloadData() async {
    // No ponemos _cargando = true aquí para que el RefreshIndicator muestre su propia animación
    final departamentos = await control.cargarDepartamentos();

    final depSeleccionado = departamentos.firstWhere(
      (d) => d.nombreDepartamento == _departamentoSeleccionado,
      orElse: () => Departamento.defaultDepartamento(),
    );

    final nuevosContenidos = await control.cargarContenidosPorDepartamento(
      depSeleccionado.idDepartamento,
    );

    if (mounted) {
      setState(() {
        listaContenido = nuevosContenidos;
      });
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
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _reloadData,
            tooltip: 'Recargar Contenido',
          ),
        ],
        bottom:
            (_cargando || _tabs.isEmpty || _tabController.length == 0)
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
                'Japón App',
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
                onTap: () async {
                  setState(() {
                    _departamentoSeleccionado = dep;
                  });
                  Navigator.pop(context); // cerrar drawer
                  await _reloadData();
                },
              ),
            ),
          ],
        ),
      ),
      body:
          (_cargando || _tabs.isEmpty || _tabController.length == 0)
              ? Center(child: CircularProgressIndicator(color: morado))
              : TabBarView(
                controller: _tabController,
                children:
                    _tabs.map((pantalla) {
                      return _buildTabContent(pantalla);
                    }).toList(),
              ),
    );
  }

  Widget _buildTabContent(String pantallaSeleccionada) {
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

    if (pantallaSeleccionada == 'Enlaces') {
      final enlacesFiltrados = listaEnlaces
          .where((e) => e.departamentoArchivo.nombreDepartamento == _departamentoSeleccionado)
          .toList();
      return _buildEnlacesView(enlacesFiltrados);
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
      return RefreshIndicator(
        color: morado,
        onRefresh: _reloadData,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: 300),
            Center(
              child: Text(
                'No hay contenido para esta pantalla',
                style: TextStyle(
                  fontFamily: fuenteCuerpo,
                  fontSize: 16,
                  color: morado,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      color: morado,
      onRefresh: _reloadData,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: contenidosFiltrados.length,
        itemBuilder: (context, index) {
          return ContenidoCard(contenido: contenidosFiltrados[index]);
        },
      ),
    );
  }

  Widget _buildEnlacesView(List<Archivo> enlacesFiltrados) {
  if (enlacesFiltrados.isEmpty) {
    return RefreshIndicator(
      onRefresh: cargarEnlaces,
      color: morado,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 250),
          Center(
            child: Text(
              'No hay enlaces para este departamento.',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  return RefreshIndicator(
    onRefresh: cargarEnlaces,
    color: morado,
    child: ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: enlacesFiltrados.length,
      itemBuilder: (context, index) {
        return EnlacesCard(
          archivo: enlacesFiltrados[index],
        );
      },
    ),
  );
}
}
