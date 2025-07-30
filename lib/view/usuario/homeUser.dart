import 'package:flutter/material.dart';
import 'package:vincu_app/controller/controladora.dart';
import 'package:vincu_app/model/contenido.dart';
import 'package:vincu_app/widgets/ContenidoCard.dart';

class HomeUser extends StatefulWidget {
  const HomeUser({super.key});

  @override
  State<HomeUser> createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser>
    with SingleTickerProviderStateMixin {
  List<Contenido> listaContenido = [];
  List<String> _tabs = [];
  List<String> _departamentos = [];
  String? _departamentoSeleccionado;
  bool _cargando = true;

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
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _cargarInicial() async {
    setState(() => _cargando = true);

    await _iniciarDatos();

    // Cargar datos locales primero, y actualizar si hay nuevos
    final contenidosIniciales = await control.cargarContenidos(
      onUpdate: (nuevosDatos) {
        setState(() {
          listaContenido = nuevosDatos;
        });
      },
    );

    setState(() {
      listaContenido = contenidosIniciales;
      _cargando = false;
    });
  }

  Future<void> _iniciarDatos() async {
    final pantallasUnicas = await control.cargarPantallas();
    final departamentosUnicos = await control.cargarDepartamentos();

    _tabs = [...pantallasUnicas.map((p) => p.nombrePantalla).toList(), 'Cronograma'];
    _departamentos = departamentosUnicos.map((d)=> d.nombreDepartamento).toList();
    _departamentoSeleccionado ??= _departamentos.first;

    _tabController = TabController(length: _tabs.length, vsync: this);
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
            onPressed: _cargarInicial,
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
      return Expanded(
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
          );
    }
    return ListView.builder(
      itemCount: contenidosFiltrados.length,
      itemBuilder: (context, index) {
        return ContenidoCard(contenido: contenidosFiltrados[index]);
      },
    );
  }
}
