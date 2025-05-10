import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psg_leaders_book/models/personnel.dart';
import 'package:psg_leaders_book/providers/firestore_provider.dart';
import 'package:intl/intl.dart';

class RosterReportScreen extends StatelessWidget {
  const RosterReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreProvider = Provider.of<FirestoreProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Roster Report')),
      body: StreamBuilder<List<Personnel>>(
        stream: firestoreProvider.getPersonnel(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final personnelList = snapshot.data ?? [];

          if (personnelList.isEmpty) {
            return const Center(child: Text('No personnel found'));
          }

          return ListView.builder(
            itemCount: personnelList.length,
            itemBuilder: (context, index) {
              final personnel = personnelList[index];
              List<String> subtitleLines = [
                '${personnel.rank} - ${personnel.role}',
                'Email: ${personnel.contactInfo['email'] ?? 'N/A'}',
              ];

              // Add flag information if the soldier is flagged
              if (personnel.isFlagged) {
                subtitleLines.add('Status: FLAGGED');
                if (personnel.flagDate != null) {
                  subtitleLines.add(
                    'Flagged On: ${DateFormat('MMM dd, yyyy').format(personnel.flagDate!)}',
                  );
                }
                if (personnel.flagNotes != null &&
                    personnel.flagNotes!.isNotEmpty) {
                  subtitleLines.add('Flag Notes: ${personnel.flagNotes}');
                } else {
                  subtitleLines.add('Flag Notes: N/A');
                }
              }

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: ListTile(
                  // Add visual indicator for flagged personnel
                  leading:
                      personnel.isFlagged
                          ? const Icon(Icons.flag, color: Colors.red)
                          : null,
                  title: Text(
                    '${personnel.lastName}, ${personnel.firstName} ${personnel.middleInitial}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    subtitleLines.join('\n'),
                    style: TextStyle(
                      // Highlight flag information in red if flagged
                      color: personnel.isFlagged ? Colors.red[700] : null,
                    ),
                  ),
                  trailing: Text(personnel.squadTeam),
                  // Optional: make flagged soldiers expandable for more details
                  isThreeLine:
                      personnel
                          .isFlagged, // Give more space for flagged personnel
                ),
              );
            },
          );
        },
      ),
    );
  }
}
