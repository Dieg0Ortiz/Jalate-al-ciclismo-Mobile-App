import 'package:flutter/material.dart';

class ConnectionsScreen extends StatelessWidget {
  const ConnectionsScreen({
    super.key,
    required this.connectionType,
  });

  final String connectionType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isConnected = connectionType == 'strava';

    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle(connectionType)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isConnected ? Icons.check_circle : Icons.link_off,
                size: 80,
                color: isConnected
                    ? colorScheme.primary
                    : colorScheme.onSurface.withOpacity(0.5),
              ),
              const SizedBox(height: 24),
              Text(
                isConnected ? 'Conectado' : 'No Conectado',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isConnected
                    ? 'Tu cuenta está conectada correctamente'
                    : 'Conecta tu cuenta para sincronizar actividades',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 32),
              if (!isConnected)
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement connection
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text('Conectar'),
                )
              else
                OutlinedButton(
                  onPressed: () {
                    // TODO: Implement disconnection
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text('Desconectar'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTitle(String type) {
    switch (type) {
      case 'strava':
        return 'Strava';
      case 'garmin':
        return 'Garmin Connect';
      case 'komoot':
        return 'Komoot';
      default:
        return 'Conexión';
    }
  }
}
