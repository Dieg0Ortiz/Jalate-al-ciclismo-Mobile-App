# Registro de Cambios y Desarrollo (Changelog)

Este documento registra cronológicamente las modificaciones, nuevas funcionalidades y mejoras técnicas implementadas en el proyecto **Jalate al Ciclismo**.

---

## [2025-12-03] - Mejoras en Edición de Perfil y Correcciones

### 🎯 Objetivo

Mejorar la experiencia de usuario en la pantalla de edición de perfil añadiendo selectores interactivos, uso de hardware del dispositivo y asegurando la compatibilidad multiplataforma.

### 🛠 Cambios Técnicos

#### 1. Edición de Perfil

- **Selector de Fecha**: Se implementó un calendario (`DatePicker`) para seleccionar la fecha de nacimiento de manera intuitiva.
- **Ubicación GPS**: Se añadió un botón para obtener la ubicación actual del usuario mediante GPS (`geolocator`, `geocoding`).
- **Foto de Perfil**: Se habilitó la opción de actualizar la foto de perfil tomando una foto o seleccionándola de la galería (`image_picker`).

#### 2. Correcciones y Compatibilidad

- **Soporte Web**: Se refactorizó el manejo de imágenes para usar `Uint8List` y `MemoryImage` en lugar de `File` (dart:io), permitiendo que la selección de fotos funcione correctamente en la versión Web.
- **Localización**: Se solucionó el error `No MaterialLocalizations found` añadiendo `flutter_localizations` y configurando los delegados en `main.dart`.

#### 3. Permisos

- Se configuraron los permisos necesarios en iOS (`Info.plist`) y Android (`AndroidManifest.xml`) para Cámara, Galería y Ubicación.

## [2025-12-03] - Selección de Tipo de Bicicleta y Optimización Global

### 🎯 Objetivo

Implementar la selección de tipo de bicicleta en el perfil y optimizar el código base para mejorar la mantenibilidad y estructura del proyecto.

### 🛠 Cambios Técnicos

#### 1. Selección de Tipo de Bicicleta

- **UI/UX**:
  - Se añadió un menú desplegable en `AddBikeScreen` para seleccionar tipos de bicicleta (Montaña, Ruta, Urbana, etc.).
  - Se implementó la lógica de selección de color con feedback visual (checkmark).
  - Se actualizó `MyBikesScreen` para mostrar el tipo de bicicleta junto a la marca.
- **Lógica**:
  - Se actualizó la entidad `Bike` y `BikesBloc` para persistir y gestionar el campo `type`.
  - Se corrigió un bug donde el color blanco aparecía seleccionado por defecto.

#### 2. Optimización Global del Código (Refactorización)

- **Feature Activity**:
  - Se extrajeron los widgets `ActivityCard` y `StatCard` de `ActivityScreen` para mejorar la modularidad.
- **Feature Navigation**:
  - Se extrajeron los widgets `MapArea`, `MetricsPanel` y `ControlPanel` de `NavigationScreen`.
- **Feature Planner**:
  - Se extrajeron los widgets `MessageBubble` y `ChatInput` de `PlannerScreen`.
- **General**:
  - Se refactorizaron las pantallas principales para utilizar los nuevos widgets extraídos, reduciendo significativamente el tamaño de los archivos y mejorando la legibilidad.

## [2025-12-02] - Refactorización del Home (Preparación Backend)

### 🎯 Objetivo

Transformar la pantalla de inicio (`HomeScreen`) de un prototipo estático a una arquitectura reactiva y escalable lista para conectarse a una API real.

### 🛠 Cambios Técnicos

#### 1. Arquitectura (Clean Architecture)

Se implementaron las 3 capas estándar para la feature `Home`:

- **Domain Layer (Reglas de Negocio)**:

  - `HomeData`: Entidad que agrupa toda la información del home (usuario, mensaje, rutas sugeridas).
  - `HomeRepository`: Contrato (interfaz) que define cómo se obtienen los datos.
  - `GetHomeData`: Caso de uso (UseCase) para solicitar la información.

- **Data Layer (Datos)**:

  - `HomeDataModel`: Modelo con capacidad de serialización JSON (usando `json_serializable`).
  - `HomeRemoteDataSource`: Fuente de datos. Actualmente simula una API (`Future.delayed`), pero está lista para usar `Dio`.
  - `HomeRepositoryImpl`: Implementación del repositorio que coordina la fuente de datos.

- **Presentation Layer (UI)**:
  - `HomeBloc`: Gestor de estado usando el patrón BLoC. Maneja los estados:
    - `HomeInitial`: Estado inicial.
    - `HomeLoading`: Cargando datos (spinner).
    - `HomeLoaded`: Datos listos para mostrar.
    - `HomeError`: Error al cargar (permite reintentar).
  - `HomeScreen`: Actualizada para usar `BlocBuilder` y reaccionar a los cambios de estado.

#### 2. Inyección de Dependencias

- Se registraron todas las nuevas clases (`DataSource`, `Repository`, `UseCase`, `Bloc`) en el sistema de inyección (`injectable`), asegurando un bajo acoplamiento.

#### 3. Correcciones

- Se solucionó un problema de serialización en `HomeDataModel` para manejar correctamente listas de objetos complejos (`suggestedRoutes`).

---
