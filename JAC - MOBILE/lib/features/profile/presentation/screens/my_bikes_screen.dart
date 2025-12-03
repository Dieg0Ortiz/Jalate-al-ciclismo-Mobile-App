import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bikes_bloc.dart';
import '../bloc/bikes_state.dart';
import 'add_bike_screen.dart';

class MyBikesScreen extends StatelessWidget {
  const MyBikesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Bicicletas'),
      ),
      body: BlocBuilder<BikesBloc, BikesState>(
        builder: (context, state) {
          if (state is BikesLoaded) {
            if (state.bikes.isEmpty) {
              return const Center(
                child: Text('No tienes bicicletas agregadas.'),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.bikes.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final bike = state.bikes[index];
                return Card(
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: bike.color.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.directions_bike,
                        color: bike.color,
                        size: 24,
                      ),
                    ),
                    title: Text(bike.name),
                    subtitle: Text('${bike.brand} • ${bike.type}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddBikeScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
