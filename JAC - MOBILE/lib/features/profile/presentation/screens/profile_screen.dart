import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../core/theme/theme_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes y Perfil'),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final user = state is AuthAuthenticated ? state.user : null;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Profile Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: colorScheme.primary,
                        child: Text(
                          user?.name.substring(0, 1).toUpperCase() ?? 'U',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.name ?? 'Usuario',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              user?.email ?? '',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => context.push('/profile/edit'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('Editar perfil'),
              ),
              const SizedBox(height: 24),
              _MenuSection(
                title: 'Mi Equipo',
                items: [
                  _MenuItem(
                    icon: Icons.directions_bike,
                    label: 'Mis Bicicletas',
                    badge: '2',
                    onTap: () => context.push('/profile/bikes'),
                  ),
                  _MenuItem(
                    icon: Icons.favorite,
                    label: 'Mis Sensores',
                    badge: '3',
                    onTap: () => context.push('/profile/sensors'),
                  ),
                ],
              ),
              _MenuSection(
                title: 'Conexiones',
                items: [
                  _MenuItem(
                    icon: Icons.link,
                    label: 'Strava',
                    badge: 'Conectado',
                    badgeColor: colorScheme.primary,
                    onTap: () => context.push('/profile/connections/strava'),
                  ),
                  _MenuItem(
                    icon: Icons.link,
                    label: 'Garmin Connect',
                    onTap: () => context.push('/profile/connections/garmin'),
                  ),
                  _MenuItem(
                    icon: Icons.link,
                    label: 'Komoot',
                    onTap: () => context.push('/profile/connections/komoot'),
                  ),
                ],
              ),
              _MenuSection(
                title: 'Aplicación',
                items: [
                  BlocBuilder<ThemeBloc, ThemeState>(
                    builder: (context, themeState) {
                      final isDark = themeState.themeMode == ThemeMode.dark;
                      return ListTile(
                        leading: Icon(
                          isDark ? Icons.dark_mode : Icons.light_mode,
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                        title: const Text('Modo Oscuro'),
                        trailing: Switch(
                          value: isDark,
                          onChanged: (value) {
                            context.read<ThemeBloc>().add(
                                  ThemeChanged(
                                    value ? ThemeMode.dark : ThemeMode.light,
                                  ),
                                );
                          },
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  _MenuItem(
                    icon: Icons.download,
                    label: 'Gestionar Mapas Offline',
                    onTap: () => context.push('/profile/maps'),
                  ),
                  _MenuItem(
                    icon: Icons.navigation,
                    label: 'Navegación',
                    onTap: () => context.push('/profile/navigation-settings'),
                  ),
                  _MenuItem(
                    icon: Icons.notifications,
                    label: 'Notificaciones',
                    onTap: () => context.push('/profile/notifications'),
                  ),
                  _MenuItem(
                    icon: Icons.help_outline,
                    label: 'Ayuda y Soporte',
                    onTap: () => context.push('/profile/help'),
                  ),
                ],
              ),
              _MenuSection(
                title: 'Legal',
                items: [
                  _MenuItem(
                    icon: Icons.description,
                    label: 'Términos de Servicio',
                    onTap: () => context.push('/profile/terms'),
                  ),
                  _MenuItem(
                    icon: Icons.shield,
                    label: 'Política de Privacidad',
                    onTap: () => context.push('/profile/privacy'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<AuthBloc>().add(const LogoutRequested());
                  context.go('/login');
                },
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar Sesión'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.error,
                  foregroundColor: colorScheme.onError,
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Versión 1.0.0 • Hecho con ❤️ para ciclistas',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  const _MenuSection({
    required this.title,
    required this.items,
  });

  final String title;
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ),
        Card(
          child: Column(
            children: items.map((item) {
              if (item is Divider) {
                return item;
              }
              return item;
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.badge,
    this.badgeColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? badge;
  final Color? badgeColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      leading: Icon(icon, color: colorScheme.onSurface.withOpacity(0.6)),
      title: Text(label),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: (badgeColor ?? colorScheme.surfaceContainerHighest)
                    .withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badge!,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: badgeColor ?? colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ),
          if (badge != null) const SizedBox(width: 8),
          Icon(
            Icons.chevron_right,
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}

