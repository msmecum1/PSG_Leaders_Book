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
  bool _isEditingHistorical = false;

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
          if (_isHistoricalView) // Conditionally show the edit button
            IconButton(
              icon: Icon(_isEditingHistorical ? Icons.close : Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditingHistorical = !_isEditingHistorical;
                });
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
                _isEditingHistorical
                    ? 'Editing historical data for ${DateFormat('MMMM d, yyyy').format(_selectedDate)}'
                    : 'Viewing historical data for ${DateFormat('MMMM d, yyyy').format(_selectedDate)}',
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

                // Initialize status for new personnel if needed (only when not historical)
                if (!_isHistoricalView) {
                  for (var person in personnelList) {
                    if (!_attendanceStatus.containsKey(person.id)) {
                      _attendanceStatus[person.id] = 'Present';
                    }
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
                          child: Text(
                            person.rank.isNotEmpty ? person.rank[0] : '?',
                          ),
                        ),
                        title: Text(
                          '${person.rank} ${person.lastName}, ${person.firstName} ${person.middleInitial}'
                              .trim(),
                        ),
                        subtitle: Text(person.squadTeam),
                        trailing:
                            _isHistoricalView
                                ? _isEditingHistorical
                                    ? DropdownButton<String>(
                                      value:
                                          _attendanceStatus[person.id] ??
                                          'Present',
                                      onChanged: (String? newValue) {
                                        if (newValue != null) {
                                          setState(() {
                                            _attendanceStatus[person.id] =
                                                newValue;
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
                                    )
                                    : Chip(
                                      label: Text(
                                        _attendanceStatus[person.id] ?? 'N/A',
                                      ),
                                      backgroundColor: _getStatusColor(
                                        _attendanceStatus[person.id] ??
                                            'Present',
                                      ).withAlpha(77),
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
      floatingActionButton:
          !_isHistoricalView || _isEditingHistorical
              ? FloatingActionButton(
                onPressed: () {
                  final scaffoldMessenger = ScaffoldMessenger.of(context);

                  if (!_isHistoricalView) {
                    _saveAttendanceData(scaffoldMessenger);
                  } else if (_isEditingHistorical) {
                    _saveEditedAttendanceData(scaffoldMessenger);
                    setState(() {
                      _isEditingHistorical = false;
                    });
                  }
                },
                tooltip:
                    _isHistoricalView && _isEditingHistorical
                        ? 'Save Edits'
                        : 'Save Attendance',
                child: Icon(
                  _isHistoricalView && _isEditingHistorical
                      ? Icons.check
                      : Icons.save,
                ),
              )
              : null,
    );
  }

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

  // Method to save attendance data to Firestore (for current day)
  void _saveAttendanceData(ScaffoldMessengerState scaffoldMessenger) {
    final firestoreProvider = Provider.of<FirestoreProvider>(
      context,
      listen: false,
    );

    firestoreProvider.saveAttendanceData(_formattedDate, _attendanceStatus);

    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(
          'Attendance saved for ${DateFormat('MMM dd, yyyy').format(_selectedDate)}',
        ),
      ),
    );

    setState(() {
      _isHistoricalView = true;
      _isEditingHistorical = false;
    });
  }

  // Method to save edited attendance data to Firestore
  void _saveEditedAttendanceData(ScaffoldMessengerState scaffoldMessenger) {
    if (_isHistoricalView) {
      final firestoreProvider = Provider.of<FirestoreProvider>(
        context,
        listen: false,
      );

      firestoreProvider.saveAttendanceData(_formattedDate, _attendanceStatus);

      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(
            'Attendance updated for ${DateFormat('MMM dd, yyyy').format(_selectedDate)}',
          ),
        ),
      );
    }
  }
}
