import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'section/section.dart';

class HomeManager extends ChangeNotifier {
  final List<Section> _sections = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool editing = false;
  bool loading = false;
  List<Section> _editingSections = [];

  HomeManager() {
    _loadSections();
  }

  Future<void> _loadSections() async {
    firestore.collection('home').orderBy('pos').snapshots().listen((snapshot) {
      _sections.clear();
      for (final DocumentSnapshot document in snapshot.docs) {
        _sections.add(Section.fromDocument(document));
      }
      notifyListeners();
    });
  }

  List<Section> get sections {
    if (editing) {
      return _editingSections;
    } else {
      return _sections;
    }
  }

  void addSection(Section section) {
    _editingSections.add(section);
    notifyListeners();
  }

  void removeSection(Section section) {
    _editingSections.remove(section);
    notifyListeners();
  }

  void enterEditing() {
    editing = true;
    _editingSections = _sections.map((s) => s.clone()).toList();
    notifyListeners();
  }

  Future<void> saveEditing() async {
    bool valid = true;

    for (final section in _editingSections) {
      if (!section.valid()) valid = false;
      notifyListeners();
    }

    if (!valid) return;
    loading = true;
    notifyListeners();

    int pos = 0;

    for (final section in _editingSections) {
      await section.save(pos);
      pos++;
    }

    for (final section in List.from(_sections)) {
      if (!_editingSections.any((element) => element.sid == section.sid)) {
        await section.delete();
      }
    }

    loading = false;
    editing = false;
    notifyListeners();
  }

  void discardEditing() {
    editing = false;
    notifyListeners();
  }
}
