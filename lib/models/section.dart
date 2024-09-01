import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sportscbr/models/section_item.dart';
import 'package:uuid/uuid.dart';

class Section extends ChangeNotifier {
  Section({
    this.sid,
    this.name,
    this.type,
    List<SectionItem>? items,
    List<SectionItem>? originalItems,
  })  : items = items ?? [],
        originalItems = originalItems ?? List.from(items ?? []);

  String? sid;
  String? name;
  String? type;
  List<SectionItem> items = [];
  List<SectionItem> originalItems = [];

  String? _error;
  String? get error => _error;
  set error(String? value) {
    _error = value;
    notifyListeners();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentReference get firestoreRef => firestore.doc('home/$sid');
  final FirebaseStorage storage = FirebaseStorage.instance;
  Reference get storageRef => storage.ref().child('/home/$sid');

  Section.fromDocument(DocumentSnapshot document) {
    sid = document.id;
    name = document['name'] as String? ?? '';
    type = document['type'] as String? ?? '';
    items = (document['items'] as List).map((i) => SectionItem.fromMap(i)).toList();
  }

  Section clone() {
    return Section(
      sid: sid,
      name: name,
      type: type,
      items: items.map((e) => e.clone()).toList(),
    );
  }

  void addItem(SectionItem item) {
    items.add(item);
    notifyListeners();
  }

  void removeItem(SectionItem item) {
    items.remove(item);
    notifyListeners();
  }

  bool valid() {
    if (name == null || name!.isEmpty) {
      error = "Título inválido";
    } else if (items.isEmpty) {
      error = "Insira ao menos uma imagem";
    } else {
      error = null;
    }
    return error == null;
  }

  Future<void> save(int pos) async {
    final Map<String, dynamic> data = {
      'name': name,
      'type': type,
      'pos': pos,
    };

    if (sid == null) {
      final doc = await firestore.collection('home').add(data);
      sid = doc.id;
    } else {
      await firestoreRef.update(data);
    }

    for (final item in items) {
      if (item.image is File) {
        final UploadTask task = storageRef.child(const Uuid().v1()).putFile(item.image as File);
        final TaskSnapshot snapshot = await task.whenComplete(() {});
        final String url = await snapshot.ref.getDownloadURL();
        item.image = url;
      }
    }

    for (final original in originalItems) {
      if (!items.contains(original)) {
        try {
          final ref = storage.refFromURL(original.image as String);
          await ref.delete();
        } catch (error) {}
      }
    }

    final Map<String, dynamic> itemsData = {
      'items': items.map((e) => e.toMap()).toList(),
    };
    await firestoreRef.update(itemsData);
    notifyListeners();
  }

  Future<void> delete() async {
    await firestoreRef.delete();
    for (final item in items) {
      try {
        final ref = storage.refFromURL(item.image as String);
        await ref.delete();
      } catch (error) {}
    }
  }

  @override
  String toString() {
    return 'Section{name: $name, type: $type, items: $items}';
  }
}
