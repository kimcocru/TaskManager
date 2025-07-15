
# TASK MANAGER

Aplicación escrita en Flutter para visualizar y administrar tareas, cuenta con creación, edición y eliminación de tareas, asi como, cambio te tema de claro a oscuro y descarga de las tareas a un archivo csv.

## Instrucciones para ejecutar el proyecto

1. Clonar el repositorio:
   ```bash
   git clone https://github.com/kimcocru/TaskManager.git
   ```

2. Se abre una terminal y se navega al proyecto flutter de la siguiente manera:
```bash
   cd task_manager
```

2. Correr comandos para actualizar dependencias y ejecutar:
```bash
   flutter pub get

   flutter run
   ```


## Comentarios sobre decisiones técnicas.

1. Para el tema de persistencia de datos elegí utilizar Sqflite porque me parece la manera más sencilla de abordarlo al ser una base de datos relacional, además de que nuestro proyecto es una aplicación bastante sencilla.
2. En cuento al manejo de estado, se proponía usar BLoC o Provider, hice la investigación respectiva y decidí hacerlo con la modalidad provider, porque de acuerdo a la descripción del caso de uso, donde se recomiendo su uso en aplicaciones relativamente simples, sin muchas pantallas, es facil de implementar y funciona bien con la arquitectura que eligí y que explico a continuacion...
3. Por último me gustaría mencionar que la arquitectura utilizada es MVVM con gestion de estado usando provider. Claramente tenemos definido un model, que sería la Tarea o Task, tenemos vistas en este caso nuestro HomeScreen y TaskFormScreen que uso del provider para obtencion y update de datos. Por ultimo tengo el provider que se comporta como ViewModel, se maneja la business logic y manipulacion de datos.


## Tareas Completadas.

1. Gestión de Tareas:
    - Crear, editar y eliminar tareas.
    - Marcar tareas como completadas.
    - Cada tarea incluye un titulo, descripcion es opcional y fecha limite es opcional
2. Filtros y Búsqueda:
    - Filtros por: Estado (Completadas, Pendientes) 
    - Barra de búsqueda para buscar tareas por título o descripción. 

3. Modo Offline: Implementado usando Sqflite.
4. Modo Oscuro: El app cuenta con un botón para cambiar entre modo claro y oscuro, esto se guarda en SharedPreferences, por lo tanto es persistente.
5. Exportación de Datos: El usuario cuenta con un botón para guardar las tareas en un archivo .csv
6. Se hace uso de ListView.builder para tener un buen performance a manera que la lista va creciendo.
7. Paginación, se agregó codigo para manejar paginacion cuando la lista es muy grande, limite es 20.
8. Se agregaron algunos unit tests para probar que se agregan , edita y elimina tareas de manera correcta.
