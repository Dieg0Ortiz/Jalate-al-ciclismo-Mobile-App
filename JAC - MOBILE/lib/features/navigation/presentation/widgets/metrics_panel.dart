import 'package:flutter/material.dart';

class MetricsPanel extends StatelessWidget {
  const MetricsPanel({
    super.key,
    required this.currentSpeed,
    required this.distance,
    required this.time,
    required this.elevation,
  });

  final double currentSpeed;
  final double distance;
  final String time;
  final int elevation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                currentSpeed.toStringAsFixed(1),
                style: theme.textTheme.displayLarge?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'km/h',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _MetricItem(
                    value: distance.toStringAsFixed(1),
                    label: 'km',
                    colorScheme: colorScheme,
                  ),
                  _MetricItem(
                    value: time,
                    label: 'tiempo',
                    colorScheme: colorScheme,
                  ),
                  _MetricItem(
                    value: elevation.toString(),
                    label: 'm+',
                    colorScheme: colorScheme,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  const _MetricItem({
    required this.value,
    required this.label,
    required this.colorScheme,
  });

  final String value;
  final String label;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}
