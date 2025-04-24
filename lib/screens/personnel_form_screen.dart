// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:psg_leaders_book/models/personnel.dart';
import 'package:psg_leaders_book/providers/firestore_provider.dart';

class PersonnelFormScreen extends StatefulWidget {
  final Personnel? person;
  final int? index;

  const PersonnelFormScreen({super.key, this.person, this.index});

  @override
  _PersonnelFormScreenState createState() => _PersonnelFormScreenState();
}

class _PersonnelFormScreenState extends State<PersonnelFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _middleInitialController = TextEditingController();
  final _rankController = TextEditingController();
  String? _role;
  final _unitController = TextEditingController();
  String? _reportsTo;

  // Contact Info
  final _emailController = TextEditingController();
  final _secondaryEmailController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  // Address
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();

  // Military Specific Fields
  DateTime? _dateOfBirth;
  DateTime? _dateOfRank;
  DateTime? _dateOfETS;
  DateTime? _lastJumpDate;
  final _numberOfJumpsController = TextEditingController();
  DateTime? _lastNCOER;

  // List of valid roles (previously positions)
  final List<String> _roles = [
    'PSG',
    'PL',
    'Platoon Medic',
    'RTO',
    'FO',
    '1st Squad Leader',
    '2nd Squad Leader',
    '3rd Squad Leader',
    'Weapons Squad Leader',
    '1st Squad Alpha Team Leader',
    '1st Squad Bravo Team Leader',
    '2nd Squad Alpha Team Leader',
    '2nd Squad Bravo Team Leader',
    '3rd Squad Alpha Team Leader',
    '3rd Squad Bravo Team Leader',
    'Weapons Squad Assistant Gunner',
    'Weapons Squad Ammo Handler',
    '1st Squad Alpha Team SAW Gunner',
    '1st Squad Alpha Team Grenadier',
    '1st Squad Alpha Team Rifleman',
    '1st Squad Bravo Team SAW Gunner',
    '1st Squad Bravo Team Grenadier',
    '1st Squad Bravo Team Rifleman',
    '2nd Squad Alpha Team SAW Gunner',
    '2nd Squad Alpha Team Grenadier',
    '2nd Squad Alpha Team Rifleman',
    '2nd Squad Bravo Team SAW Gunner',
    '2nd Squad Bravo Team Grenadier',
    '2nd Squad Bravo Team Rifleman',
    '3rd Squad Alpha Team SAW Gunner',
    '3rd Squad Alpha Team Grenadier',
    '3rd Squad Alpha Team Rifleman',
    '3rd Squad Bravo Team SAW Gunner',
    '3rd Squad Bravo Team Grenadier',
    '3rd Squad Bravo Team Rifleman',
    'Weapons Squad Machine Gunner',
    'Weapons Squad Anti-Tank Gunner',
  ];

  // List for reportsTo dropdown (this would ideally be populated from your database)
  final List<String> _reportingOptions = [
    'person1', // Replace with actual IDs or use dynamic loading
    'person2',
    'person3',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.person != null) {
      _firstNameController.text = widget.person!.firstName;
      _lastNameController.text = widget.person!.lastName;
      _middleInitialController.text = widget.person!.middleInitial;
      _rankController.text = widget.person!.rank;
      _role = widget.person!.role;
      _unitController.text = widget.person!.unit;
      _reportsTo = widget.person!.reportsTo;

      // Contact info
      _emailController.text = widget.person!.contactInfo['email'] ?? '';
      _secondaryEmailController.text =
          widget.person!.contactInfo['secondaryEmail'] ?? '';
      _phoneNumberController.text = widget.person!.contactInfo['phone'] ?? '';

      // Address
      _streetController.text = widget.person!.address['street'] ?? '';
      _cityController.text = widget.person!.address['city'] ?? '';
      _stateController.text = widget.person!.address['state'] ?? '';
      _zipController.text = widget.person!.address['zip'] ?? '';

      // Future improvement: load military-specific fields from additional data
    }
  }

  Future<void> _selectDate(
    BuildContext context,
    Function(DateTime) onSelect,
    DateTime? initialDate,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      onSelect(picked);
    }
  }

  void _savePersonnel() {
    if (_formKey.currentState!.validate()) {
      final firestoreProvider = Provider.of<FirestoreProvider>(
        context,
        listen: false,
      );

      // Create contact info map
      final contactInfo = {
        'email': _emailController.text,
        'secondaryEmail': _secondaryEmailController.text,
        'phone': _phoneNumberController.text,
      };

      // Create address map
      final address = {
        'street': _streetController.text,
        'city': _cityController.text,
        'state': _stateController.text,
        'zip': _zipController.text,
      };

      if (widget.person == null) {
        // Create new personnel
        final newPerson = Personnel(
          id:
              DateTime.now()
                  .toString(), // You might want to use Firestore's auto-ID instead
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          middleInitial: _middleInitialController.text,
          rank: _rankController.text,
          role: _role ?? '',
          unit: _unitController.text,
          reportsTo: _reportsTo,
          contactInfo: contactInfo,
          address: address,
          // Add the new military-specific fields
          dateOfBirth: _dateOfBirth,
          dateOfRank: _dateOfRank,
          dateOfETS: _dateOfETS,
          lastJumpDate: _lastJumpDate,
          numberOfJumps: int.tryParse(_numberOfJumpsController.text),
          lastNCOER: _lastNCOER,
        );

        firestoreProvider.addPersonnel(newPerson);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Personnel added successfully')),
        );
      } else {
        // Update existing personnel
        final updatedPerson = Personnel(
          id: widget.person!.id,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          middleInitial: _middleInitialController.text,
          rank: _rankController.text,
          role: _role ?? '',
          unit: _unitController.text,
          reportsTo: _reportsTo,
          contactInfo: contactInfo,
          address: address,
          // Add the new military-specific fields here too
          dateOfBirth: _dateOfBirth,
          dateOfRank: _dateOfRank,
          dateOfETS: _dateOfETS,
          lastJumpDate: _lastJumpDate,
          numberOfJumps: int.tryParse(_numberOfJumpsController.text),
          lastNCOER: _lastNCOER,
        );

        firestoreProvider.updatePersonnel(updatedPerson);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Personnel updated successfully')),
        );
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.person == null ? 'Add Personnel' : 'Edit Personnel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Personal Information Section
                const Text(
                  'Personal Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(labelText: 'First Name'),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: _middleInitialController,
                  decoration: const InputDecoration(
                    labelText: 'Middle Initial',
                  ),
                ),

                const SizedBox(height: 20),

                // Military Information Section
                const Text(
                  'Military Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _rankController,
                  decoration: const InputDecoration(labelText: 'Rank'),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                DropdownButtonFormField<String>(
                  value: _role,
                  decoration: const InputDecoration(labelText: 'Role'),
                  items:
                      _roles
                          .map(
                            (role) => DropdownMenuItem(
                              value: role,
                              child: Text(role),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() => _role = value);
                  },
                  validator: (value) => value == null ? 'Required' : null,
                ),
                TextFormField(
                  controller: _unitController,
                  decoration: const InputDecoration(labelText: 'Unit'),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                DropdownButtonFormField<String>(
                  value: _reportsTo,
                  decoration: const InputDecoration(labelText: 'Reports To'),
                  items:
                      _reportingOptions
                          .map(
                            (person) => DropdownMenuItem(
                              value: person,
                              child: Text(person),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() => _reportsTo = value);
                  },
                ),

                // Optional military dates that could be added to your model
                ListTile(
                  title: Text(
                    _dateOfRank == null
                        ? 'Date of Rank'
                        : 'DOR: ${dateFormat.format(_dateOfRank!)}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap:
                      () => _selectDate(context, (date) {
                        setState(() => _dateOfRank = date);
                      }, _dateOfRank),
                ),
                ListTile(
                  title: Text(
                    _dateOfETS == null
                        ? 'Date of ETS'
                        : 'ETS: ${dateFormat.format(_dateOfETS!)}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap:
                      () => _selectDate(context, (date) {
                        setState(() => _dateOfETS = date);
                      }, _dateOfETS),
                ),

                const SizedBox(height: 20),

                // Contact Information Section
                const Text(
                  'Contact Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: _secondaryEmailController,
                  decoration: const InputDecoration(
                    labelText: 'Secondary Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 20),

                // Address Section
                const Text(
                  'Address',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _streetController,
                  decoration: const InputDecoration(labelText: 'Street'),
                ),
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(labelText: 'City'),
                ),
                TextFormField(
                  controller: _stateController,
                  decoration: const InputDecoration(labelText: 'State'),
                ),
                TextFormField(
                  controller: _zipController,
                  decoration: const InputDecoration(labelText: 'ZIP Code'),
                ),

                // Add other fields as needed for optional military data
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: _savePersonnel,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 50),
                    ),
                    child: Text(
                      widget.person == null
                          ? 'Add Personnel'
                          : 'Update Personnel',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
