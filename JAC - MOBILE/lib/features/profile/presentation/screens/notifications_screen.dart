import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Notificaciones Push'),
            subtitle: const Text('Recibir notificaciones en tiempo real'),
            value: true,
            onChanged: (value) {},
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Recordatorios de Actividad'),
            subtitle: const Text('Te recordamos cuando no has salido a rodar'),
            value: true,
            onChanged: (value) {},
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Alertas de Seguridad'),
            subtitle: const Text('Advertencias de IA sobre rutas'),
            value: true,
            onChanged: (value) {},
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Logros y Estadísticas'),
            subtitle: const Text('Notificaciones sobre tus logros'),
            value: false,
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }
}
