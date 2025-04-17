import 'package:flutter/material.dart';
import 'package:graphview/graphview.dart';

class TaskOrgDiagramScreen extends StatefulWidget {
  const TaskOrgDiagramScreen({super.key});

  @override
  _TaskOrgDiagramScreenState createState() => _TaskOrgDiagramScreenState();
}

class _TaskOrgDiagramScreenState extends State<TaskOrgDiagramScreen> {
  // Mock personnel data (same as RosterReportScreen, EditRosterScreen)
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
  ];

  final Graph graph = Graph();
  final BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();

  @override
  void initState() {
    super.initState();
    _buildGraph();
  }

  void _buildGraph() {
    // Create nodes for each position
    final Map<String, Node> nodes = {};
    final positions = [
      'PSG',
      'PL',
      'Platoon Medic',
      'RTO',
      'FO',
      '1st Squad Leader',
      '2nd Squad Leader',
      '3rd Squad Leader',
      'Weapons Squad Leader',
      '1st Squad Alpha Team Leader',
      '1st Squad Bravo Team Leader',
      '2nd Squad Alpha Team Leader',
      '2nd Squad Bravo Team Leader',
      '3rd Squad Alpha Team Leader',
      '3rd Squad Bravo Team Leader',
      'Weapons Squad Assistant Gunner',
      'Weapons Squad Ammo Handler',
      '1st Squad Alpha Team SAW Gunner',
      '1st Squad Alpha Team Grenadier',
      '1st Squad Alpha Team Rifleman',
      '1st Squad Bravo Team SAW Gunner',
      '1st Squad Bravo Team Grenadier',
      '1st Squad Bravo Team Rifleman',
      '2nd Squad Alpha Team SAW Gunner',
      '2nd Squad Alpha Team Grenadier',
      '2nd Squad Alpha Team Rifleman',
      '2nd Squad Bravo Team SAW Gunner',
      '2nd Squad Bravo Team Grenadier',
      '2nd Squad Bravo Team Rifleman',
      '3rd Squad Alpha Team SAW Gunner',
      '3rd Squad Alpha Team Grenadier',
      '3rd Squad Alpha Team Rifleman',
      '3rd Squad Bravo Team SAW Gunner',
      '3rd Squad Bravo Team Grenadier',
      '3rd Squad Bravo Team Rifleman',
      'Weapons Squad Machine Gunner',
      'Weapons Squad Anti-Tank Gunner',
    ];

    // Create nodes and assign personnel
    for (var position in positions) {
      final person = personnel.firstWhere(
        (p) => p['position'] == position,
        orElse: () => {'firstName': '', 'lastName': 'Vacant', 'rank': ''},
      );
      final label =
          person['firstName'].isEmpty
              ? position
              : '${person['rank']} ${person['firstName']} ${person['lastName']} (${person['position']})';
      nodes[position] = Node.Id(label);
    }

    // Define edges (parent-child relationships)
    final List<Edge> edges = [
      // Top level to support positions
      Edge(nodes['PSG']!, nodes['Platoon Medic']!),
      Edge(nodes['PSG']!, nodes['RTO']!),
      Edge(nodes['PSG']!, nodes['FO']!),
      Edge(nodes['PL']!, nodes['Platoon Medic']!),
      Edge(nodes['PL']!, nodes['RTO']!),
      Edge(nodes['PL']!, nodes['FO']!),
      // Top level to squad leaders
      Edge(nodes['PSG']!, nodes['1st Squad Leader']!),
      Edge(nodes['PSG']!, nodes['2nd Squad Leader']!),
      Edge(nodes['PSG']!, nodes['3rd Squad Leader']!),
      Edge(nodes['PSG']!, nodes['Weapons Squad Leader']!),
      Edge(nodes['PL']!, nodes['1st Squad Leader']!),
      Edge(nodes['PL']!, nodes['2nd Squad Leader']!),
      Edge(nodes['PL']!, nodes['3rd Squad Leader']!),
      Edge(nodes['PL']!, nodes['Weapons Squad Leader']!),
      // 1st Squad: Squad Leader to Team Leaders
      Edge(nodes['1st Squad Leader']!, nodes['1st Squad Alpha Team Leader']!),
      Edge(nodes['1st Squad Leader']!, nodes['1st Squad Bravo Team Leader']!),
      // 1st Squad Alpha Team
      Edge(
        nodes['1st Squad Alpha Team Leader']!,
        nodes['1st Squad Alpha Team SAW Gunner']!,
      ),
      Edge(
        nodes['1st Squad Alpha Team Leader']!,
        nodes['1st Squad Alpha Team Grenadier']!,
      ),
      Edge(
        nodes['1st Squad Alpha Team Leader']!,
        nodes['1st Squad Alpha Team Rifleman']!,
      ),
      // 1st Squad Bravo Team
      Edge(
        nodes['1st Squad Bravo Team Leader']!,
        nodes['1st Squad Bravo Team SAW Gunner']!,
      ),
      Edge(
        nodes['1st Squad Bravo Team Leader']!,
        nodes['1st Squad Bravo Team Grenadier']!,
      ),
      Edge(
        nodes['1st Squad Bravo Team Leader']!,
        nodes['1st Squad Bravo Team Rifleman']!,
      ),
      // 2nd Squad: Squad Leader to Team Leaders
      Edge(nodes['2nd Squad Leader']!, nodes['2nd Squad Alpha Team Leader']!),
      Edge(nodes['2nd Squad Leader']!, nodes['2nd Squad Bravo Team Leader']!),
      // 2nd Squad Alpha Team
      Edge(
        nodes['2nd Squad Alpha Team Leader']!,
        nodes['2nd Squad Alpha Team SAW Gunner']!,
      ),
      Edge(
        nodes['2nd Squad Alpha Team Leader']!,
        nodes['2nd Squad Alpha Team Grenadier']!,
      ),
      Edge(
        nodes['2nd Squad Alpha Team Leader']!,
        nodes['2nd Squad Alpha Team Rifleman']!,
      ),
      // 2nd Squad Bravo Team
      Edge(
        nodes['2nd Squad Bravo Team Leader']!,
        nodes['2nd Squad Bravo Team SAW Gunner']!,
      ),
      Edge(
        nodes['2nd Squad Bravo Team Leader']!,
        nodes['2nd Squad Bravo Team Grenadier']!,
      ),
      Edge(
        nodes['2nd Squad Bravo Team Leader']!,
        nodes['2nd Squad Bravo Team Rifleman']!,
      ),
      // 3rd Squad: Squad Leader to Team Leaders
      Edge(nodes['3rd Squad Leader']!, nodes['3rd Squad Alpha Team Leader']!),
      Edge(nodes['3rd Squad Leader']!, nodes['3rd Squad Bravo Team Leader']!),
      // 3rd Squad Alpha Team
      Edge(
        nodes['3rd Squad Alpha Team Leader']!,
        nodes['3rd Squad Alpha Team SAW Gunner']!,
      ),
      Edge(
        nodes['3rd Squad Alpha Team Leader']!,
        nodes['3rd Squad Alpha Team Grenadier']!,
      ),
      Edge(
        nodes['3rd Squad Alpha Team Leader']!,
        nodes['3rd Squad Alpha Team Rifleman']!,
      ),
      // 3rd Squad Bravo Team
      Edge(
        nodes['3rd Squad Bravo Team Leader']!,
        nodes['3rd Squad Bravo Team SAW Gunner']!,
      ),
      Edge(
        nodes['3rd Squad Bravo Team Leader']!,
        nodes['3rd Squad Bravo Team Grenadier']!,
      ),
      Edge(
        nodes['3rd Squad Bravo Team Leader']!,
        nodes['3rd Squad Bravo Team Rifleman']!,
      ),
      // Weapons Squad: Squad Leader to Team
      Edge(
        nodes['Weapons Squad Leader']!,
        nodes['Weapons Squad Assistant Gunner']!,
      ),
      Edge(
        nodes['Weapons Squad Leader']!,
        nodes['Weapons Squad Ammo Handler']!,
      ),
      Edge(
        nodes['Weapons Squad Assistant Gunner']!,
        nodes['Weapons Squad Machine Gunner']!,
      ),
      Edge(
        nodes['Weapons Squad Ammo Handler']!,
        nodes['Weapons Squad Anti-Tank Gunner']!,
      ),
    ];

    // Add nodes and edges to graph
    nodes.values.forEach(graph.addNode);
    edges.forEach((edge) => graph.addEdge(edge.source, edge.destination));

    // Configure layout
    builder
      ..siblingSeparation = 20
      ..levelSeparation = 50
      ..subtreeSeparation = 30
      ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Organization Diagram')),
      body: InteractiveViewer(
        constrained: false,
        boundaryMargin: const EdgeInsets.all(100),
        minScale: 0.01,
        maxScale: 5.6,
        child: GraphView(
          graph: graph,
          algorithm: BuchheimWalkerAlgorithm(
            builder,
            TreeEdgeRenderer(builder),
          ),
          paint:
              Paint()
                ..color = Colors.green
                ..strokeWidth = 2
                ..style = PaintingStyle.stroke,
          builder: (Node node) {
            final label = node.key!.value as String;
            return GestureDetector(
              onTap: () {
                final person = personnel.firstWhere(
                  (p) =>
                      '${p['rank']} ${p['firstName']} ${p['lastName']} (${p['position']})' ==
                      label,
                  orElse:
                      () => {
                        'firstName': '',
                        'lastName': 'Vacant',
                        'rank': '',
                        'position': label,
                      },
                );
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: Text(label),
                        content:
                            person['firstName'].isEmpty
                                ? const Text('Position Vacant')
                                : Text(
                                  'Rank: ${person['rank']}\n'
                                  'Name: ${person['firstName']} ${person['lastName']}\n'
                                  'Phone: ${person['phoneNumber']}\n'
                                  'Email: ${person['militaryEmail']}',
                                ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
