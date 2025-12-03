import 'package:flutter/material.dart';

class MapArea extends StatelessWidget {
  const MapArea({
    super.key,
    required this.isActive,
    required this.showWarning,
  });

  final bool isActive;
  final bool showWarning;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorScheme.surfaceContainerHighest,
            colorScheme.outline.withValues(alpha: 0.2),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Current Location Marker
          Center(
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.onSurface.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 4,
                  ),
                ],
              ),
            ),
          ),
          // Offline Maps Badge
          if (!isActive)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surface.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colorScheme.outline),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.map,
                      size: 16,
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Mapas offline descargados ✅',
                      style: theme.textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
            ),
          // Navigation Instructions
          if (isActive)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_forward,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'En 200m',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                            Text(
                              'Gira a la derecha en \'Vereda El Mono\'',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // AI Warning
          if (isActive && showWarning)
            Positioned(
              top: 80,
              left: 16,
              right: 16,
              child: Card(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: colorScheme.onSecondary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'ADVERTENCIA: Descenso técnico en 500m. Modera tu velocidad.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // Camera FAB
          if (isActive)
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                onPressed: () {},
                backgroundColor: colorScheme.surface,
                child: Icon(
                  Icons.camera_alt,
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
