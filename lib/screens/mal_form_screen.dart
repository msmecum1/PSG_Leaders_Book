import 'package:flutter/material.dart';

class MalFormScreen extends StatefulWidget {
  final Map<String, dynamic>? item;
  final int? index;

  const MalFormScreen({super.key, this.item, this.index});

  @override
  _MalFormScreenState createState() => _MalFormScreenState();
}

class _MalFormScreenState extends State<MalFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _serialNumberController = TextEditingController();
  final _personnelAssignedController = TextEditingController();
  String? _category;

  final List<String> _categories = [
    'Weapon',
    'Laser',
    'Light',
    'Optics',
    'NVG',
    'Thermals',
    'Drones',
    'Miscellaneous',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _descriptionController.text = widget.item!['description'];
      _serialNumberController.text = widget.item!['serialNumber'];
      _personnelAssignedController.text = widget.item!['personnelAssigned'];
      _category = widget.item!['category'];
    }
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      final newItem = {
        'category': _category,
        'description': _descriptionController.text,
        'serialNumber': _serialNumberController.text,
        'personnelAssigned': _personnelAssignedController.text,
      };

      // TODO: Save to mock data or Firestore
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.item == null ? 'Item added (mock)' : 'Item updated (mock)',
          ),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Add MAL Item' : 'Edit MAL Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                items:
                    _categories
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() => _category = value);
                },
                validator: (value) => value == null ? 'Required' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _serialNumberController,
                decoration: const InputDecoration(labelText: 'Serial Number'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _personnelAssignedController,
                decoration: const InputDecoration(
                  labelText: 'Personnel Assigned',
                ),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveItem,
                child: Text(widget.item == null ? 'Add' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
