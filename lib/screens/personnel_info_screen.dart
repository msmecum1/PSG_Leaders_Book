import 'package:flutter/material.dart';
import 'roster_report_screen.dart';
import 'edit_roster_screen.dart';

class PersonnelInfoScreen extends StatelessWidget {
  const PersonnelInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personnel Information')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RosterReportScreen()),
                );
              },
              child: const Text('View Roster'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditRosterScreen()),
                );
              },
              child: const Text('Edit Personnel Roster'),
            ),
          ],
        ),
      ),
    );
  }
}
