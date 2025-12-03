import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum MessageType { user, ai, route }

class Message {
  const Message({
    required this.type,
    required this.content,
    this.routeName,
    this.distance,
    this.elevation,
    this.terrainPercent,
    this.warnings,
  });

  final MessageType type;
  final String content;
  final String? routeName;
  final String? distance;
  final String? elevation;
  final String? terrainPercent;
  final List<String>? warnings;
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
  });

  final Message message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (message.type == MessageType.user) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(4),
            ),
          ),
          child: Text(
            message.content,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }

    if (message.type == MessageType.route) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          constraints: const BoxConstraints(maxWidth: 300),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message.routeName ?? '',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.surfaceContainerHighest,
                          colorScheme.outline.withValues(alpha: 0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _RouteStat(
                          icon: Icons.location_on,
                          value: message.distance ?? '',
                          colorScheme: colorScheme,
                        ),
                        _RouteStat(
                          icon: Icons.trending_up,
                          value: message.elevation ?? '',
                          colorScheme: colorScheme,
                        ),
                        _RouteStat(
                          icon: Icons.percent,
                          value: message.terrainPercent ?? '',
                          colorScheme: colorScheme,
                        ),
                      ],
                    ),
                  ),
                  if (message.warnings != null &&
                      message.warnings!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 16,
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Advertencias IA',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                    ...message.warnings!.map(
                      (warning) => Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: colorScheme.secondary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          warning,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () => context.go('/navigation'),
                    icon: const Icon(Icons.navigation),
                    label: const Text('Iniciar Navegación'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      foregroundColor: colorScheme.onSecondary,
                      minimumSize: const Size(double.infinity, 40),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: const BoxConstraints(maxWidth: 300),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Text(
          message.content,
          style: theme.textTheme.bodyMedium,
        ),
      ),
    );
  }
}

class _RouteStat extends StatelessWidget {
  const _RouteStat({
    required this.icon,
    required this.value,
    required this.colorScheme,
  });

  final IconData icon;
  final String value;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: colorScheme.onSurface, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}
