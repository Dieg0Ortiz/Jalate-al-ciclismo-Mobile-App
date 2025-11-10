# Core Module

Este módulo contiene código compartido y utilidades que son utilizadas por múltiples features.

## Estructura

```
core/
├── constants/      # Constantes de la aplicación (rutas, URLs, keys, etc.)
├── di/            # Configuración de inyección de dependencias
├── errors/        # Manejo centralizado de errores (exceptions y failures)
├── navigation/    # Configuración de rutas con go_router
├── theme/         # Temas Material You (light/dark) y ThemeBloc
├── utils/         # Utilidades reutilizables (responsive, validators, etc.)
└── widgets/       # Widgets reutilizables compartidos
```

## Reglas

- ✅ Todo el código aquí debe ser independiente de features específicas
- ✅ No debe contener lógica de negocio
- ✅ Debe ser fácilmente testeable
- ✅ Debe seguir principios SOLID

