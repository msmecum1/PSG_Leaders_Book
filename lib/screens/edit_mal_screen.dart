import 'package:flutter/material.dart';
import 'mal_form_screen.dart';

class EditMalScreen extends StatelessWidget {
  // Removed 'const' from constructor
  EditMalScreen({super.key});

  // Mock MAL data (shared with MalReportScreen)
  final List<Map<String, dynamic>> malItems = [
    {
      'category': 'Weapon',
      'description': 'M4 Carbine',
      'serialNumber': 'W123456',
      'personnelAssigned': 'John Doe',
    },
    {
      'category': 'Laser',
      'description': 'PEQ-15',
      'serialNumber': 'L789012',
      'personnelAssigned': 'Jane Smith',
    },
    {
      'category': 'NVG',
      'description': 'PVS-14',
      'serialNumber': 'N345678',
      'personnelAssigned': 'Mike Johnson',
    },
    {
      'category': 'Drones',
      'description': 'DJI Mavic Mini',
      'serialNumber': 'D901234',
      'personnelAssigned': 'Sarah Brown',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit MAL')),
      body: ListView.builder(
        itemCount: malItems.length,
        itemBuilder: (context, index) {
          final item = malItems[index];
          return ListTile(
            title: Text(item['description']),
            subtitle: Text(
              'Category: ${item['category']} | Assigned: ${item['personnelAssigned']}',
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MalFormScreen(item: item, index: index),
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
            MaterialPageRoute(builder: (context) => const MalFormScreen()),
          );
        },
        tooltip: 'Add New Item',
        child: const Icon(Icons.add),
      ),
    );
  }
}
