import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:psg_leaders_book/models/personnel.dart';
import 'package:psg_leaders_book/models/mal.dart';
import 'package:logger/logger.dart';

class FirestoreProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? get userId => FirebaseAuth.instance.currentUser?.uid;
  final String _collectionPath = 'personnel';

  final logger = Logger(
    printer: PrettyPrinter(
      methodCount: 1,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.none,
    ),
  );

  final List<Personnel> _personnelList = [];

  List<Personnel> get personnelList => _personnelList;

  Stream<List<Personnel>> getPersonnel() {
    if (userId == null) return Stream.value([]);
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('personnel')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => Personnel.fromFirestore(doc.data(), doc.id))
                  .toList(),
        );
  }

  Stream<List<Mal>> getMalItems() {
    if (userId == null) return Stream.value([]);
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('mal')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Mal.fromFirestore(doc)).toList(),
        );
  }

  Future<void> addPersonnel(Personnel personnel) async {
    if (userId == null) return;
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('personnel')
        .add(personnel.toFirestore());
    notifyListeners();
  }

  Future<void> addMal(Mal mal) async {
    if (userId == null) return;
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('mal')
        .add(mal.toFirestore());
    notifyListeners();
  }

  Future<void> updatePersonnel(Personnel person) async {
    if (userId == null) return;
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('personnel')
          .doc(person.id)
          .update(person.toFirestore());
      int index = _personnelList.indexWhere((p) => p.id == person.id);
      if (index != -1) {
        _personnelList[index] = person;
        notifyListeners();
      }
    } catch (e, stackTrace) {
      logger.e('Error updating personnel', error: e, stackTrace: stackTrace);
    }
  }

  Future<void> updateMal(Mal mal) async {
    if (userId == null) return;
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('mal')
        .doc(mal.id)
        .update(mal.toFirestore());
    notifyListeners();
  }

  Stream<QuerySnapshot> fetchPersonnelStream() {
    return _firestore.collection(_collectionPath).snapshots();
  }

  Future<void> saveAttendanceData(
    String date,
    Map<String, String> statusMap,
  ) async {
    if (userId == null) return;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('attendance')
        .doc(date)
        .set({
          'date': date,
          'status': statusMap,
          'timestamp': FieldValue.serverTimestamp(),
        });

    notifyListeners();
  }

  // Get attendance data for a specific date
  Future<Map<String, String>?> getAttendanceData(String date) async {
    if (userId == null) return null;

    final docSnap =
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('attendance')
            .doc(date)
            .get();

    if (docSnap.exists && docSnap.data() != null) {
      final data = docSnap.data()!;
      final statusMap = data['status'] as Map<dynamic, dynamic>;
      return Map<String, String>.from(statusMap);
    }

    return null;
  }

  // Get all attendance dates
  Stream<List<String>> getAttendanceDates() {
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('attendance')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }

  Future<void> deletePersonnel(String id) async {
    if (userId == null) return;
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('personnel')
          .doc(id)
          .delete();
    } catch (e, stackTrace) {
      logger.e('Error deleting personnel', error: e, stackTrace: stackTrace);
    }
  }
}
