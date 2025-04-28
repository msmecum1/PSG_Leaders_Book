// models/personnel.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Personnel {
  final String id;
  final String firstName;
  final String middleInitial;
  final String lastName;
  final String rank;
  final String role;
  final String squadTeam; // Changed from unit to squadTeam
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

  Personnel({
    required this.id,
    required this.firstName,
    required this.middleInitial,
    required this.lastName,
    required this.rank,
    required this.role,
    required this.squadTeam, // Updated
    this.reportsTo,
    required this.contactInfo,
    required this.address,
    this.dateOfBirth,
    this.dateOfRank,
    this.dateOfETS,
    this.lastJumpDate,
    this.numberOfJumps,
    this.lastNCOER,
  });

  factory Personnel.fromFirestore(Map<String, dynamic> data, String id) {
    return Personnel(
      id: id,
      firstName: data['firstName'] ?? '',
      middleInitial: data['middleInitial'] ?? '',
      lastName: data['lastName'] ?? '',
      rank: data['rank'] ?? '',
      role: data['role'] ?? '',
      squadTeam: data['squadTeam'] ?? '', // Updated
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
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'firstName': firstName,
      'middleInitial': middleInitial,
      'lastName': lastName,
      'rank': rank,
      'role': role,
      'squadTeam': squadTeam, // Updated
      'reportsTo': reportsTo,
      'contactInfo': contactInfo,
      'address': address,
      'dateOfBirth': dateOfBirth,
      'dateOfRank': dateOfRank,
      'dateOfETS': dateOfETS,
      'lastJumpDate': lastJumpDate,
      'numberOfJumps': numberOfJumps,
      'lastNCOER': lastNCOER,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'middleInitial': middleInitial,
      'rank': rank,
      'role': role,
      'squadTeam': squadTeam, // Updated
      'reportsTo': reportsTo,
      'contactInfo': contactInfo,
      'address': address,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'dateOfRank': dateOfRank?.toIso8601String(),
      'dateOfETS': dateOfETS?.toIso8601String(),
      'lastJumpDate': lastJumpDate?.toIso8601String(),
      'numberOfJumps': numberOfJumps,
      'lastNCOER': lastNCOER?.toIso8601String(),
    };
  }

  factory Personnel.fromMap(Map<String, dynamic> map, String documentId) {
    return Personnel(
      id: documentId,
      firstName: map['firstName'] ?? '',
      middleInitial: map['middleInitial'] ?? '',
      lastName: map['lastName'] ?? '',
      rank: map['rank'] ?? '',
      role: map['role'] ?? '',
      squadTeam: map['squadTeam'] ?? '', // Updated
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
    );
  }

  String get fullName => '$lastName, $firstName $middleInitial';
}
