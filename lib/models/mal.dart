import 'package:cloud_firestore/cloud_firestore.dart';

class Mal {
  final String id;
  final String category;
  final String description;
  final String serialNumber;
  final String personnelAssigned;

  Mal({
    required this.id,
    required this.category,
    required this.description,
    required this.serialNumber,
    required this.personnelAssigned,
  });

  // Convert Mal object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'description': description,
      'serialNumber': serialNumber,
      'personnelAssigned': personnelAssigned,
    };
  }

  // Create Mal object from Firestore document snapshot
  factory Mal.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Mal(
      id: doc.id,
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      serialNumber: data['serialNumber'] ?? '',
      personnelAssigned: data['personnelAssigned'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    // Update to include all fields
    return {
      'category': category,
      'description': description,
      'serialNumber': serialNumber,
      'personnelAssigned': personnelAssigned,
    };
  }
}
