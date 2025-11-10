# Estructura del Proyecto

Este documento describe la organización completa del proyecto Flutter siguiendo Clean Architecture y principios feature-first.

## 📁 Estructura General

```
flutter_app/
├── lib/
│   ├── core/                    # Código compartido
│   │   ├── constants/          # Constantes de la app
│   │   ├── di/                 # Inyección de dependencias
│   │   ├── errors/             # Manejo de errores
│   │   ├── navigation/         # Configuración de rutas (go_router)
│   │   ├── theme/              # Temas Material You y ThemeBloc
│   │   ├── utils/              # Utilidades reutilizables
│   │   ├── widgets/            # Widgets reutilizables
│   │   └── README.md           # Documentación del módulo core
│   │
│   ├── features/               # Features organizadas por dominio
│   │   ├── auth/               # Autenticación
│   │   ├── home/               # Pantalla principal
│   │   ├── planner/            # Planificador de rutas IA
│   │   ├── navigation/         # Navegación y grabación
│   │   ├── activity/           # Actividades
│   │   ├── profile/            # Perfil y configuración
│   │   └── README.md           # Documentación del módulo features
│   │
│   └── main.dart               # Punto de entrada
│
├── pubspec.yaml
├── README.md
├── INSTALLATION.md
├── MIGRATION_SUMMARY.md
└── STRUCTURE.md                # Este archivo
```

## 🏗️ Estructura de cada Feature

Cada feature sigue la misma estructura de Clean Architecture:

```
feature_name/
├── domain/                     # Capa de Dominio (reglas de negocio)
│   ├── entities/              # Entidades del dominio
│   ├── repositories/          # Interfaces de repositorios
│   └── usecases/              # Casos de uso
│
├── data/                      # Capa de Datos (implementaciones)
│   ├── models/                # Modelos de datos (DTOs)
│   ├── datasources/           # Fuentes de datos
│   │   ├── local/            # Datasource local (SharedPreferences, etc.)
│   │   └── remote/           # Datasource remoto (API)
│   └── repositories/          # Implementaciones de repositorios
│
└── presentation/              # Capa de Presentación (UI)
    ├── bloc/                 # BLoC para gestión de estado
    ├── screens/              # Pantallas
    └── widgets/              # Widgets específicos de la feature
```

## 📦 Módulo Core

### `core/constants/`
Constantes globales de la aplicación:
- URLs de API
- Timeouts
- Storage keys
- Route names

### `core/di/`
Configuración de inyección de dependencias:
- `injection.dart`: Configuración principal
- `injection.config.dart`: Código generado por injectable
- `di_module.dart`: Módulos de dependencias

### `core/errors/`
Manejo centralizado de errores:
- `exceptions.dart`: Excepciones de la capa de datos
- `failures.dart`: Failures de la capa de dominio

### `core/navigation/`
Configuración de navegación:
- `app_router.dart`: Configuración de go_router con rutas protegidas

### `core/theme/`
Temas y gestión de tema:
- `app_theme.dart`: Definición de temas light/dark
- `theme_bloc.dart`: BLoC para gestión de tema
- `theme_event.dart`: Eventos del ThemeBloc
- `theme_state.dart`: Estados del ThemeBloc

### `core/utils/`
Utilidades reutilizables:
- `responsive.dart`: Utilidades para diseño responsive

### `core/widgets/`
Widgets reutilizables compartidos:
- `bottom_nav_bar.dart`: Barra de navegación inferior

## 🎯 Features

### `features/auth/`
**Autenticación de usuarios**
- Login con email/password
- Registro de usuarios
- Login social (Google, Apple, Strava) - estructura lista
- Logout
- Persistencia de sesión

**Estructura completa:**
- ✅ Domain: User entity, AuthRepository interface, UseCases
- ✅ Data: UserModel, AuthRemoteDataSource, AuthLocalDataSource, AuthRepositoryImpl
- ✅ Presentation: AuthBloc, LoginScreen, RegisterScreen, SocialLoginButton

