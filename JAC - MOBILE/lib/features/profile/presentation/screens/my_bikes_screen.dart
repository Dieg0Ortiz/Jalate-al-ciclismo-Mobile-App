import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyBikesScreen extends StatelessWidget {
  const MyBikesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Bicicletas'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.directions_bike),
              title: const Text('Bicicleta de Montaña'),
              subtitle: const Text('Trek X-Caliber 8'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.directions_bike),
              title: const Text('Bicicleta de Ruta'),
              subtitle: const Text('Specialized Allez'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
