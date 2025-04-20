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

          final graph = Graph();
          final builder =
              BuchheimWalkerConfiguration()
                ..siblingSeparation = 100
                ..levelSeparation = 150
                ..orientation =
                    BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;

          final nodes = <String, Node>{};
          for (var personnel in personnelList) {
            nodes[personnel.id] = Node.Id(personnel.id);
            graph.addNode(nodes[personnel.id]!);
          }

          for (var personnel in personnelList) {
            if (personnel.reportsTo != null &&
                nodes[personnel.reportsTo] != null) {
              graph.addEdge(nodes[personnel.reportsTo]!, nodes[personnel.id]!);
            }
          }

          return GraphView(
            graph: graph,
            algorithm: BuchheimWalkerAlgorithm(
              builder,
              TreeEdgeRenderer(builder),
            ),
            builder: (Node node) {
              final personnel = personnelList.firstWhere(
                (p) => p.id == node.key!.value,
              );
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${personnel.fullName}\n${personnel.rank} - ${personnel.role}',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
