# Jalate al ciclismo Mobile App

Aplicación móvil de ciclismo con IA construida con Flutter 3.35+ siguiendo Clean Architecture y principios SOLID.

## Arquitectura

El proyecto sigue una arquitectura limpia (Clean Architecture) con estructura feature-first:

```
lib/
├── core/                    # Código compartido
│   ├── constants/
│   ├── errors/
│   ├── network/
│   ├── theme/
│   ├── utils/
│   └── widgets/
├── features/                # Features organizadas por dominio
│   ├── auth/
│   ├── home/
│   ├── planner/
│   ├── navigation/
│   ├── activity/
│   └── profile/
└── main.dart
```

Cada feature contiene:
- `domain/`: Entidades, interfaces de repositorios, casos de uso
- `data/`: Implementaciones de repositorios, modelos, fuentes de datos
- `presentation/`: Pantallas, widgets, BLoC

## Características

- ✅ Clean Architecture
- ✅ Feature-first structure
- ✅ go_router para navegación
- ✅ Bloc para gestión de estado
- ✅ Inyección de dependencias (get_it + injectable)
- ✅ Patrón Repository
- ✅ Material You design
- ✅ Responsive design
- ✅ Animaciones suaves

## Requisitos

- Flutter 3.35 o superior
- Dart 3.0 o superior

## Instalación

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

## Ejecución

```bash
flutter run
```

