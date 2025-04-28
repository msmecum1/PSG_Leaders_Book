// personnel_form_screen.dart
// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:psg_leaders_book/models/personnel.dart';
import 'package:psg_leaders_book/providers/firestore_provider.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';

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
  String? _rank;
  final _rankController = TextEditingController();
  String? _role;
  String? _squadTeam;
  String? _reportsTo;

  // Contact Info
  final _emailController = TextEditingController();
  final _secondaryEmailController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  // Address
  final _streetController = TextEditingController();
  String? _city; // Use String? for city
  String? _state; // Use String? for state
  String? _country; // Add country
  final _zipController = TextEditingController();

  // Military Specific Fields
  DateTime? _dateOfBirth;
  DateTime? _dateOfRank;
  DateTime? _dateOfETS;
  DateTime? _lastJumpDate;
  final _numberOfJumpsController = TextEditingController();
  DateTime? _lastNCOER;

  // List of valid roles
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

  // New list for squad/team dropdown
  final List<String> _squadTeamOptions = [
    '1st',
    '1st Alpha',
    '1st Bravo',
    '2nd',
    '2nd Alpha',
    '2nd Bravo',
    '3rd',
    '3rd Alpha',
    '3rd Bravo',
    'PSG',
    'PL',
    'Support',
  ];

  // List for reportsTo dropdown (will be populated dynamically)
  List<String> _reportingOptions = [];

  @override
  void initState() {
    super.initState();
    if (widget.person != null) {
      _firstNameController.text = widget.person!.firstName;
      _lastNameController.text = widget.person!.lastName;
      _middleInitialController.text = widget.person!.middleInitial;
      _rank = widget.person!.rank;
      _rankController.text = widget.person!.rank;
      _role = widget.person!.role;
      _squadTeam = widget.person!.squadTeam;
      _reportsTo = widget.person!.reportsTo;

      // Contact info
      _emailController.text = widget.person!.contactInfo['email'] ?? '';
      _secondaryEmailController.text =
          widget.person!.contactInfo['secondaryEmail'] ?? '';
      _phoneNumberController.text = widget.person!.contactInfo['phone'] ?? '';

      // Address
      _streetController.text = widget.person!.address['street'] ?? '';
      _country = widget.person!.address['country'];
      _state = widget.person!.address['state'];
      _city = widget.person!.address['city'];
      _zipController.text = widget.person!.address['zip'] ?? '';
    }

    // Load personnel for the Reports To dropdown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadReportingOptions();
    });
  }

  Future<void> _loadReportingOptions() async {
    final firestoreProvider = Provider.of<FirestoreProvider>(
      context,
      listen: false,
    );
    final personnelStream = firestoreProvider.getPersonnel();

    personnelStream.listen((personnelList) {
      List<String> names = [];
      for (var person in personnelList) {
        // Exclude the current person being edited from the list
        if (widget.person == null || person.id != widget.person!.id) {
          names.add(person.fullName);
        }
      }
      setState(() {
        _reportingOptions = names;
      });
    });
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
        'country': _country ?? '',
        'state': _state ?? '',
        'city': _city ?? '',
        'zip': _zipController.text,
      };

      if (widget.person == null) {
        // Create new personnel
        final newPerson = Personnel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          middleInitial: _middleInitialController.text,
          rank: _rank ?? '',
          role: _role ?? '',
          squadTeam: _squadTeam ?? '',
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
          rank: _rank ?? '',
          role: _role ?? '',
          squadTeam: _squadTeam ?? '',
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
                DropdownButtonFormField<String>(
                  value: _rank,
                  decoration: const InputDecoration(labelText: 'Rank'),
                  items:
                      <String>[
                        'Private',
                        'Private First Class',
                        'Specialist',
                        'Corporal',
                        'Sergeant',
                        'Staff Sergeant',
                        'Sergeant First Class',
                        '2Lt',
                        'First Lieutenant',
                        'Cadet',
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _rank = newValue;
                      _rankController.text = newValue!;
                    });
                  },
                  validator: (value) => value == null ? 'Required' : null,
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
                DropdownButtonFormField<String>(
                  value: _squadTeam,
                  decoration: const InputDecoration(labelText: 'Squad/Team'),
                  items:
                      _squadTeamOptions
                          .map(
                            (squadTeam) => DropdownMenuItem(
                              value: squadTeam,
                              child: Text(squadTeam),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() => _squadTeam = value);
                  },
                  validator: (value) => value == null ? 'Required' : null,
                ),
                DropdownButtonFormField<String>(
                  value: _reportsTo,
                  decoration: const InputDecoration(labelText: 'Reports To'),
                  items:
                      _reportingOptions
                          .map(
                            (personName) => DropdownMenuItem(
                              value: personName,
                              child: Text(personName),
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
                SelectState(
                  // <-- Change this line
                  // Use the widget from the library
                  // country: _country, // SelectState might not have 'country' directly
                  // state: _state,     // SelectState might not have 'state' directly
                  // city: _city,       // SelectState might not have 'city' directly
                  onCountryChanged: (value) {
                    setState(() {
                      _country = value;
                      // Reset state and city when country changes
                      _state = null;
                      _city = null;
                    });
                  },
                  onStateChanged: (value) {
                    setState(() {
                      _state = value;
                      // Reset city when state changes
                      _city = null;
                    });
                  },
                  onCityChanged: (value) {
                    setState(() {
                      _city = value;
                    });
                  },
                  // You might need to adjust styling or pass controllers if the API differs
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
