# Features Module

Este módulo contiene todas las features de la aplicación, organizadas siguiendo Clean Architecture y principios feature-first.

## Estructura de cada Feature

Cada feature debe seguir esta estructura:

```
feature_name/
├── domain/              # Capa de dominio (reglas de negocio)
│   ├── entities/       # Entidades del dominio
│   ├── repositories/   # Interfaces de repositorios
│   └── usecases/       # Casos de uso
├── data/               # Capa de datos (implementaciones)
│   ├── models/         # Modelos de datos (DTOs)
│   ├── datasources/    # Fuentes de datos (local y remoto)
│   └── repositories/   # Implementaciones de repositorios
└── presentation/       # Capa de presentación (UI)
    ├── bloc/          # BLoC para gestión de estado
    ├── screens/       # Pantallas
    └── widgets/       # Widgets específicos de la feature
```

## Features Actuales

- **auth**: Autenticación de usuarios (login, registro, logout)
- **home**: Pantalla principal con dashboard
- **planner**: Planificador de rutas con IA
- **navigation**: Navegación y grabación de actividades
- **activity**: Listado y detalle de actividades
- **profile**: Perfil de usuario y configuración

## Reglas

- ✅ Cada feature es independiente
- ✅ La comunicación entre features se hace a través de la capa de dominio
- ✅ No hay dependencias directas entre features
- ✅ Toda la lógica de negocio está en la capa de dominio
- ✅ La presentación solo maneja UI y eventos

