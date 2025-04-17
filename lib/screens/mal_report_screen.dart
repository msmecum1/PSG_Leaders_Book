import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class MalReportScreen extends StatelessWidget {
  // Removed 'const' from constructor
  MalReportScreen({super.key});

  // Mock MAL data
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

  // Function to generate and save PDF
  Future<void> _generatePDF(BuildContext context) async {
    final pdf = pw.Document();

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
                            'Category',
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
                          item['category'],
                          item['description'],
                          item['serialNumber'],
                          item['personnelAssigned'],
                        ].map((data) => pw.Text(data.toString())).toList(),
                  ),
                ),
              ],
            ),
      ),
    );

    // Save PDF to device
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/mal_report.pdf');
    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('PDF saved to ${file.path}')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MAL Report'),
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
                        DataCell(Text(item['category'])),
                        DataCell(Text(item['description'])),
                        DataCell(Text(item['serialNumber'])),
                        DataCell(Text(item['personnelAssigned'])),
                      ],
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}