### `features/home/`
**Pantalla principal con dashboard**
- Saludo personalizado
- Card de planificador IA
- Acceso rápido a iniciar pedaleo
- Rutas guardadas (carousel)
- Última actividad con estadísticas

**Estructura:**
- ✅ Presentation: HomeScreen, widgets (AiPlannerCard, RouteCard, LastActivityCard)
- 📁 Domain: Estructura creada (lista para implementar)
- 📁 Data: Estructura creada (lista para implementar)

### `features/planner/`
**Planificador de rutas con IA**
- Chat con copiloto IA
- Generación de rutas
- Visualización de rutas propuestas
- Advertencias de IA

**Estructura:**
- ✅ Presentation: PlannerScreen
- 📁 Domain: Estructura creada (lista para implementar)
- 📁 Data: Estructura creada (lista para implementar)

### `features/navigation/`
**Navegación y grabación de actividades**
- Grabación de rutas en tiempo real
- Navegación con mapas
- Instrucciones de navegación
- Advertencias de IA

**Estructura:**
- ✅ Presentation: NavigationScreen
- 📁 Domain: Estructura creada (lista para implementar)
- 📁 Data: Estructura creada (lista para implementar)

### `features/activity/`
**Listado y detalle de actividades**
- Lista de actividades guardadas
- Estadísticas de actividades
- Detalle de actividad individual
- Análisis de IA

**Estructura:**
- ✅ Presentation: ActivityScreen, ActivityDetailScreen
- 📁 Domain: Estructura creada (lista para implementar)
- 📁 Data: Estructura creada (lista para implementar)

### `features/profile/`
**Perfil de usuario y configuración**
- Perfil de usuario
- Edición de perfil
- Mis bicicletas
- Mis sensores
- Mapas offline
- Notificaciones
- Configuración de navegación
- Ayuda y soporte
- Conexiones
- Términos y condiciones
- Política de privacidad
- Toggle de tema (light/dark)

**Estructura:**
- ✅ Presentation: ProfileScreen y múltiples sub-pantallas
- 📁 Domain: Estructura creada (lista para implementar)
- 📁 Data: Estructura creada (lista para implementar)

## 🔄 Flujo de Dependencias

```
Presentation → Domain ← Data
     ↓           ↑
   BLoC      UseCases
     ↓           ↑
  Events    Repository (interface)
     ↓           ↑
  States    Repository (implementation)
                ↓
         DataSources
```

**Reglas:**
- ✅ Presentation depende de Domain (nunca de Data)
- ✅ Data depende de Domain (implementa interfaces)
- ✅ Domain no depende de nadie (es independiente)
- ✅ No hay dependencias directas entre features

## 📝 Convenciones

### Nomenclatura
- **Entities**: `User`, `Activity`, `Route`
- **Models**: `UserModel`, `ActivityModel`, `RouteModel`
- **Repositories**: `AuthRepository`, `ActivityRepository`
- **UseCases**: `LoginUseCase`, `GetActivitiesUseCase`
- **BLoC**: `AuthBloc`, `ActivityBloc`
- **Screens**: `LoginScreen`, `ActivityScreen`
- **Widgets**: `RouteCard`, `ActivityCard`

### Imports
- Imports relativos dentro de la misma feature
- Imports absolutos para core y otras features
- Ejemplo: `import 'package:jalate_al_ciclismo/core/theme/app_theme.dart';`

## ✅ Estado Actual

- ✅ Estructura completa de carpetas creada
- ✅ Todas las features tienen estructura domain/data/presentation
- ✅ Core module completamente organizado
- ✅ Documentación de estructura creada
- ✅ Imports verificados y funcionando
- ✅ Proyecto compila sin errores

## 🚀 Próximos Pasos

Para cada feature que solo tiene presentation:
1. Crear entidades en `domain/entities/`
2. Definir interfaces de repositorios en `domain/repositories/`
3. Implementar casos de uso en `domain/usecases/`
4. Crear modelos en `data/models/`
5. Implementar datasources en `data/datasources/`
6. Implementar repositorios en `data/repositories/`
7. Conectar BLoC con casos de uso en `presentation/bloc/`

