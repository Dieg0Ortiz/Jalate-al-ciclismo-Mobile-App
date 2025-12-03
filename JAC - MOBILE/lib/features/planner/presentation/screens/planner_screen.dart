import 'package:flutter/material.dart';
import '../widgets/chat_input.dart';
import '../widgets/message_bubble.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  final _controller = TextEditingController();
  final _messages = <Message>[];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _messages.add(
      const Message(
        type: MessageType.ai,
        content:
            '¡Hola! Estoy listo para planear tu próxima ruta. ¿Qué tienes en mente? (Ej: \'Ruta de 40km cerca de mi, con muchas subidas y en pavimento\').',
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        Message(
          type: MessageType.user,
          content: _controller.text.trim(),
        ),
      );
      _isLoading = true;
    });

    _controller.clear();

    // Simulate AI response
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.add(
          const Message(
            type: MessageType.ai,
            content: 'Analizando terreno y mapas de calor de tráfico... ⚙️',
          ),
        );
      });

      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _messages.removeLast();
          _messages.add(
            const Message(
              type: MessageType.route,
              content: '¡Listo! Encontré una ruta ideal:',
              routeName: 'Circuito Miradores y El Jobo',
              distance: '61.2 km',
              elevation: '850 m+',
              terrainPercent: '70% Terracería',
              warnings: [
                'Descenso técnico en km 45',
                'Cruces peligrosos en km 10 y 55',
                'Superficie: 70% Terracería (Recomendado: Bici de Montaña)',
              ],
            ),
          );
          _isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Copiloto IA',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Planificador de rutas inteligente',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return MessageBubble(message: message);
              },
            ),
          ),
          ChatInput(
            controller: _controller,
            isLoading: _isLoading,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}
