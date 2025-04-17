import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PersonnelFormScreen extends StatefulWidget {
  final Map<String, dynamic>? person;
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
  String? _position;
  DateTime? _dateOfBirth;
  DateTime? _dateOfRank;
  DateTime? _dateOfETS;
  final _addressController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _personalEmailController = TextEditingController();
  final _militaryEmailController = TextEditingController();
  DateTime? _lastJumpDate;
  final _numberOfJumpsController = TextEditingController();
  DateTime? _lastNCOER;

  // List of valid positions
  final List<String> _positions = [
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

  @override
  void initState() {
    super.initState();
    if (widget.person != null) {
      _firstNameController.text = widget.person!['firstName'];
      _lastNameController.text = widget.person!['lastName'];
      _middleInitialController.text = widget.person!['middleInitial'];
      _rankController.text = widget.person!['rank'];
      _position = widget.person!['position'];
      _dateOfBirth = widget.person!['dateOfBirth'];
      _dateOfRank = widget.person!['dateOfRank'];
      _dateOfETS = widget.person!['dateOfETS'];
      _addressController.text = widget.person!['address'];
      _phoneNumberController.text = widget.person!['phoneNumber'];
      _personalEmailController.text = widget.person!['personalEmail'];
      _militaryEmailController.text = widget.person!['militaryEmail'];
      _lastJumpDate = widget.person!['lastJumpDate'];
      _numberOfJumpsController.text =
          widget.person!['numberOfJumps'].toString();
      _lastNCOER = widget.person!['lastNCOER'];
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
      final newPerson = {
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'middleInitial': _middleInitialController.text,
        'rank': _rankController.text,
        'position': _position,
        'dateOfBirth': _dateOfBirth ?? DateTime.now(),
        'dateOfRank': _dateOfRank ?? DateTime.now(),
        'dateOfETS': _dateOfETS ?? DateTime.now(),
        'address': _addressController.text,
        'phoneNumber': _phoneNumberController.text,
        'personalEmail': _personalEmailController.text,
        'militaryEmail': _militaryEmailController.text,
        'lastJumpDate': _lastJumpDate ?? DateTime.now(),
        'numberOfJumps': int.tryParse(_numberOfJumpsController.text) ?? 0,
        'lastNCOER': _lastNCOER ?? DateTime.now(),
      };

      // TODO: Save to mock data or Firestore
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.person == null
                ? 'Personnel added (mock)'
                : 'Personnel updated (mock)',
          ),
        ),
      );
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
              children: [
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
                TextFormField(
                  controller: _rankController,
                  decoration: const InputDecoration(labelText: 'Rank'),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                DropdownButtonFormField<String>(
                  value: _position,
                  decoration: const InputDecoration(labelText: 'Position'),
                  items:
                      _positions
                          .map(
                            (position) => DropdownMenuItem(
                              value: position,
                              child: Text(position),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() => _position = value);
                  },
                  validator: (value) => value == null ? 'Required' : null,
                ),
                ListTile(
                  title: Text(
                    _dateOfBirth == null
                        ? 'Date of Birth'
                        : 'DOB: ${dateFormat.format(_dateOfBirth!)}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap:
                      () => _selectDate(context, (date) {
                        setState(() => _dateOfBirth = date);
                      }, _dateOfBirth),
                ),
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
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                ),
                TextFormField(
                  controller: _personalEmailController,
                  decoration: const InputDecoration(
                    labelText: 'Personal Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextFormField(
                  controller: _militaryEmailController,
                  decoration: const InputDecoration(
                    labelText: 'Military Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                ListTile(
                  title: Text(
                    _lastJumpDate == null
                        ? 'Last Jump Date'
                        : 'Last Jump: ${dateFormat.format(_lastJumpDate!)}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap:
                      () => _selectDate(context, (date) {
                        setState(() => _lastJumpDate = date);
                      }, _lastJumpDate),
                ),
                TextFormField(
                  controller: _numberOfJumpsController,
                  decoration: const InputDecoration(
                    labelText: 'Number of Jumps',
                  ),
                  keyboardType: TextInputType.number,
                ),
                ListTile(
                  title: Text(
                    _lastNCOER == null
                        ? 'Last NCOER'
                        : 'Last NCOER: ${dateFormat.format(_lastNCOER!)}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap:
                      () => _selectDate(context, (date) {
                        setState(() => _lastNCOER = date);
                      }, _lastNCOER),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _savePersonnel,
                  child: Text(widget.person == null ? 'Add' : 'Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
