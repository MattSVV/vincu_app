📱 Vincu App – Sistema de Gestión de Vinculación IUJ 🎓

Vincu App es una plataforma móvil desarrollada en Flutter para la gestión, visualización y administración de contenido institucional del Instituto Universitario Japón.

La aplicación implementa una arquitectura robusta basada en MVC, permitiendo:

📖 Consulta pública de información institucional

🛠 Administración de contenido en tiempo real

🌐 Sincronización con API REST

💾 Funcionamiento Offline-First mediante Hive

🚀 Características Principales
👥 Dualidad de Perfiles
🔹 Vista Pública

Consulta de contenidos institucionales

Visualización por departamentos y pantallas

Acceso a enlaces externos

Navegación optimizada y responsive

🔹 Panel Administrativo

CRUD de contenidos

CRUD de enlaces (archivos externos)

Interfaz protegida

Sincronización inmediata con backend

🌐 Sincronización Inteligente

Consumo de API REST

Persistencia local con Hive

Modo Offline-First

Recuperación automática de datos cuando no hay conexión

🔗 Gestión de Enlaces Externos

Módulo especializado para:

Centralizar documentos

Gestionar repositorios

Acceso rápido a herramientas web

Abrir enlaces mediante url_launcher

🎨 Identidad Institucional

Colores oficiales

Iconografía personalizada

Splash Screen institucional

Tipografía coherente con la marca

🏗 Arquitectura del Proyecto
📦 Patrón de Diseño: MVC (Modelo – Vista – Controlador)

La lógica de negocio está desacoplada de la interfaz para facilitar mantenimiento y escalabilidad.

Componente	Descripción
Modelos	Contenido, Archivo (Enlaces), Departamento, Pantalla, Usuario
Vistas	Widgets para visualización pública y administración
Controlador	Controladora.dart gestiona lógica de red, validaciones y caché
Router	Clases por entidad para peticiones HTTP al backend
🗃 Stack Tecnológico
📱 Frontend

Flutter (Dart)

💾 Persistencia Local

Hive (NoSQL local)

🌐 Backend

Node.js

PostgreSQL

Hosting en Render

🔐 Seguridad

API Key mediante headers

Variables protegidas con flutter_dotenv

☁️ API & Conectividad
🔗 Base URL
https://api-vinculacion-0309.onrender.com
🔐 Seguridad

Header obligatorio: api-key

Sistema de filtrado de tokens para sesiones administrativas

Acceso público solo lectura

Acceso administrativo autenticado

📁 Estructura del Proyecto
lib/
│
├── model/
│   ├── contenido.dart
│   ├── archivo.dart
│   ├── departamento.dart
│   └── pantalla.dart
│
├── view/
│   ├── administrador/
│   └── usuario/
│
├── controller/
│   └── controladora.dart
│
├── router/
│
├── widgets/
│
├── hive/
│
└── main.dart
🧠 Controlador

La clase Controladora es el núcleo lógico del sistema:

Verifica conexión a internet

Consume la API remota

Guarda datos en Hive

Recupera datos en modo offline

Maneja mensajes de éxito y error

Orquesta interacción entre vistas y modelos

📁 Modelos Principales
📌 Contenido

Gestiona la información textual:

titulo

subtitulo

descripcion

idDepartamento

idPantalla

📌 Archivo (Enlaces)

Centraliza documentación externa:

nombreArchivo

urlArchivo

departamentoArchivo

📌 Usuario (En desarrollo)

Permitirá:

Control de roles (Admin / Editor)

Gestión avanzada de permisos

Auditoría de cambios

💾 Persistencia Local (Hive)

La aplicación utiliza Hive para:

Guardar contenidos cuando hay conexión

Mostrar datos sin conexión

Reducir consumo de red

Mejorar tiempos de carga

Inicialización en directorio de soporte del sistema.

🛠 Instalación y Configuración
1️⃣ Clonar el repositorio
git clone https://github.com/tu-usuario/vincu_app.git
2️⃣ Configurar variables de entorno

Crear archivo .env en la raíz del proyecto:

API_URL=https://api-vinculacion-0309.onrender.com
API_KEY=tu_clave_privada
3️⃣ Instalar dependencias
flutter pub get
4️⃣ Generar adaptadores Hive
dart run build_runner build
5️⃣ Ejecutar la aplicación
flutter run
🚧 Estado del Proyecto

 Arquitectura base MVC

 Integración Hive (Offline Mode)

 CRUD Contenidos

 CRUD Enlaces

 Identidad visual institucional

 Implementación completa de roles (Admin / Editor)

 Módulo de Cronograma dinámico

 Optimización de caché inteligente

🎯 Objetivo del Proyecto

Desarrollar una solución móvil institucional:

Escalable

Offline-First

Segura

Fácil de mantener

Lista para crecimiento modular

👨‍💻 Desarrollo

Proyecto desarrollado para el Instituto Universitario Japón.