import 'package:flutter/material.dart';

class ChatInput extends StatelessWidget {
  const ChatInput({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Describe tu ruta ideal...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onSubmitted: (_) => onSend(),
              enabled: !isLoading,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: isLoading ? null : onSend,
            icon: const Icon(Icons.send),
            style: IconButton.styleFrom(
              backgroundColor: colorScheme.surfaceContainerHighest,
              foregroundColor: colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
