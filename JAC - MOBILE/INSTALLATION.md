# Instalación y Configuración

## Requisitos Previos

- Flutter 3.35 o superior
- Dart 3.0 o superior
- Android Studio / Xcode (para desarrollo móvil)

## Pasos de Instalación

1. **Clonar o navegar al proyecto:**
   ```bash
   cd flutter_app
   ```

2. **Instalar dependencias:**
   ```bash
   flutter pub get
   ```

3. **Generar código (para injectable, freezed, etc.):**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Ejecutar la aplicación:**
   ```bash
   flutter run
   ```

## Estructura del Proyecto

El proyecto sigue Clean Architecture con estructura feature-first:

```
lib/
├── core/                    # Código compartido
│   ├── constants/          # Constantes de la app
│   ├── errors/            # Manejo de errores
│   ├── navigation/        # Configuración de rutas
│   ├── theme/             # Temas Material You
│   ├── utils/             # Utilidades
│   ├── widgets/           # Widgets reutilizables
│   └── di/                # Inyección de dependencias
├── features/              # Features organizadas por dominio
│   ├── auth/             # Autenticación
│   ├── home/              # Pantalla principal
│   ├── planner/           # Planificador de rutas IA
│   ├── navigation/        # Navegación/Grabación
│   ├── activity/          # Actividades
│   └── profile/           # Perfil y configuración
└── main.dart             # Punto de entrada
```

## Características Implementadas

✅ Clean Architecture
✅ Feature-first structure
✅ go_router para navegación
✅ Bloc para gestión de estado
✅ Inyección de dependencias (get_it + injectable)
✅ Patrón Repository
✅ Material You design
✅ Responsive design
✅ Manejo de errores centralizado

## Notas

- La aplicación está configurada para usar Material You design system
- La navegación está protegida con autenticación
- Los datos se almacenan localmente usando SharedPreferences
- La estructura permite fácil escalabilidad y mantenimiento

