import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:food_tracker/shared/models/food_entry.dart';

class FoodEntryForm extends StatefulWidget {
  final Function(FoodEntry) onSubmit;

  const FoodEntryForm({
    super.key,
    required this.onSubmit,
  });

  @override
  State<FoodEntryForm> createState() => _FoodEntryFormState();
}

class _FoodEntryFormState extends State<FoodEntryForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  bool _isVegetarian = true;
  String? _imageUrl;
  DateTime _selectedDate = DateTime.now();

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imageUrl = image.path;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final entry = FoodEntry(
        name: _nameController.text,
        category: _categoryController.text,
        isVegetarian: _isVegetarian,
        imageUrl: _imageUrl,
        timestamp: _selectedDate,
      );
      widget.onSubmit(entry);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Food Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a food name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _categoryController,
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a category';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Vegetarian'),
            value: _isVegetarian,
            onChanged: (bool value) {
              setState(() {
                _isVegetarian = value;
              });
            },
          ),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('Date and Time'),
            subtitle: Text(
              '${_selectedDate.toLocal()}'.split('.')[0],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    _selectedDate = picked;
                  });
                }
              },
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.photo),
            label: const Text('Add Image'),
          ),
          if (_imageUrl != null) ...[
            const SizedBox(height: 16),
            Image.network(
              _imageUrl!,
              height: 200,
              fit: BoxFit.cover,
            ),
          ],
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _submit,
            child: const Text('Save Entry'),
          ),
        ],
      ),
    );
  }
}
