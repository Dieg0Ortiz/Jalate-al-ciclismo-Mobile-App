import 'package:flutter/material.dart';

import '../widgets/activity_card.dart';
import '../widgets/stat_card.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mis Actividades',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Historial y análisis',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Recientes'),
            Tab(text: 'Estadísticas'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_RecentActivitiesTab(), _StatsTab()],
      ),
    );
  }
}

class _RecentActivitiesTab extends StatelessWidget {
  final _activities = [
    {
      'id': '1',
      'name': 'Circuito Matutino El Jobo',
      'date': '21 Oct 2025',
      'distance': '42.3 km',
      'time': '1:45:32',
      'elevation': '520 m',
      'avgSpeed': '24.1 km/h',
      'aiInsight':
          '¡Gran esfuerzo en la subida \'El Jobo\'! Tu ritmo fue constante.',
      'imageUrl':
          'https://images.unsplash.com/photo-1534787238916-9ba6764efd4f?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8Y2ljbGlzbW98ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&q=60&w=900',
    },
    {
      'id': '2',
      'name': 'Ruta de Carretera - Chiapa',
      'date': '19 Oct 2025',
      'distance': '68.5 km',
      'time': '2:30:15',
      'elevation': '890 m',
      'avgSpeed': '27.4 km/h',
      'aiInsight':
          'Excelente mejora en tu cadencia. Mantén este ritmo en subidas largas.',
      'imageUrl':
          'https://images.unsplash.com/photo-1600403477955-2b8c2cfab221?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1740',
    },
    {
      'id': '3',
      'name': 'Exploración Cañón del Sumidero',
      'date': '15 Oct 2025',
      'distance': '35.8 km',
      'time': '1:25:45',
      'elevation': '420 m',
      'avgSpeed': '25.0 km/h',
      'aiInsight': 'Buena recuperación después de tu ruta larga del sábado.',
      'imageUrl':
          'https://images.unsplash.com/photo-1516147697747-02adcafd3fda?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1844',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _activities.length,
      itemBuilder: (context, index) {
        final activity = _activities[index];
        return ActivityCard(activity: activity);
      },
    );
  }
}

class _StatsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Esta Semana',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest.withOpacity(
                          0.3,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Oct 16-22',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 2,
                  children: [
                    StatCard(label: 'Distancia Total', value: '146.6 km'),
                    StatCard(label: 'Tiempo Total', value: '5:41:32'),
                    StatCard(label: 'Salidas', value: '3'),
                    StatCard(label: 'Desnivel', value: '1,830 m'),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Este Mes',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest.withOpacity(
                          0.3,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Octubre',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 2,
                  children: [
                    StatCard(label: 'Distancia Total', value: '542.3 km'),
                    StatCard(label: 'Tiempo Total', value: '21:15:45'),
                    StatCard(label: 'Salidas', value: '12'),
                    StatCard(label: 'Desnivel', value: '6,240 m'),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  size: 32,
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Resumen IA del Mes',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Has mejorado un 12% en tu velocidad promedio comparado con el mes pasado. Tus subidas son más eficientes y tu recuperación ha mejorado notablemente. ¡Sigue así!',
                        style: theme.textTheme.bodySmall?.copyWith(
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
      ],
    );
  }
}
