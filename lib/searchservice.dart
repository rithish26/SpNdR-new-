import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchService {
  searchByName() {
    return FirebaseFirestore.instance
        .collection('userdata')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('Sheets')
        .get();
  }

  searchByt(String refid) {
    return FirebaseFirestore.instance
        .collection('userdata')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('Sheets')
        .doc(refid)
        .collection('Transactions')
        .orderBy('time', descending: true)
        .get();
  }

  searchbyuser() {
    return FirebaseFirestore.instance
        .collection('USERS')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('sheetids')
        .get();
  }
}
