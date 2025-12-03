import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bikes_bloc.dart';
import '../bloc/bikes_event.dart';

class AddBikeScreen extends StatefulWidget {
  const AddBikeScreen({super.key});

  @override
  State<AddBikeScreen> createState() => _AddBikeScreenState();
}

class _AddBikeScreenState extends State<AddBikeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  Color _selectedColor = Colors.black;
  String? _selectedType;

  final List<String> _bikeTypes = [
    'Montaña',
    'Ruta',
    'Urbana',
    'Pista',
    'BMX',
    'Gravel',
    'Eléctrica',
    'Infantil',
    'Otra',
  ];

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
    Colors.brown,
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<BikesBloc>().add(
            AddBike(
              name: _nameController.text,
              brand: _brandController.text,
              color: _selectedColor,
              type: _selectedType!,
            ),
          );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Bicicleta'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre de la bicicleta',
                hintText: 'Ej. Mi bici de montaña',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa un nombre';
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
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa la marca';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Tipo de Bicicleta',
                border: OutlineInputBorder(),
              ),
              items: _bikeTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor selecciona un tipo';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            const Text('Color',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _colors.map((color) {
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
                        color: _selectedColor == color
                            ? Theme.of(context).primaryColor
                            : Colors.grey.shade300,
                        width: _selectedColor == color ? 3 : 1,
                      ),
                      boxShadow: [
                        if (_selectedColor == color)
                          BoxShadow(
                            color: color.withOpacity(
                                0.4), // Changed withValues to withOpacity
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                      ],
                    ),
                    child: _selectedColor == color
                        ? Center(
                            child: Icon(
                              Icons.check,
                              color: color == Colors.white
                                  ? Colors.black
                                  : Colors.white,
                              size: 20,
                            ),
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Guardar Bicicleta'),
            ),
          ],
        ),
      ),
    );
  }
}
