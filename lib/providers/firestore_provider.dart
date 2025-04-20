import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:psg_leaders_book/models/personnel.dart';
import 'package:psg_leaders_book/models/mal.dart';

class FirestoreProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? get userId => FirebaseAuth.instance.currentUser?.uid;

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
              snapshot.docs
                  .map((doc) => Mal.fromFirestore(doc.data(), doc.id))
                  .toList(),
        );
  }

  Future<void> addPersonnel(Personnel personnel) async {
    if (userId == null) return;
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('personnel')
        .doc(personnel.id)
        .set(personnel.toFirestore());
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
}
