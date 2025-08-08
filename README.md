# tasksandprojects

Tasks & Projects es una aplicación movil Flutter para la gestion sencilla de proyectos y tareas. Permite a los usuarios crear, editar y eliminar proyectos, asi como gestionar las tareas dentro de cada uno, marcarlas como completadas y visualizar estadísticas globales.

Decisiones de diseño y arquitectura

Gestión de estado:
Se utilizo Provider como solucion de gestion de estado por su simplicidad, integración nativa con Flutter y facilidad para separar la lógica de negocio de la UI. Provider es ideal para aplicaciones de tamaño pequeño a mediano y permite una arquitectura limpia y escalable.

Estructura del proyecto:
El codigo esta organizado en carpetas para modelos, gestion de estado (providers), repositorios, pantallas (screens) y widgets, siguiendo buenas practicas de separación de responsabilidades.

Simulacion de backend:
Los datos se gestionan en memoria mediante repositorios, facilitando el desarrollo y las pruebas sin necesidad de una API real.
