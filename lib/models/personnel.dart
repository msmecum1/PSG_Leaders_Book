class Personnel {
  final String id;
  final String firstName;
  final String middleInitial;
  final String lastName;
  final String rank;
  final String role;
  final String unit;
  final String? reportsTo;
  final Map<String, String> contactInfo;
  final Map<String, String> address;

  Personnel({
    required this.id,
    required this.firstName,
    required this.middleInitial,
    required this.lastName,
    required this.rank,
    required this.role,
    required this.unit,
    this.reportsTo,
    required this.contactInfo,
    required this.address,
  });

  factory Personnel.fromFirestore(Map<String, dynamic> data, String id) {
    return Personnel(
      id: id,
      firstName: data['firstName'] ?? '',
      middleInitial: data['middleInitial'] ?? '',
      lastName: data['lastName'] ?? '',
      rank: data['rank'] ?? '',
      role: data['role'] ?? '',
      unit: data['unit'] ?? '',
      reportsTo: data['reportsTo'],
      contactInfo: Map<String, String>.from(data['contactInfo'] ?? {}),
      address: Map<String, String>.from(data['address'] ?? {}),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'firstName': firstName,
      'middleInitial': middleInitial,
      'lastName': lastName,
      'rank': rank,
      'role': role,
      'unit': unit,
      'reportsTo': reportsTo,
      'contactInfo': contactInfo,
      'address': address,
    };
  }

  String get fullName => '$lastName, $firstName $middleInitial';
}
