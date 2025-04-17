import 'package:flutter/material.dart';
import 'task_org_diagram_screen.dart';

class TaskOrgScreen extends StatelessWidget {
  const TaskOrgScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Organization')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TaskOrgDiagramScreen(),
                  ),
                );
              },
              child: const Text('View Task Org Diagram'),
            ),
            // Add more buttons for other task org features (e.g., Ground Tracker) later
          ],
        ),
      ),
    );
  }
}
