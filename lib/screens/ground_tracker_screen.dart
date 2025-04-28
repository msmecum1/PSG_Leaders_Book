import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psg_leaders_book/models/personnel.dart';
import 'package:psg_leaders_book/providers/firestore_provider.dart';
import 'package:intl/intl.dart';

class GroundTrackerScreen extends StatefulWidget {
  const GroundTrackerScreen({super.key});

  @override
  State<GroundTrackerScreen> createState() => _GroundTrackerScreenState();
}

class _GroundTrackerScreenState extends State<GroundTrackerScreen> {
  // Map to track the status of each person
  Map<String, String> _attendanceStatus = {};

  // Possible status options
  final List<String> _statusOptions = ['Present', 'Excused', 'AWOL'];

  // Selected date
  DateTime _selectedDate = DateTime.now();
  String get _formattedDate => DateFormat('yyyy-MM-dd').format(_selectedDate);

  // Indicate if we're looking at historical data
  bool _isHistoricalView = false;

  @override
  void initState() {
    super.initState();
    _loadAttendanceData();
  }

  // Load attendance data for the selected date
  Future<void> _loadAttendanceData() async {
    final firestoreProvider = Provider.of<FirestoreProvider>(
      context,
      listen: false,
    );
    final data = await firestoreProvider.getAttendanceData(_formattedDate);

    setState(() {
      if (data != null) {
        _attendanceStatus = data;
        _isHistoricalView = true;
      } else {
        _attendanceStatus = {};
        _isHistoricalView = false;
      }
    });
  }

  // Select a date
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _loadAttendanceData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ground Tracker'),
        actions: [
          // Date selection button
          TextButton(
            onPressed: _selectDate,
            child: Text(
              DateFormat('MMM dd, yyyy').format(_selectedDate),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          // Dropdown to select previous dates
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              _showDateSelectionDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Historical data indicator
          if (_isHistoricalView)
            Container(
              color: Colors.amber.shade100,
              padding: const EdgeInsets.all(8.0),
              width: double.infinity,
              child: Text(
                'Viewing historical data for ${DateFormat('MMMM d, yyyy').format(_selectedDate)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),

          // Summary section
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[200],
            child: StreamBuilder<List<Personnel>>(
              stream: Provider.of<FirestoreProvider>(context).getPersonnel(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final personnelList = snapshot.data!;

                // Calculate totals
                int total = personnelList.length;
                int present =
                    _attendanceStatus.values
                        .where((status) => status == 'Present')
                        .length;
                int excused =
                    _attendanceStatus.values
                        .where((status) => status == 'Excused')
                        .length;
                int awol =
                    _attendanceStatus.values
                        .where((status) => status == 'AWOL')
                        .length;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatusCounter('Total', total, Colors.blue),
                    _buildStatusCounter('Present', present, Colors.green),
                    _buildStatusCounter('Excused', excused, Colors.orange),
                    _buildStatusCounter('AWOL', awol, Colors.red),
                  ],
                );
              },
            ),
          ),

          // List of personnel with status selection
          Expanded(
            child: StreamBuilder<List<Personnel>>(
              stream: Provider.of<FirestoreProvider>(context).getPersonnel(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.isEmpty) {
                  return const Center(child: Text('No personnel found'));
                }

                final personnelList = snapshot.data!;

                // Initialize status for any new personnel
                for (var person in personnelList) {
                  if (!_attendanceStatus.containsKey(person.id)) {
                    _attendanceStatus[person.id] = 'Present'; // Default status
                  }
                }

                return ListView.builder(
                  itemCount: personnelList.length,
                  itemBuilder: (context, index) {
                    final person = personnelList[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getStatusColor(
                            _attendanceStatus[person.id] ?? 'Present',
                          ),
                          child: Text(person.rank[0]),
                        ),
                        title: Text(
                          '${person.rank} ${person.lastName}, ${person.firstName} ${person.middleInitial}',
                        ),
                        subtitle: Text(
                          person.squadTeam,
                        ), // Updated to show squadTeam
                        trailing:
                            _isHistoricalView
                                ? Chip(
                                  label: Text(
                                    _attendanceStatus[person.id] ?? 'N/A',
                                  ),
                                  backgroundColor: _getStatusColor(
                                    _attendanceStatus[person.id] ?? 'Present',
                                  ).withOpacity(0.3),
                                )
                                : DropdownButton<String>(
                                  value:
                                      _attendanceStatus[person.id] ?? 'Present',
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        _attendanceStatus[person.id] = newValue;
                                      });
                                    }
                                  },
                                  items:
                                      _statusOptions
                                          .map<DropdownMenuItem<String>>((
                                            String value,
                                          ) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          })
                                          .toList(),
                                ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      // Show save button only when not viewing historical data
      floatingActionButton:
          _isHistoricalView
              ? null
              : FloatingActionButton(
                onPressed: () {
                  _saveAttendanceData();
                },
                tooltip: 'Save Attendance',
                child: const Icon(Icons.save),
              ),
    );
  }

  // Show dialog to select from previous attendance dates
  void _showDateSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Date'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: StreamBuilder<List<String>>(
              stream:
                  Provider.of<FirestoreProvider>(context).getAttendanceDates(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final dates = snapshot.data!;

                if (dates.isEmpty) {
                  return const Center(child: Text('No saved attendance data'));
                }

                return ListView.builder(
                  itemCount: dates.length,
                  itemBuilder: (context, index) {
                    final date = dates[index];
                    return ListTile(
                      title: Text(
                        DateFormat('MMMM d, yyyy').format(DateTime.parse(date)),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedDate = DateTime.parse(date);
                        });
                        Navigator.of(context).pop();
                        _loadAttendanceData();
                      },
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Helper method to build the counter widgets
  Widget _buildStatusCounter(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label),
      ],
    );
  }

  // Helper method to get color based on status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Present':
        return Colors.green;
      case 'Excused':
        return Colors.orange;
      case 'AWOL':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  // Method to save attendance data to Firestore
  void _saveAttendanceData() {
    // Reference to Firebase
    final firestoreProvider = Provider.of<FirestoreProvider>(
      context,
      listen: false,
    );

    // Save the data with the formatted date
    firestoreProvider.saveAttendanceData(_formattedDate, _attendanceStatus);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Attendance saved for ${DateFormat('MMM dd, yyyy').format(_selectedDate)}',
        ),
      ),
    );

    setState(() {
      _isHistoricalView = true; // Now we're viewing what we just saved
    });
  }
}
