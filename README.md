# tasksandprojects

Esta es una aplicación movil para la gestión de proyectos y tareas. Permite a los usuarios crear, editar y eliminar proyectos, asi como gestionar las tareas dentro de cada uno, marcarlas como completadas y visualizar estadisticas globales

Decisiones de diseño y arquitectura

Gestión de estado:
Acostumbro usar provider como solución de gestion de estado por su simplicidad, integración y facilidad para separar la lógica de negocio de la UI. Siento que es ideal para aplicaciones de tamaño pequeño a mediano y permite una arquitectura limpia y escalable

para otros casos, en los que la aplicacion escala, uso cubit o Bloc, dependiendo de la escalabilidad, ya que cubit tiende a requerir menos codigo y es mas ligero, pero igual forma parte del paquete Bloc

Estructura del proyecto:
El código esta organizado en carpetas para modelos, gestión de estado (providers), repositorios, pantallas (screens) y widgets, siguiendo buenas practicas de separación de responsabilidades

Simulacion de backend:
Los datos se gestionan en memoria mediante repositorios, facilitando el desarrollo y las pruebas sin necesidad de una API real.

Futuras mejoras:
- Implementaria una persistencia local de datos, como por ejemplo: hive o SQLite, aunque me parece que Hive requiere menos codigo
- Autenticación segura
- Busqueda para listas extensas de proyectos/tareas
- Mejoras en la experiencia de usuario y diseño visual
- Mejor manejo de errores
- Colaboración entre varios usuarios para equipos, estilo notion, seria genial jajaja o compartir la tarea por otros medio, como gmail, o whatsapp, etc.