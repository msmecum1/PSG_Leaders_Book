import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:provider/provider.dart';
import 'package:psg_leaders_book/models/personnel.dart';
import 'package:psg_leaders_book/providers/firestore_provider.dart';

class TaskOrgDiagramScreen extends StatelessWidget {
  const TaskOrgDiagramScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreProvider = Provider.of<FirestoreProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Task Organization Diagram')),
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

          return OrganizationDiagram(personnelList: personnelList);
        },
      ),
    );
  }
}

class OrganizationDiagram extends StatefulWidget {
  final List<Personnel> personnelList;

  const OrganizationDiagram({super.key, required this.personnelList});

  @override
  State<OrganizationDiagram> createState() => _OrganizationDiagramState();
}

class _OrganizationDiagramState extends State<OrganizationDiagram> {
  late Graph graph;
  late BuchheimWalkerConfiguration builder;
  late Size _screenSize;
  final TransformationController _transformationController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    graph = Graph();
    builder =
        BuchheimWalkerConfiguration()
          ..siblingSeparation = 100
          ..levelSeparation = 150
          ..subtreeSeparation = 150
          ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;
    _setupGraph();
  }

  void _setupGraph() {
    // First, create a map of full names to personnel objects
    final Map<String, Personnel> fullNameToPersonnel = {};
    for (var person in widget.personnelList) {
      fullNameToPersonnel[person.fullName] = person;
    }

    // Create nodes for each personnel
    final Map<String, Node> idToNode = {};
    for (var person in widget.personnelList) {
      idToNode[person.id] = Node.Id(person.id);
      graph.addNode(idToNode[person.id]!);
    }

    // Create edges based on 'reportsTo' relationship
    for (var person in widget.personnelList) {
      if (person.reportsTo != null && person.reportsTo!.isNotEmpty) {
        // Find the personnel that this person reports to
        final supervisor = fullNameToPersonnel[person.reportsTo];
        if (supervisor != null && idToNode.containsKey(supervisor.id)) {
          graph.addEdge(idToNode[supervisor.id]!, idToNode[person.id]!);
        }
      }
    }
  }

  void _showPersonnelDetails(BuildContext context, Personnel personnel) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              '${personnel.rank} ${personnel.firstName} ${personnel.lastName}',
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(),
                  // Military Info
                  const Text(
                    'Military Information',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 100, child: Text('Rank:')),
                      Expanded(child: Text(personnel.rank)),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 100, child: Text('Role:')),
                      Expanded(child: Text(personnel.role)),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 100, child: Text('Squad/Team:')),
                      Expanded(child: Text(personnel.squadTeam)),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 100, child: Text('Reports To:')),
                      Expanded(child: Text(personnel.reportsTo ?? 'N/A')),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Contact Info
                  const Text(
                    'Contact Information',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 100, child: Text('Phone:')),
                      Expanded(
                        child: Text(personnel.contactInfo['phone'] ?? 'N/A'),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 100, child: Text('Email:')),
                      Expanded(
                        child: Text(personnel.contactInfo['email'] ?? 'N/A'),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 100,
                        child: Text('Secondary Email:'),
                      ),
                      Expanded(
                        child: Text(
                          personnel.contactInfo['secondaryEmail'] ?? 'N/A',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Address
                  const Text(
                    'Address',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(personnel.address['street'] ?? 'N/A'),
                  Text(
                    '${personnel.address['city'] ?? ''}, ${personnel.address['state'] ?? ''} ${personnel.address['zip'] ?? ''}',
                  ),
                  Text(personnel.address['country'] ?? ''),

                  // Add dates if needed
                  if (personnel.dateOfRank != null ||
                      personnel.dateOfETS != null ||
                      personnel.lastJumpDate != null) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Important Dates',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    if (personnel.dateOfRank != null)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 100,
                            child: Text('Date of Rank:'),
                          ),
                          Expanded(
                            child: Text(
                              '${personnel.dateOfRank!.month}/${personnel.dateOfRank!.day}/${personnel.dateOfRank!.year}',
                            ),
                          ),
                        ],
                      ),
                    if (personnel.dateOfETS != null)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 100, child: Text('ETS Date:')),
                          Expanded(
                            child: Text(
                              '${personnel.dateOfETS!.month}/${personnel.dateOfETS!.day}/${personnel.dateOfETS!.year}',
                            ),
                          ),
                        ],
                      ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        InteractiveViewer(
          transformationController:
              _transformationController, // Control zoom/pan programmatically
          constrained: false,
          boundaryMargin: EdgeInsets.all(
            _screenSize.width,
          ), // Allow panning beyond screen bounds
          minScale: 0.1,
          maxScale: 5.0,
          child: GraphView(
            graph: graph,
            algorithm: BuchheimWalkerAlgorithm(
              builder,
              TreeEdgeRenderer(builder),
            ),
            builder: (Node node) {
              final personnel = widget.personnelList.firstWhere(
                (p) => p.id == node.key!.value,
                orElse:
                    () => Personnel(
                      // Default/fallback Personnel
                      id: '',
                      firstName: 'Unknown',
                      lastName: '',
                      middleInitial: '',
                      rank: '',
                      role: '',
                      squadTeam: '',
                      contactInfo: {},
                      address: {},
                    ),
              );

              return _buildPersonnelCard(personnel);
            },
          ),
        ),

        // Controls for the diagram
        Positioned(
          bottom: 16,
          right: 16,
          child: Column(
            children: [
              FloatingActionButton(
                heroTag: 'zoomIn',
                mini: true,
                child: const Icon(Icons.add),
                onPressed: () {
                  // Use TransformationController to zoom in
                  final currentScale =
                      _transformationController.value.getMaxScaleOnAxis();
                  final newScale = (currentScale + 0.1).clamp(0.1, 5.0);
                  _transformationController.value =
                      Matrix4.identity()..scale(newScale);
                  // Note: This simple scale might reset position. More complex logic needed for zoom towards center.
                },
              ),
              const SizedBox(height: 8),
              FloatingActionButton(
                heroTag: 'zoomOut',
                mini: true,
                child: const Icon(Icons.remove),
                onPressed: () {
                  // Use TransformationController to zoom out
                  final currentScale =
                      _transformationController.value.getMaxScaleOnAxis();
                  final newScale = (currentScale - 0.1).clamp(0.1, 5.0);
                  _transformationController.value =
                      Matrix4.identity()..scale(newScale);
                  // Note: This simple scale might reset position.
                },
              ),
              const SizedBox(height: 8),
              FloatingActionButton(
                heroTag: 'reset',
                mini: true,
                child: const Icon(Icons.restart_alt),
                onPressed: () {
                  // Reset transformation
                  _transformationController.value = Matrix4.identity();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPersonnelCard(Personnel personnel) {
    if (personnel.id.isEmpty) return const SizedBox();

    // Determine background color based on rank or role
    Color cardColor = _getCardColorByRank(personnel.rank);

    return GestureDetector(
      onTap: () => _showPersonnelDetails(context, personnel),
      child: Container(
        padding: const EdgeInsets.all(4),
        width: 180, // Fixed width for consistent layout
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Rank and name
            Text(
              personnel.rank,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            Text(
              personnel.fullName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.white,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Divider(color: Colors.white70, height: 8, thickness: 1),
            // Role
            Text(
              personnel.role,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: Colors.white),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            // Squad/Team
            Text(
              personnel.squadTeam,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                fontStyle: FontStyle.italic,
                color: Colors.white70,
              ),
            ),
            // Add tap indicator
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Icon(Icons.info_outline, color: Colors.white70, size: 14),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCardColorByRank(String rank) {
    // Colors based on military rank structure
    if (rank.contains('Lieutenant')) {
      return Colors.blue[800]!; // Officers
    } else if (rank.contains('Sergeant')) {
      return Colors.green[700]!; // NCOs
    } else if (rank.contains('Corporal')) {
      return Colors.green[600]!; // Junior NCOs
    } else if (rank.contains('Private') || rank.contains('Specialist')) {
      return Colors.blueGrey[600]!; // Enlisted
    } else if (rank.contains('Cadet')) {
      return Colors.purple[700]!; // Cadets
    } else {
      return Colors.grey[700]!; // Default
    }
  }
}
