import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'stores.dart';

class StoresManager extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Stores> stores = [];

  Timer? _timer;

  StoresManager() {
    _loadStoreList();
    _startTimer();
  }

  Future<void> _loadStoreList() async {
    final snapshot = await firestore.collection('store').get();

    stores = snapshot.docs.map((e) => Stores.fromDocument(e)).toList();

    notifyListeners();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      _checkOpening();
    });
  }

  void _checkOpening() {
    for (final store in stores) {
      store.updateStatus();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();

    _timer?.cancel();
  }
}
