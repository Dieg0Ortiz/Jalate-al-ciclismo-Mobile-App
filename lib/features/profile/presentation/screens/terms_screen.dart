import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Términos de Servicio'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Términos de Servicio\n\n'
              'Última actualización: Octubre 2025\n\n'
              '1. Aceptación de los Términos\n'
              'Al acceder y utilizar la aplicación Jalate al ciclismo Mobile App, aceptas cumplir con estos términos de servicio.\n\n'
              '2. Uso de la Aplicación\n'
              'La aplicación está diseñada para ayudarte a planear rutas de ciclismo y registrar tus actividades.\n\n'
              '3. Responsabilidad\n'
              'El usuario es responsable de su seguridad mientras utiliza la aplicación durante sus actividades de ciclismo.\n\n'
              '4. Privacidad\n'
              'Respetamos tu privacidad. Consulta nuestra Política de Privacidad para más información.\n\n'
              '5. Modificaciones\n'
              'Nos reservamos el derecho de modificar estos términos en cualquier momento.',
          style: theme.textTheme.bodyMedium,
        ),
      ),
    );
  }
}