// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psg_leaders_book/models/mal.dart';
import 'package:psg_leaders_book/providers/firestore_provider.dart';

class MalFormScreen extends StatefulWidget {
  final Mal? item;
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
    'Radio',
    'Miscellaneous',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _descriptionController.text = widget.item!.description;
      _serialNumberController.text = widget.item!.serialNumber;
      _personnelAssignedController.text = widget.item!.personnelAssigned;
      _category = widget.item!.category;
    }
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      final firestoreProvider = Provider.of<FirestoreProvider>(
        context,
        listen: false,
      );

      final mal = Mal(
        id:
            widget.item?.id ??
            '', // If it's a new item, the ID will be set by Firestore
        category: _category!,
        description: _descriptionController.text,
        serialNumber: _serialNumberController.text,
        personnelAssigned: _personnelAssignedController.text,
      );

      if (widget.item == null) {
        // Add new item
        firestoreProvider.addMal(mal);
      } else {
        // Update existing item
        firestoreProvider.updateMal(mal);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.item == null
                ? 'Item added: ${mal.description}'
                : 'Item updated: ${mal.description}',
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
              const SizedBox(height: 10),
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
