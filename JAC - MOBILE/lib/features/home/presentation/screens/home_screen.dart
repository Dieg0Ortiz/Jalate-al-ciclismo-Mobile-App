import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../bloc/home_bloc.dart';
import '../widgets/route_card.dart';
import '../widgets/ai_planner_card.dart';
import '../widgets/last_activity_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeBloc>()..add(HomeStarted()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HomeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<HomeBloc>().add(HomeRefresh()),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (state is HomeLoaded) {
            final data = state.data;
            return RefreshIndicator(
              onRefresh: () async {
                context.read<HomeBloc>().add(HomeRefresh());
              },
              child: CustomScrollView(
                slivers: [
                  // App Bar
                  SliverAppBar(
                    expandedHeight: 120,
                    floating: false,
                    pinned: true,
                    backgroundColor: colorScheme.surface,
                    elevation: 0,
                    flexibleSpace: FlexibleSpaceBar(
                      titlePadding: const EdgeInsets.only(left: 16, bottom: 12),
                      title: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '¡Hola, ${data.userName}!',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            data.welcomeMessage,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      IconButton(
                        icon: Stack(
                          children: [
                            Icon(Icons.notifications_outlined,
                                color: colorScheme.onSurface,),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainerHighest,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                        onPressed: () => context.push('/profile/notifications'),
                      ),
                    ],
                  ),
                  // Content
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        const SizedBox(height: 8),
                        // AI Planner Card
                        const AiPlannerCard(),
                        const SizedBox(height: 16),
                        // Quick Start
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Acceso Rápido',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: () => context.go('/navigation'),
                                  icon: const Icon(Icons.play_arrow),
                                  label: const Text('INICIAR PEDALEO 🚵'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        colorScheme.surfaceContainerHighest,
                                    foregroundColor: colorScheme.onSurface,
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Saved Routes
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Mis Rutas Guardadas',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text('Ver todas'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 250,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: data.suggestedRoutes.length,
                            itemBuilder: (context, index) {
                              final route = data.suggestedRoutes[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: RouteCard(
                                  name: route.name,
                                  distance: route.distance,
                                  elevation: route.elevation,
                                  terrainPercent: route.terrainPercent,
                                  aiWarning: route.aiWarning,
                                  imageUrl: route.imageUrl,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Last Activity
                        const LastActivityCard(),
                        const SizedBox(height: 80), // Space for bottom nav
                      ]),
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

