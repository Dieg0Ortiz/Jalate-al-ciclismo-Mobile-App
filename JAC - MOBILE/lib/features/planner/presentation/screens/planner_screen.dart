import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  final _controller = TextEditingController();
  final _messages = <_Message>[];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _messages.add(const _Message(
      type: _MessageType.ai,
      content: '¡Hola! Estoy listo para planear tu próxima ruta. ¿Qué tienes en mente? (Ej: \'Ruta de 40km cerca de mi, con muchas subidas y en pavimento\').',
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _messages.add(_Message(
        type: _MessageType.user,
        content: _controller.text.trim(),
      ));
      _isLoading = true;
    });

    _controller.clear();

    // Simulate AI response
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.add(const _Message(
          type: _MessageType.ai,
          content: 'Analizando terreno y mapas de calor de tráfico... ⚙️',
        ));
      });

      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _messages.removeLast();
          _messages.add(const _Message(
            type: _MessageType.route,
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
          ));
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
                color: colorScheme.onSurface.withOpacity(0.7),
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
                return _MessageBubble(message: message);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                top: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Describe tu ruta ideal...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                    enabled: !_isLoading,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _isLoading ? null : _sendMessage,
                  icon: const Icon(Icons.send),
                  style: IconButton.styleFrom(
                      backgroundColor: colorScheme.surfaceContainerHighest,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum _MessageType { user, ai, route }

class _Message {
  const _Message({
    required this.type,
    required this.content,
    this.routeName,
    this.distance,
    this.elevation,
    this.terrainPercent,
    this.warnings,
  });

  final _MessageType type;
  final String content;
  final String? routeName;
  final String? distance;
  final String? elevation;
  final String? terrainPercent;
  final List<String>? warnings;
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final _Message message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (message.type == _MessageType.user) {
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

    if (message.type == _MessageType.route) {
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
                          color: colorScheme.onSurface.withOpacity(0.7),
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
                        colorScheme.outline.withOpacity(0.2),
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
                  if (message.warnings != null && message.warnings!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 16,
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Advertencias IA',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    ...message.warnings!.map((warning) => Container(
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: colorScheme.secondary.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            warning,
                            style: theme.textTheme.bodySmall,
                          ),
                        )),
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
          color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
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

