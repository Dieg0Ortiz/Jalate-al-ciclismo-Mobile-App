import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../navigation_provider.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  @override
  void initState() {
    super.initState();
    // Obtener ubicación actual al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NavigationProvider>().getCurrentLocation();
    });
  }

  void _handleStart() {
    final provider = context.read<NavigationProvider>();

    // Mostrar diálogo para nombre de ruta
    showDialog(
      context: context,
      builder: (context) => _RouteNameDialog(
        onSave: (name, description) {
          provider.startNavigation(
            routeName: name,
            // TODO: Pasar userId y eventId si están disponibles
          );
        },
      ),
    );
  }

  void _handlePause() {
    context.read<NavigationProvider>().togglePause();
  }

  void _handleStop() {
    // Mostrar diálogo de confirmación
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Finalizar ruta'),
        content: const Text('¿Deseas guardar esta ruta?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('CANCELAR'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showSaveRouteDialog();
            },
            child: const Text('GUARDAR'),
          ),
        ],
      ),
    );
  }

  void _showSaveRouteDialog() {
    showDialog(
      context: context,
      builder: (context) => _RouteNameDialog(
        onSave: (name, description) async {
          final provider = context.read<NavigationProvider>();
          await provider.stopNavigation(
            routeName: name,
            description: description,
            // TODO: Pasar userId y eventId si están disponibles
          );

          if (mounted) {
            context.go('/activity');
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Consumer<NavigationProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              // Google Maps
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: provider.currentLocation == null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 16),
                            Text(
                              'Obteniendo ubicación...',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      )
                    : GoogleMap(
                        onMapCreated: provider.onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: provider.currentLocation!,
                          zoom: 15,
                        ),
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        markers: provider.markers,
                        polylines: provider.polylines,
                        mapType: MapType.normal,
                        zoomControlsEnabled: false,
                      ),
              ),

              // Offline Maps Badge
              if (!provider.isActive)
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surface.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colorScheme.outline),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.map,
                          size: 16,
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Mapas offline descargados ✅',
                          style: theme.textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                ),

              // Navigation Instructions
              if (provider.isActive && provider.destination != null)
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_forward,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'En 200m',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurface.withOpacity(
                                      0.7,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Continúa recto',
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // AI Warning
              if (provider.isActive && provider.showWarning)
                Positioned(
                  top: 80,
                  left: 16,
                  right: 16,
                  child: Card(
                    color: colorScheme.errorContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: colorScheme.onErrorContainer,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'ADVERTENCIA: Descenso técnico en 500m. Modera tu velocidad.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onErrorContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Camera FAB
              if (provider.isActive)
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                    onPressed: () {
                      // TODO: Implementar captura de foto
                    },
                    backgroundColor: colorScheme.surface,
                    child: Icon(
                      Icons.camera_alt,
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),

              // Metrics Panel
              if (provider.isActive)
                Positioned(
                  bottom: 100,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: MetricsPanel(
                      currentSpeed: provider.currentSpeed,
                      distance: provider.distance,
                      time: provider.time,
                      elevation: provider.elevation,
                    ),
                  ),
                ),

              // Control Buttons
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ControlPanel(
                  isActive: provider.isActive,
                  isPaused: provider.isPaused,
                  onPause: _handlePause,
                  onStop: _handleStop,
                  onStart: _handleStart,
                ),
              ),

              // Error Message
              if (provider.errorMessage != null)
                Positioned(
                  top: 100,
                  left: 16,
                  right: 16,
                  child: Card(
                    color: colorScheme.errorContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: colorScheme.onErrorContainer,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              provider.errorMessage!,
                              style: TextStyle(
                                color: colorScheme.onErrorContainer,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              provider.clearError();
                            },
                            color: colorScheme.onErrorContainer,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Loading Overlay
              if (provider.isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _RouteNameDialog extends StatefulWidget {
  final Function(String name, String? description) onSave;

  const _RouteNameDialog({required this.onSave});

  @override
  State<_RouteNameDialog> createState() => _RouteNameDialogState();
}

class _RouteNameDialogState extends State<_RouteNameDialog> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nombre de la ruta'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nombre',
              hintText: 'Mi ruta en bici',
            ),
            autofocus: true,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Descripción (opcional)',
              hintText: 'Detalles sobre la ruta...',
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('CANCELAR'),
        ),
        FilledButton(
          onPressed: () {
            if (_nameController.text.isNotEmpty) {
              widget.onSave(
                _nameController.text,
                _descriptionController.text.isEmpty
                    ? null
                    : _descriptionController.text,
              );
              Navigator.of(context).pop();
            }
          },
          child: const Text('GUARDAR'),
        ),
      ],
    );
  }
}

class MetricsPanel extends StatelessWidget {
  const MetricsPanel({
    super.key,
    required this.currentSpeed,
    required this.distance,
    required this.time,
    required this.elevation,
  });

  final double currentSpeed;
  final double distance;
  final String time;
  final int elevation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              currentSpeed.toStringAsFixed(1),
              style: theme.textTheme.displayLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'km/h',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _MetricItem(
                  value: distance.toStringAsFixed(1),
                  label: 'km',
                  colorScheme: colorScheme,
                ),
                _MetricItem(
                  value: time,
                  label: 'tiempo',
                  colorScheme: colorScheme,
                ),
                _MetricItem(
                  value: elevation.toString(),
                  label: 'm+',
                  colorScheme: colorScheme,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  const _MetricItem({
    required this.value,
    required this.label,
    required this.colorScheme,
  });

  final String value;
  final String label;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
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

class ControlPanel extends StatelessWidget {
  const ControlPanel({
    super.key,
    required this.isActive,
    required this.isPaused,
    required this.onPause,
    required this.onStop,
    required this.onStart,
  });

  final bool isActive;
  final bool isPaused;
  final VoidCallback onPause;
  final VoidCallback onStop;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: isActive
          ? Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onPause,
                    icon: Icon(isPaused ? Icons.play_arrow : Icons.pause),
                    label: Text(isPaused ? 'REANUDAR' : 'PAUSA'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onStop,
                    icon: const Icon(Icons.stop),
                    label: const Text('FINALIZAR'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.error,
                      foregroundColor: colorScheme.onError,
                      minimumSize: const Size(double.infinity, 56),
                    ),
                  ),
                ),
              ],
            )
          : ElevatedButton.icon(
              onPressed: onStart,
              icon: const Icon(Icons.play_arrow),
              label: const Text('INICIAR'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                minimumSize: const Size(double.infinity, 64),
              ),
            ),
    );
  }
}
