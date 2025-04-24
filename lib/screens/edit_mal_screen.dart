import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'mal_form_screen.dart';
import 'package:psg_leaders_book/models/mal.dart';
import 'package:psg_leaders_book/providers/firestore_provider.dart';

class EditMalScreen extends StatelessWidget {
  const EditMalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit MAL')),
      body: StreamBuilder<List<Mal>>(
        stream: Provider.of<FirestoreProvider>(context).getMalItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No MAL items found'));
          }

          final malItems = snapshot.data!;

          return ListView.builder(
            itemCount: malItems.length,
            itemBuilder: (context, index) {
              final item = malItems[index];
              return ListTile(
                title: Text(item.description),
                subtitle: Text(
                  'Category: ${item.category} |  Assigned: ${item.personnelAssigned}',
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => MalFormScreen(item: item, index: index),
                    ),
                  );
                },
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
