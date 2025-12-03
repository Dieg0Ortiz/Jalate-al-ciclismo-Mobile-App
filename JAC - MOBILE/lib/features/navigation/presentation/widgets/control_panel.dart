import 'package:flutter/material.dart';

class ControlPanel extends StatelessWidget {
  const ControlPanel({
    super.key,
    required this.isActive,
    required this.isPaused,
    required this.onStart,
    required this.onPause,
    required this.onStop,
  });

  final bool isActive;
  final bool isPaused;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: isActive
          ? Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onPause,
                    icon: Icon(
                      isPaused ? Icons.play_arrow : Icons.pause,
                    ),
                    label: Text(isPaused ? 'REANUDAR' : 'PAUSA'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onStop,
                    icon: const Icon(Icons.stop),
                    label: const Text('FINALIZAR'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.error,
                      foregroundColor: colorScheme.onError,
                      minimumSize: const Size(double.infinity, 56),
                    ),
                  ),
                ),
              ],
            )
          : ElevatedButton.icon(
              onPressed: onStart,
              icon: const Icon(Icons.play_arrow),
              label: const Text('INICIAR'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.surfaceContainerHighest,
                foregroundColor: colorScheme.onSurface,
                minimumSize: const Size(double.infinity, 64),
              ),
            ),
    );
  }
}
