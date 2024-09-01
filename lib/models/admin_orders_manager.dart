import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sportscbr/models/data_user.dart';
import 'package:sportscbr/models/orders.dart';

class AdminOrdersManager extends ChangeNotifier {
  final List<Orders> _orders = [];
  DataUser? userFilter;
  List<Status> statusFilter = [
    Status.preparing
  ];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  StreamSubscription? _subscription;

  void updateAdmin(bool adminEnabled) {
    _orders.clear();
    _subscription?.cancel();
    if (adminEnabled) {
      _listenToOrders();
    }
  }

  void _listenToOrders() {
    _subscription = firestore.collection('orders').snapshots().listen((event) {
      for (final changes in event.docChanges) {
        switch (changes.type) {
          case DocumentChangeType.added:
            _orders.add(Orders.fromDocument(changes.doc));
            break;
          case DocumentChangeType.modified:
            final modOrders = _orders.firstWhere((e) => e.orderId == changes.doc.id);
            modOrders.updateFromDocument(changes.doc);
            break;
          case DocumentChangeType.removed:
            debugPrint('Erro: Tentando remover o produto do banco de dados');
            break;

          default:
        }
      }
      notifyListeners();
    });
  }

  List<Orders> get filteredOrders {
    List<Orders> output = _orders.reversed.toList();

    if (userFilter != null) {
      output = output.where((o) => o.userId == userFilter!.id).toList();
    }

    return output.where((o) => statusFilter.contains(o.status)).toList();
  }

  void setUserFilter(DataUser? dataUser) {
    userFilter = dataUser;
    notifyListeners();
  }

  void setStatusFilter({Status? status, bool? enabled}) {
    if (enabled!) {
      statusFilter.add(status!);
    } else {
      statusFilter.remove(status);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }
}
