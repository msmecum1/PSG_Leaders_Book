import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:psg_leaders_book/models/mal.dart';
import 'package:psg_leaders_book/providers/firestore_provider.dart';

class MalReportScreen extends StatelessWidget {
  const MalReportScreen({super.key});

  // Function to generate and save PDF
  Future<void> _generatePDF(BuildContext context, List<Mal> malItems) async {
    // Get the ScaffoldMessengerState BEFORE the await
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build:
            (pw.Context pdfContext) => pw.Table(
              border: pw.TableBorder.all(),
              children: [
                // Header row
                pw.TableRow(
                  children:
                      [
                            'Category',
                            'Type',
                            'Description',
                            'Serial Number',
                            'Personnel Assigned',
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
                ...malItems.map(
                  (item) => pw.TableRow(
                    children:
                        [
                          item.category,
                          item.description,
                          item.serialNumber,
                          item.personnelAssigned,
                        ].map((data) => pw.Text(data.toString())).toList(),
                  ),
                ),
              ],
            ),
      ),
    );

    // Async operations start here
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/mal_report.pdf');
    await file.writeAsBytes(await pdf.save());
    // Async operations end here

    // Use the stored ScaffoldMessengerState AFTER the await
    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text('PDF saved to ${file.path}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MAL Report'),
        actions: [
          StreamBuilder<List<Mal>>(
            stream: Provider.of<FirestoreProvider>(context).getMalItems(),
            builder: (context, snapshot) {
              return IconButton(
                icon: const Icon(Icons.download),
                onPressed:
                    snapshot.hasData
                        ? () => _generatePDF(context, snapshot.data!)
                        : null,
                tooltip: 'Export to PDF',
              );
            },
          ),
        ],
      ),
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

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Category')),
                DataColumn(label: Text('Description')),
                DataColumn(label: Text('Serial Number')),
                DataColumn(label: Text('Personnel Assigned')),
              ],
              rows:
                  malItems
                      .map(
                        (item) => DataRow(
                          cells: [
                            DataCell(Text(item.category)),
                            DataCell(Text(item.description)),
                            DataCell(Text(item.serialNumber)),
                            DataCell(Text(item.personnelAssigned)),
                          ],
                        ),
                      )
                      .toList(),
            ),
          );
        },
      ),
    );
  }
}
