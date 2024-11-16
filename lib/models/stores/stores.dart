import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sportscbr/helpers/extensions.dart';

import '../address.dart';

enum StoreStatus {
  closed,
  open,
  closing
}

class Stores {
  String? name;
  String? image;
  String? phone;
  Address? address;
  Map<String, Map<String, TimeOfDay>?>? opening;
  StoreStatus? status;

  Stores.fromDocument(DocumentSnapshot doc) {
    name = doc['name'] as String?;
    image = doc['image'] as String;
    phone = doc['phone'] as String;

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
    updateStatus();
  }

  String formattedPeriod(Map<String, TimeOfDay>? period) {
    if (period == null) return "A loja está fechada";

    return "${period['from']!.formattedTime()} - ${period['to']!.formattedTime()}";
  }

  String get addressText => '${address!.street}, loja ${address!.number}${address!.complement!.isNotEmpty ? ' - ${address!.complement}' : ''} - '
      '${address!.district}, ${address!.city}/${address!.state}';

  String get openingText {
    return 'Seg - Sexta: ${formattedPeriod(opening!['monfri'])}\n'
        'Sábado: ${formattedPeriod(opening!['saturday'])}\n'
        'Domingo: ${formattedPeriod(opening!['sunday'])}\n';
  }

  String get cleanPhone => phone!.replaceAll(RegExp(r"[^\d]"), "");

  String get statusText {
    switch (status) {
      case StoreStatus.closed:
        return "Fechada";
      case StoreStatus.open:
        return "Aberta";
      case StoreStatus.closing:
        return "Fechando";
      default:
        return '';
    }
  }

  void updateStatus() {
    final weekDay = DateTime.now().weekday;

    Map<String, TimeOfDay>? period;

    if (weekDay >= 1 && weekDay <= 5) {
      period = opening!['monfri'];
    } else if (weekDay == 6) {
      period = opening!['saturday'];
    } else {
      period = opening!['sunday'];
    }

    final now = TimeOfDay.now();

    if (period == null) {
      status = StoreStatus.closed;
    } else if (period['from']!.toMinutes() < now.toMinutes() && period['to']!.toMinutes() - 15 > now.toMinutes()) {
      status = StoreStatus.open;
    } else if (period['from']!.toMinutes() < now.toMinutes() && period['to']!.toMinutes() > now.toMinutes()) {
      status = StoreStatus.closing;
    } else {
      status = StoreStatus.closed;
    }
  }
}
