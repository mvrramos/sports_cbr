import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sportscbr/models/data_user.dart';
import 'package:sportscbr/models/orders.dart';

class OrdersManager extends ChangeNotifier {
  DataUser? dataUser;
  List<Orders> orders = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  StreamSubscription? _subscription;

  void updateUser(DataUser? dataUser) {
    this.dataUser = dataUser;
    orders.clear();
    _subscription?.cancel();
    
    if (dataUser != null) {
      _listenToOrders();
    }
  }

  void _listenToOrders() {
    _subscription = firestore.collection('orders').where('user', isEqualTo: dataUser!.id).snapshots().listen((event) {
      orders.clear();
      for (final doc in event.docs) {
        orders.add(Orders.fromDocument(doc));
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }
}
