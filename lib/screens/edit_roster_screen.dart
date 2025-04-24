import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:provider/provider.dart'; // Import Provider
import 'package:psg_leaders_book/providers/firestore_provider.dart'; // Import your provider
import 'package:psg_leaders_book/models/personnel.dart'; // Import your Personnel model
import 'personnel_form_screen.dart';

class EditRosterScreen extends StatelessWidget {
  const EditRosterScreen({super.key});

  // Helper method for showing delete confirmation
  Future<void> _showDeleteConfirmation(
    BuildContext context,
    FirestoreProvider provider,
    Personnel person,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Are you sure you want to delete ${person.firstName} ${person.lastName}?',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
              onPressed: () {
                provider.deletePersonnel(person.id); // Call delete method
                Navigator.of(dialogContext).pop(); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Personnel deleted successfully'),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Access your FirestoreProvider instance
    final firestoreProvider = Provider.of<FirestoreProvider>(
      context,
      listen: false,
    ); // Use listen: false if only calling methods like delete

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Personnel Roster')),
      // Use StreamBuilder to listen to Firestore updates via the provider
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreProvider.fetchPersonnelStream(), // Use Provider method
        builder: (context, snapshot) {
          // Handle loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Handle error state
          if (snapshot.hasError) {
            print('Firestore Error: ${snapshot.error}'); // Log the error
            return const Center(child: Text('Error loading data.'));
          }
          // Handle no data state
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No personnel found.'));
          }

          // Map Firestore documents to Personnel objects
          final personnelList =
              snapshot.data!.docs.map((doc) {
                return Personnel.fromMap(
                  doc.data() as Map<String, dynamic>,
                  doc.id,
                );
              }).toList();

          // Build the list view with fetched data
          return ListView.builder(
            itemCount: personnelList.length,
            itemBuilder: (context, index) {
              final person = personnelList[index];
              return ListTile(
                title: Text('${person.firstName} ${person.lastName}'),
                subtitle: Text('Rank: ${person.rank} | Role: ${person.role}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PersonnelFormScreen(person: person),
                    ),
                  );
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _showDeleteConfirmation(context, firestoreProvider, person);
                  },
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
              builder: (context) => const PersonnelFormScreen(person: null),
            ),
          );
        },
        tooltip: 'Add New Personnel',
        child: const Icon(Icons.add),
      ),
    );
  }
}
