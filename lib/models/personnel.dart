// lib\models\personnel.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Personnel {
  final String id;
  final String firstName;
  final String middleInitial; // Required
  final String lastName; // Required
  final String rank; // Required
  final String role; // Required
  final String squadTeam;
  final String? reportsTo;
  final Map<String, String> contactInfo;
  final Map<String, String> address;

  // Military-specific fields
  final DateTime? dateOfBirth;
  final DateTime? dateOfRank;
  final DateTime? dateOfETS;
  final DateTime? lastJumpDate;
  final int? numberOfJumps;
  final DateTime? lastNCOER;

  // Flagging Fields
  final bool isFlagged;
  final String? flagNotes;
  final DateTime? flagDate; // Date the flag was set or last updated

  Personnel({
    required this.id,
    required this.firstName,
    required this.middleInitial,
    required this.lastName,
    required this.rank,
    required this.role,
    required this.squadTeam,
    this.reportsTo,
    required this.contactInfo,
    required this.address,
    this.dateOfBirth,
    this.dateOfRank,
    this.dateOfETS,
    this.lastJumpDate,
    this.numberOfJumps,
    this.lastNCOER,
    this.isFlagged = false, // Default to not flagged
    this.flagNotes,
    this.flagDate,
  });

  factory Personnel.fromFirestore(Map<String, dynamic> data, String id) {
    return Personnel(
      id: id,
      firstName: data['firstName'] ?? '',
      middleInitial: data['middleInitial'] ?? '',
      lastName: data['lastName'] ?? '',
      rank: data['rank'] ?? '',
      role: data['role'] ?? '',
      squadTeam: data['squadTeam'] ?? '',
      reportsTo: data['reportsTo'],
      contactInfo: Map<String, String>.from(data['contactInfo'] ?? {}),
      address: Map<String, String>.from(data['address'] ?? {}),
      dateOfBirth:
          data['dateOfBirth'] != null
              ? (data['dateOfBirth'] as Timestamp).toDate()
              : null,
      dateOfRank:
          data['dateOfRank'] != null
              ? (data['dateOfRank'] as Timestamp).toDate()
              : null,
      dateOfETS:
          data['dateOfETS'] != null
              ? (data['dateOfETS'] as Timestamp).toDate()
              : null,
      lastJumpDate:
          data['lastJumpDate'] != null
              ? (data['lastJumpDate'] as Timestamp).toDate()
              : null,
      numberOfJumps: data['numberOfJumps'],
      lastNCOER:
          data['lastNCOER'] != null
              ? (data['lastNCOER'] as Timestamp).toDate()
              : null,
      // Flagging fields
      isFlagged: data['isFlagged'] ?? false,
      flagNotes: data['flagNotes'],
      flagDate:
          data['flagDate'] != null
              ? (data['flagDate'] as Timestamp).toDate()
              : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'firstName': firstName,
      'middleInitial': middleInitial,
      'lastName': lastName,
      'rank': rank,
      'role': role,
      'squadTeam': squadTeam,
      'reportsTo': reportsTo,
      'contactInfo': contactInfo,
      'address': address,
      'dateOfBirth': dateOfBirth,
      'dateOfRank': dateOfRank,
      'dateOfETS': dateOfETS,
      'lastJumpDate': lastJumpDate,
      'numberOfJumps': numberOfJumps,
      'lastNCOER': lastNCOER,
      // Flagging fields
      'isFlagged': isFlagged,
      'flagNotes': flagNotes,
      'flagDate': flagDate,
    };
  }

  // Update toMap and fromMap as well if you use them for other purposes
  Map<String, dynamic> toMap() {
    return {
      'id': id, // It's common to include id in toMap as well
      'firstName': firstName,
      'middleInitial': middleInitial, // Added
      'lastName': lastName, // Added
      'rank': rank, // Added
      'role': role, // Added
      'squadTeam': squadTeam,
      'reportsTo': reportsTo,
      'contactInfo': contactInfo,
      'address': address,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'dateOfRank': dateOfRank?.toIso8601String(),
      'dateOfETS': dateOfETS?.toIso8601String(),
      'lastJumpDate': lastJumpDate?.toIso8601String(),
      'numberOfJumps': numberOfJumps,
      'lastNCOER': lastNCOER?.toIso8601String(),
      // Flagging fields
      'isFlagged': isFlagged,
      'flagNotes': flagNotes,
      'flagDate': flagDate?.toIso8601String(),
    };
  }

  factory Personnel.fromMap(Map<String, dynamic> map, String documentId) {
    return Personnel(
      id: documentId, // Use documentId if 'id' is not in map, or map['id']
      firstName: map['firstName'] ?? '',
      middleInitial: map['middleInitial'] ?? '', // Added
      lastName: map['lastName'] ?? '', // Added
      rank: map['rank'] ?? '', // Added
      role: map['role'] ?? '', // Added
      squadTeam: map['squadTeam'] ?? '',
      reportsTo: map['reportsTo'],
      contactInfo: Map<String, String>.from(map['contactInfo'] ?? {}),
      address: Map<String, String>.from(map['address'] ?? {}),
      dateOfBirth:
          map['dateOfBirth'] != null
              ? DateTime.tryParse(map['dateOfBirth'])
              : null,
      dateOfRank:
          map['dateOfRank'] != null
              ? DateTime.tryParse(map['dateOfRank'])
              : null,
      dateOfETS:
          map['dateOfETS'] != null ? DateTime.tryParse(map['dateOfETS']) : null,
      lastJumpDate:
          map['lastJumpDate'] != null
              ? DateTime.tryParse(map['lastJumpDate'])
              : null,
      numberOfJumps: map['numberOfJumps'],
      lastNCOER:
          map['lastNCOER'] != null ? DateTime.tryParse(map['lastNCOER']) : null,
      // Flagging fields
      isFlagged: map['isFlagged'] ?? false,
      flagNotes: map['flagNotes'],
      flagDate:
          map['flagDate'] != null ? DateTime.tryParse(map['flagDate']) : null,
    );
  }

  String get fullName => '$lastName, $firstName $middleInitial';
}
