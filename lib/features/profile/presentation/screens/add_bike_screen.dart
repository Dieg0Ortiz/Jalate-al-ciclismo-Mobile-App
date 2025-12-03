import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/bike.dart';
import '../bloc/bikes_bloc.dart';

class AddBikeScreen extends StatefulWidget {
  const AddBikeScreen({super.key});

  @override
  State<AddBikeScreen> createState() => _AddBikeScreenState();
}

class _AddBikeScreenState extends State<AddBikeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  BikeType _selectedType = BikeType.mountain;
  Color _selectedColor = Colors.black;

  final List<Color> _colors = [
    Colors.black,
    Colors.white,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.grey,
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    super.dispose();
  }

  void _saveBike() {
    if (_formKey.currentState!.validate()) {
      final newBike = Bike(
        id: const Uuid().v4(),
        name: _nameController.text,
        brand: _brandController.text,
        type: _selectedType,
        color: _selectedColor,
      );

      context.read<BikesBloc>().add(AddBike(newBike));
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Bicicleta')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre de la bicicleta',
                hintText: 'Ej. La Poderosa',
                prefixIcon: Icon(Icons.edit),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa el nombre';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _brandController,
              decoration: const InputDecoration(
                labelText: 'Marca',
                hintText: 'Ej. Trek, Specialized',
                prefixIcon: Icon(Icons.branding_watermark),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa la marca';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<BikeType>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Tipo de Bicicleta',
                prefixIcon: Icon(Icons.category),
              ),
              items: BikeType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(_getTypeName(type)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedType = value;
                  });
                }
              },
            ),
            const SizedBox(height: 24),
            Text('Color', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _colors.map((color) {
                final isSelected = _selectedColor == color;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = color;
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.outline,
                        width: 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: theme.colorScheme.primary.withOpacity(
                                  0.4,
                                ),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check,
                            color: color.computeLuminance() > 0.5
                                ? Colors.black
                                : Colors.white,
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveBike,
              child: const Text('Guardar Bicicleta'),
            ),
          ],
        ),
      ),
    );
  }

  String _getTypeName(BikeType type) {
    switch (type) {
      case BikeType.mountain:
        return 'Montaña';
      case BikeType.road:
        return 'Ruta';
      case BikeType.urban:
        return 'Urbana';
      case BikeType.gravel:
        return 'Gravel';
      case BikeType.electric:
        return 'Eléctrica';
      case BikeType.other:
        return 'Otra';
    }
  }
}
