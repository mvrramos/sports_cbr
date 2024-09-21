import 'package:flutter/material.dart';

extension Extra on TimeOfDay {
  String formattedTime() {
    return '$hour:${minute.toString().padLeft(2, '0')}';
  }

  int toMinutes() => hour * 60 + 10;
}
