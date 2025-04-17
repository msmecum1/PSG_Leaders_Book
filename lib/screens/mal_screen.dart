import 'package:flutter/material.dart';
import 'mal_report_screen.dart';
import 'edit_mal_screen.dart';

class MalScreen extends StatelessWidget {
  const MalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Master Authorization List')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MalReportScreen()),
                );
              },
              child: const Text('View MAL'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditMalScreen()),
                );
              },
              child: const Text('Edit MAL'),
            ),
          ],
        ),
      ),
    );
  }
}
