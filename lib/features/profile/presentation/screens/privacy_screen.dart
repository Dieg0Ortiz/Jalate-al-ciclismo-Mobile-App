import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Política de Privacidad'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Política de Privacidad\n\n'
              'Última actualización: Octubre 2025\n\n'
              '1. Información que Recopilamos\n'
              'Recopilamos información que nos proporcionas directamente, como tu nombre, email y datos de tus actividades de ciclismo.\n\n'
              '2. Uso de la Información\n'
              'Utilizamos tu información para proporcionar y mejorar nuestros servicios, personalizar tu experiencia y enviarte notificaciones relevantes.\n\n'
              '3. Compartir Información\n'
              'No vendemos tu información personal. Solo compartimos datos con servicios de terceros cuando es necesario para el funcionamiento de la aplicación (como mapas y análisis).\n\n'
              '4. Seguridad\n'
              'Implementamos medidas de seguridad para proteger tu información personal.\n\n'
              '5. Tus Derechos\n'
              'Tienes derecho a acceder, modificar o eliminar tu información personal en cualquier momento.',
          style: theme.textTheme.bodyMedium,
        ),
      ),
    );
  }
}
