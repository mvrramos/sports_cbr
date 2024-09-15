import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sportscbr/models/store.dart';

class StoreManager extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Store> stores = [];
  StoreManager() {
    _loadStoreList();
  }

  Future<void> _loadStoreList() async {
    final snapshot = await firestore.collection('store').get();

    stores = snapshot.docs.map((e) => Store.fromDocument(e)).toList();

    notifyListeners();
  }
}
