import 'package:flutter/material.dart';
import 'personnel_form_screen.dart';

class EditRosterScreen extends StatelessWidget {
  EditRosterScreen({super.key});

  // Mock personnel data with position
  final List<Map<String, dynamic>> personnel = [
    {
      'firstName': 'John',
      'lastName': 'Doe',
      'middleInitial': 'A',
      'rank': 'SGT',
      'position': 'PSG',
      'dateOfBirth': DateTime(1990, 5, 15),
      'dateOfRank': DateTime(2023, 1, 10),
      'dateOfETS': DateTime(2026, 6, 30),
      'address': '123 Main St, Fort Bragg, NC',
      'phoneNumber': '555-123-4567',
      'personalEmail': 'john.doe@gmail.com',
      'militaryEmail': 'john.doe@army.mil',
      'lastJumpDate': DateTime(2025, 3, 20),
      'numberOfJumps': 12,
      'lastNCOER': DateTime(2024, 12, 15),
    },
    {
      'firstName': 'Jane',
      'lastName': 'Smith',
      'middleInitial': 'B',
      'rank': 'SPC',
      'position': 'Platoon Medic',
      'dateOfBirth': DateTime(1995, 8, 22),
      'dateOfRank': DateTime(2024, 2, 5),
      'dateOfETS': DateTime(2027, 8, 15),
      'address': '456 Oak Ave, Fort Campbell, KY',
      'phoneNumber': '555-987-6543',
      'personalEmail': 'jane.smith@yahoo.com',
      'militaryEmail': 'jane.smith@army.mil',
      'lastJumpDate': DateTime(2025, 2, 10),
      'numberOfJumps': 8,
      'lastNCOER': DateTime(2024, 11, 30),
    },
    {
      'firstName': 'Mike',
      'lastName': 'Johnson',
      'middleInitial': 'C',
      'rank': 'SGT',
      'position': '1st Squad Leader',
      'dateOfBirth': DateTime(1992, 3, 10),
      'dateOfRank': DateTime(2023, 6, 15),
      'dateOfETS': DateTime(2026, 12, 31),
      'address': '789 Pine Rd, Fort Hood, TX',
      'phoneNumber': '555-456-7890',
      'personalEmail': 'mike.johnson@gmail.com',
      'militaryEmail': 'mike.johnson@army.mil',
      'lastJumpDate': DateTime(2025, 1, 15),
      'numberOfJumps': 10,
      'lastNCOER': DateTime(2024, 10, 20),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Personnel Roster')),
      body: ListView.builder(
        itemCount: personnel.length,
        itemBuilder: (context, index) {
          final person = personnel[index];
          return ListTile(
            title: Text('${person['firstName']} ${person['lastName']}'),
            subtitle: Text(
              'Rank: ${person['rank']} | Position: ${person['position']}',
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          PersonnelFormScreen(person: person, index: index),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PersonnelFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Add New Personnel',
      ),
    );
  }
}
