import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psg_leaders_book/models/personnel.dart';
import 'package:psg_leaders_book/providers/firestore_provider.dart';

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
              return ListTile(
                title: Text(personnel.fullName),
                subtitle: Text(
                  '${personnel.rank} - ${personnel.role}\nEmail: ${personnel.contactInfo['email']}',
                ),
                trailing: Text(
                  personnel.squadTeam,
                ), // Updated to show squadTeam
              );
            },
          );
        },
      ),
    );
  }
}
