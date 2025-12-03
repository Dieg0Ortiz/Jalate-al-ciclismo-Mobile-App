import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../navigation/presentation/navigation_provider.dart';
import 'route_gemini_service.dart' as gemini;

enum MessageType { user, ai, route }

class ChatMessage {
  const ChatMessage({
    required this.type,
    required this.content,
    this.routeData,
  });

  final MessageType type;
  final String content;
  final gemini.RouteData? routeData;
}

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  final _controller = TextEditingController();
  final _messages = <ChatMessage>[];
  final _aiService = gemini.RouteGeminiService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _messages.add(
      const ChatMessage(
        type: MessageType.ai,
        content:
            '¡Hola! Soy tu copiloto IA especializado en rutas de Tuxtla Gutiérrez. '
            'Puedo ayudarte a encontrar la ruta perfecta según tus preferencias.\n\n'
            'Ejemplo: "Quiero una ruta de 40km con muchas subidas" o "Ruta fácil al Cañón del Sumidero"',
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    final userMessage = _controller.text.trim();

    setState(() {
      _messages.add(ChatMessage(type: MessageType.user, content: userMessage));
      _isLoading = true;
    });

    _controller.clear();

    try {
      // Mostrar mensaje de "pensando"
      setState(() {
        _messages.add(
          const ChatMessage(
            type: MessageType.ai,
            content: 'Analizando las mejores rutas en Tuxtla Gutiérrez... 🤔',
          ),
        );
      });

      // Llamar a Gemini AI
      final response = await _aiService.generateRoute(userMessage);

      setState(() {
        // Remover mensaje de "pensando"
        _messages.removeLast();

        if (response.route != null) {
          // Agregar mensaje con la ruta
          _messages.add(
            ChatMessage(
              type: MessageType.route,
              content: response.message,
              routeData: response.route,
            ),
          );
        } else {
          // Solo respuesta de texto
          _messages.add(
            ChatMessage(type: MessageType.ai, content: response.message),
          );
        }

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.removeLast();
        _messages.add(
          ChatMessage(
            type: MessageType.ai,
            content:
                'Lo siento, hubo un error al procesar tu solicitud. '
                'Por favor intenta de nuevo. Error: $e',
          ),
        );
        _isLoading = false;
      });
    }
  }

  void _startNavigationWithRoute(gemini.RouteData routeData) {
    // ✅ Usar prefijo
    final navigationProvider = context.read<NavigationProvider>();

    // Configurar la ruta en el provider de navegación
    navigationProvider.setDestination(
      routeData.destination,
      destinationName: routeData.name,
    );

    // Si hay waypoints, configurarlos también
    // TODO: Implementar setWaypoints en NavigationProvider si lo necesitas

    // Navegar a la pantalla de navegación
    context.go('/navigation');

    // Mostrar snackbar de confirmación
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ruta "${routeData.name}" cargada en el mapa'),
        duration: const Duration(seconds: 2),
      ),
    );
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
              'Planificador de rutas en Tuxtla',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Sobre el Copiloto IA'),
                  content: const Text(
                    'Este asistente usa inteligencia artificial para generar rutas '
                    'personalizadas en Tuxtla Gutiérrez y alrededores.\n\n'
                    'Menciona tu preferencia de:\n'
                    '• Distancia (km)\n'
                    '• Dificultad (fácil, intermedio, difícil)\n'
                    '• Terreno (pavimento, terracería, mixto)\n'
                    '• Destinos (Cañón del Sumidero, Chiapa de Corzo, etc.)',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('ENTENDIDO'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return MessageBubble(
                  message: message,
                  onStartNavigation: message.routeData != null
                      ? () => _startNavigationWithRoute(message.routeData!)
                      : null,
                );
              },
            ),
          ),
          if (_isLoading) const LinearProgressIndicator(),
          ChatInput(
            controller: _controller,
            isLoading: _isLoading,
            onSubmitted: _sendMessage,
            onChanged: (_) => setState(() {}),
            onClear: () => setState(() => _controller.clear()),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    this.onStartNavigation,
  });

  final ChatMessage message;
  final VoidCallback? onStartNavigation;

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
          constraints: const BoxConstraints(maxWidth: 300),
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(4),
            ),
          ),
          child: Text(
            message.content,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onPrimary,
            ),
          ),
        ),
      );
    }

    if (message.type == MessageType.route && message.routeData != null) {
      final route = message.routeData!;

      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          constraints: const BoxConstraints(maxWidth: 320),
          child: Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        size: 20,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          message.content,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    route.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Chip(
                    label: Text(route.difficulty),
                    avatar: Icon(
                      _getDifficultyIcon(route.difficulty),
                      size: 16,
                    ),
                    backgroundColor: _getDifficultyColor(
                      route.difficulty,
                      colorScheme,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.primaryContainer,
                          colorScheme.primaryContainer.withOpacity(0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _RouteStat(
                          icon: Icons.straighten,
                          label: 'Distancia',
                          value: route.distance,
                          colorScheme: colorScheme,
                        ),
                        _RouteStat(
                          icon: Icons.terrain,
                          label: 'Elevación',
                          value: route.elevation,
                          colorScheme: colorScheme,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.landscape,
                        size: 16,
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Terreno: ${route.terrain}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  if (route.warnings.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 16,
                          color: colorScheme.error,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Advertencias',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    ...route.warnings.map(
                      (warning) => Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.errorContainer.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: colorScheme.error.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 14,
                              color: colorScheme.error,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                warning,
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onStartNavigation,
                      icon: const Icon(Icons.navigation),
                      label: const Text('Cargar en Mapa'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
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
          color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Text(message.content, style: theme.textTheme.bodyMedium),
      ),
    );
  }

  IconData _getDifficultyIcon(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'fácil':
      case 'facil':
        return Icons.sentiment_satisfied;
      case 'intermedio':
        return Icons.sentiment_neutral;
      case 'difícil':
      case 'dificil':
        return Icons.sentiment_very_dissatisfied;
      default:
        return Icons.help_outline;
    }
  }

  Color _getDifficultyColor(String difficulty, ColorScheme colorScheme) {
    switch (difficulty.toLowerCase()) {
      case 'fácil':
      case 'facil':
        return Colors.green.withOpacity(0.3);
      case 'intermedio':
        return Colors.orange.withOpacity(0.3);
      case 'difícil':
      case 'dificil':
        return Colors.red.withOpacity(0.3);
      default:
        return colorScheme.surfaceContainerHighest;
    }
  }
}

class _RouteStat extends StatelessWidget {
  const _RouteStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.colorScheme,
  });

  final IconData icon;
  final String label;
  final String value;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: colorScheme.primary, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}

class ChatInput extends StatelessWidget {
  const ChatInput({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.onSubmitted,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onSubmitted;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
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
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Ej: Ruta de 40km con subidas...',
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: onClear,
                      )
                    : null,
              ),
              onSubmitted: (_) => onSubmitted(),
              onChanged: onChanged,
              enabled: !isLoading,
              maxLines: null,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: isLoading ? null : onSubmitted,
            icon: Icon(isLoading ? Icons.hourglass_empty : Icons.send),
            style: IconButton.styleFrom(
              backgroundColor: isLoading
                  ? colorScheme.surfaceContainerHighest.withOpacity(0.5)
                  : colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              disabledBackgroundColor: colorScheme.surfaceContainerHighest,
            ),
          ),
        ],
      ),
    );
  }
}
