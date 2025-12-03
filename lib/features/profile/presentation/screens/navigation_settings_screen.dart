import 'package:flutter/material.dart';

class NavigationSettingsScreen extends StatelessWidget {
  const NavigationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración de Navegación'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Navegación por Voz'),
            subtitle: const Text('Instrucciones de voz durante la navegación'),
            value: true,
            onChanged: (value) {},
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Alertas de IA'),
            subtitle: const Text('Advertencias sobre terreno y condiciones'),
            value: true,
            onChanged: (value) {},
          ),
          const Divider(),
          ListTile(
            title: const Text('Unidades'),
            subtitle: const Text('Kilómetros'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            title: const Text('Modo de Pantalla'),
            subtitle: const Text('Siempre encendida'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
