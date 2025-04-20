class Mal {
  final String id;
  final String itemName;
  final String status;
  final String dueDate;
  final String assignedTo;

  Mal({
    required this.id,
    required this.itemName,
    required this.status,
    required this.dueDate,
    required this.assignedTo,
  });

  factory Mal.fromFirestore(Map<String, dynamic> data, String id) {
    return Mal(
      id: id,
      itemName: data['itemName'] ?? '',
      status: data['status'] ?? '',
      dueDate: data['dueDate'] ?? '',
      assignedTo: data['assignedTo'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'itemName': itemName,
      'status': status,
      'dueDate': dueDate,
      'assignedTo': assignedTo,
    };
  }
}
