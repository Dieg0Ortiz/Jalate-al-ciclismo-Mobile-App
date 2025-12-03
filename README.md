# Jalate al Ciclismo - Flutter App

Aplicación móvil de ciclismo con IA construida con Flutter 3.35+ siguiendo Clean Architecture y principios SOLID.

## 🚀 Inicio Rápido

```bash
cd "JAC - MOBILE"
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

## 📱 Características

- ✅ Clean Architecture con estructura feature-first
- ✅ Navegación avanzada con go_router
- ✅ Gestión de estado con Bloc
- ✅ Inyección de dependencias (get_it + injectable)
- ✅ Patrón Repository
- ✅ Material You design
- ✅ Responsive design
- ✅ Manejo de errores centralizado

## 📂 Estructura del Proyecto

```
JAC - MOBILE/
├── lib/
│   ├── core/              # Código compartido
│   │   ├── constants/    # Constantes
│   │   ├── di/           # Inyección de dependencias
│   │   ├── errors/       # Manejo de errores
│   │   ├── navigation/   # go_router
│   │   ├── theme/        # Material You theme
│   │   ├── utils/        # Utilidades
│   │   └── widgets/      # Widgets reutilizables
│   ├── features/         # Features organizadas por dominio
│   │   ├── auth/         # Autenticación
│   │   ├── home/         # Pantalla principal
│   │   ├── planner/      # Planificador IA
│   │   ├── navigation/   # Navegación/Grabación
│   │   ├── activity/     # Actividades
│   │   └── profile/      # Perfil y configuración
│   └── main.dart         # Punto de entrada
└── pubspec.yaml
```

## 📋 Requisitos

- Flutter 3.35 o superior
- Dart 3.0 o superior

## 📖 Documentación

- [INSTALLATION.md](JAC - MOBILE/INSTALLATION.md) - Guía de instalación detallada
- [MIGRATION_SUMMARY.md](JAC - MOBILE/MIGRATION_SUMMARY.md) - Resumen de la migración

## 🛠️ Desarrollo

Ver la documentación completa en `JAC - MOBILE/README.md` y `JAC - MOBILE/INSTALLATION.md`.
