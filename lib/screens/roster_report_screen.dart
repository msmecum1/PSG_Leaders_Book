import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class RosterReportScreen extends StatelessWidget {
  RosterReportScreen({super.key});

  // Mock personnel data with position
  final List<Map<String, dynamic>> personnel = [
    {
      'firstName': 'John',
      'lastName': 'Doe',
      'middleInitial': 'A',
      'rank': 'SGT',
      'position': 'PSG',
      'dateOfBirth': DateTime(1990, 5, 15),
      'dateOfRank': DateTime(2023, 1, 10),
      'dateOfETS': DateTime(2026, 6, 30),
      'address': '123 Main St, Fort Bragg, NC',
      'phoneNumber': '555-123-4567',
      'personalEmail': 'john.doe@gmail.com',
      'militaryEmail': 'john.doe@army.mil',
      'lastJumpDate': DateTime(2025, 3, 20),
      'numberOfJumps': 12,
      'lastNCOER': DateTime(2024, 12, 15),
    },
    {
      'firstName': 'Jane',
      'lastName': 'Smith',
      'middleInitial': 'B',
      'rank': 'SPC',
      'position': 'Platoon Medic',
      'dateOfBirth': DateTime(1995, 8, 22),
      'dateOfRank': DateTime(2024, 2, 5),
      'dateOfETS': DateTime(2027, 8, 15),
      'address': '456 Oak Ave, Fort Campbell, KY',
      'phoneNumber': '555-987-6543',
      'personalEmail': 'jane.smith@yahoo.com',
      'militaryEmail': 'jane.smith@army.mil',
      'lastJumpDate': DateTime(2025, 2, 10),
      'numberOfJumps': 8,
      'lastNCOER': DateTime(2024, 11, 30),
    },
    {
      'firstName': 'Mike',
      'lastName': 'Johnson',
      'middleInitial': 'C',
      'rank': 'SGT',
      'position': '1st Squad Leader',
      'dateOfBirth': DateTime(1992, 3, 10),
      'dateOfRank': DateTime(2023, 6, 15),
      'dateOfETS': DateTime(2026, 12, 31),
      'address': '789 Pine Rd, Fort Hood, TX',
      'phoneNumber': '555-456-7890',
      'personalEmail': 'mike.johnson@gmail.com',
      'militaryEmail': 'mike.johnson@army.mil',
      'lastJumpDate': DateTime(2025, 1, 15),
      'numberOfJumps': 10,
      'lastNCOER': DateTime(2024, 10, 20),
    },
    // Add more personnel as needed for testing
  ];

  // Function to generate and save PDF
  Future<void> _generatePDF(BuildContext context) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('MMM dd, yyyy');

    pdf.addPage(
      pw.Page(
        build:
            (pw.Context context) => pw.Table(
              border: pw.TableBorder.all(),
              children: [
                // Header row
                pw.TableRow(
                  children:
                      [
                            'First Name',
                            'Last Name',
                            'MI',
                            'Rank',
                            'Position',
                            'DOB',
                            'DOR',
                            'ETS',
                            'Address',
                            'Phone',
                            'Personal Email',
                            'Military Email',
                            'Last Jump',
                            'Jumps',
                            'Last NCOER',
                          ]
                          .map(
                            (header) => pw.Text(
                              header,
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          )
                          .toList(),
                ),
                // Data rows
                ...personnel.map(
                  (person) => pw.TableRow(
                    children:
                        [
                          person['firstName'],
                          person['lastName'],
                          person['middleInitial'],
                          person['rank'],
                          person['position'],
                          dateFormat.format(person['dateOfBirth']),
                          dateFormat.format(person['dateOfRank']),
                          dateFormat.format(person['dateOfETS']),
                          person['address'],
                          person['phoneNumber'],
                          person['personalEmail'],
                          person['militaryEmail'],
                          dateFormat.format(person['lastJumpDate']),
                          person['numberOfJumps'].toString(),
                          dateFormat.format(person['lastNCOER']),
                        ].map((data) => pw.Text(data.toString())).toList(),
                  ),
                ),
              ],
            ),
      ),
    );

    // Save PDF to device
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/roster_report.pdf');
    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('PDF saved to ${file.path}')));
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Roster Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _generatePDF(context),
            tooltip: 'Export to PDF',
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('First Name')),
            DataColumn(label: Text('Last Name')),
            DataColumn(label: Text('MI')),
            DataColumn(label: Text('Rank')),
            DataColumn(label: Text('Position')),
            DataColumn(label: Text('DOB')),
            DataColumn(label: Text('DOR')),
            DataColumn(label: Text('ETS')),
            DataColumn(label: Text('Address')),
            DataColumn(label: Text('Phone')),
            DataColumn(label: Text('Personal Email')),
            DataColumn(label: Text('Military Email')),
            DataColumn(label: Text('Last Jump')),
            DataColumn(label: Text('Jumps')),
            DataColumn(label: Text('Last NCOER')),
          ],
          rows:
              personnel
                  .map(
                    (person) => DataRow(
                      cells: [
                        DataCell(Text(person['firstName'])),
                        DataCell(Text(person['lastName'])),
                        DataCell(Text(person['middleInitial'])),
                        DataCell(Text(person['rank'])),
                        DataCell(Text(person['position'])),
                        DataCell(
                          Text(dateFormat.format(person['dateOfBirth'])),
                        ),
                        DataCell(Text(dateFormat.format(person['dateOfRank']))),
                        DataCell(Text(dateFormat.format(person['dateOfETS']))),
                        DataCell(Text(person['address'])),
                        DataCell(Text(person['phoneNumber'])),
                        DataCell(Text(person['personalEmail'])),
                        DataCell(Text(person['militaryEmail'])),
                        DataCell(
                          Text(dateFormat.format(person['lastJumpDate'])),
                        ),
                        DataCell(Text(person['numberOfJumps'].toString())),
                        DataCell(Text(dateFormat.format(person['lastNCOER']))),
                      ],
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}
