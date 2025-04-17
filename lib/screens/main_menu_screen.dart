import 'package:flutter/material.dart';
import 'task_org_screen.dart';
import 'mal_screen.dart';
import 'personnel_info_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PSG Leader\'s Book')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TaskOrgScreen(),
                  ),
                );
              },
              child: const Text('Task Org'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MalScreen()),
                );
              },
              child: const Text('Mal'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PersonnelInfoScreen(),
                  ),
                );
              },
              child: const Text('Personnel Info'),
            ),
          ],
        ),
      ),
    );
  }
}
