// edit_roster_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psg_leaders_book/providers/firestore_provider.dart';
import 'package:psg_leaders_book/models/personnel.dart';
import 'personnel_form_screen.dart';
import 'package:logger/logger.dart'; // Import logger

class EditRosterScreen extends StatelessWidget {
  EditRosterScreen({super.key});

  // Create a logger instance for this screen
  final logger = Logger(
    printer: PrettyPrinter(
      methodCount: 1,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.none,
    ),
  );

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
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Personnel Roster')),
      // Use StreamBuilder to listen to Firestore updates via the provider
      body: StreamBuilder<List<Personnel>>(
        stream: firestoreProvider.getPersonnel(),
        builder: (context, snapshot) {
          // Handle loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Handle error state
          if (snapshot.hasError) {
            // Replace print with logger.e
            logger.e(
              'Firestore Error loading personnel stream',
              error: snapshot.error,
              stackTrace: snapshot.stackTrace, // Include stack trace
            );
            return const Center(child: Text('Error loading data.'));
          }
          // Handle no data state
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No personnel found.'));
          }

          // Map Firestore documents to Personnel objects
          final personnelList = snapshot.data!;

          // Build the list view with fetched data
          return ListView.builder(
            itemCount: personnelList.length,
            itemBuilder: (context, index) {
              final person = personnelList[index];
              return ListTile(
                // Add flag icon if person is flagged
                leading:
                    person.isFlagged
                        ? const Icon(Icons.flag, color: Colors.red)
                        : CircleAvatar(
                          child: Text(person.firstName[0] + person.lastName[0]),
                        ),
                title: Text('${person.firstName} ${person.lastName}'),
                subtitle: Text(
                  'Rank: ${person.rank} | Squad/Team: ${person.squadTeam}${person.isFlagged ? " (Flagged)" : ""}',
                ),
                // Replace single icon with row of icons
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => PersonnelFormScreen(
                                  person: person,
                                  index: index,
                                ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Use the _showDeleteConfirmation method
                        _showDeleteConfirmation(
                          context,
                          firestoreProvider,
                          person,
                        );
                      },
                    ),
                  ],
                ),
                onTap: () {
                  // Show details or another action
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
