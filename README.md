# vincu_app

Este proyecto Flutter está diseñado para funcionar como una aplicación móvil que presenta contenido institucional distribuido en diferentes pantallas, departamentos y módulos. La aplicación combina conectividad remota mediante una API con persistencia local usando Hive, garantizando acceso a la información incluso sin conexión a internet.

☁️ Conexión con Servidor en la Nube
API Base URL: https://api-vinculacion-0309.onrender.com

La aplicación consume datos desde una API REST protegida con una API Key privada que se envía mediante un header en cada solicitud.

La base de datos en el backend es de tipo relacional (SQL).

🗃️ Arquitectura y Estructura del Proyecto
📦 Modelo Vista Controlador (MVC)
Modelos:

Contenido: Contiene los atributos titulo (obligatorio), subtitulo (opcional), descripcion (obligatorio), además de las relaciones con Departamento y Pantalla.

Departamento: Representa uno de los tres departamentos institucionales, utilizados para agrupar información en la app.

Pantalla: Representa una de las tres secciones gráficas que puede tener un departamento.

Usuario: Modelo pendiente de implementación. Permitirá a usuarios autorizados modificar la información, mientras que el acceso público será solo de lectura.


💾 Persistencia Local (Hive)
Se utiliza la base de datos Hive para persistencia de datos localmente.

Hive se inicializa en el directorio de soporte de la aplicación y se crean boxes específicas como contenidos para almacenar los datos.

Esto permite que la aplicación funcione sin conexión a internet, utilizando los datos almacenados localmente.

🧠 Controlador
El archivo controller contiene la clase Controladora, encargada de:

Verificar la conexión a internet.

Cargar los contenidos desde la API si hay conexión.

Guardar los contenidos localmente con Hive.

Recuperar los datos desde Hive si no hay conexión.

🌐 Router
El directorio router contiene las clases encargadas de hacer las solicitudes HTTP a la API para cada modelo (Contenido, Departamento, Pantalla, etc.).

Cada router incluye la lógica para parsear respuestas y mapear datos a sus respectivos modelos.

🔐 Acceso y Seguridad
La aplicación requiere una API Key para acceder a los endpoints protegidos.

El login es opcional, ya que el acceso a la información es libre para todos los usuarios.

El inicio de sesión será habilitado solo para los usuarios con privilegios de edición o administración.

🚧 Notas y Consideraciones
⚠️ La aplicación está en desarrollo activo y puede cambiar la estructura de los modelos según se vayan definiendo nuevas funcionalidades y requerimientos.

Se recomienda mantener una buena documentación de cada modelo y ruta para facilitar futuras integraciones.