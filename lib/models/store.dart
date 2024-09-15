import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sportscbr/models/address.dart';

class Store {
  Store.fromDocument(DocumentSnapshot doc) {
    name = doc['name'] as String?;
    image = doc['image'] as String?;
    phone = doc['phone'] as String?;

    final addressMap = doc['address'] as Map<String, dynamic>?;
    if (addressMap != null) {
      address = Address.fromMap(addressMap);
    }

    final openingMap = doc['opening'] as Map<String, dynamic>?;
    if (openingMap != null) {
      opening = openingMap.map((key, value) {
        final timeString = value as String?;
        if (timeString?.isNotEmpty ?? false) {
          final splitted = timeString!.split(RegExp(r"[:-]"));

          return MapEntry(key, {
            "from": TimeOfDay(hour: int.parse(splitted[0]), minute: int.parse(splitted[1])),
            "to": TimeOfDay(hour: int.parse(splitted[2]), minute: int.parse(splitted[3])),
          });
        } else {
          return MapEntry(key, null);
        }
      });
    }
  }

  String? name;
  String? image;
  String? phone;
  Address? address;
  Map<String, Map<String, TimeOfDay>?>? opening;

  String get addressText => '${address!.street}, ${address!.number}${address!.complement!.isEmpty ? '- ${address!.complement}' : ''} - '
      '${address!.district}, ${address!.city}/${address!.state}';
}
