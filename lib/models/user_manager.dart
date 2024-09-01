import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportscbr/helpers/firebase_errors.dart';
import 'package:sportscbr/models/data_user.dart';

class UserManager extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user;
  DataUser? dataUser;

  bool _loading = false;
  bool get loading => _loading;
  bool get isLoggedIn => dataUser != null;

  UserManager() {
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser({User? user}) async {
    final User? currentUser = user ?? auth.currentUser;

    if (currentUser != null) {
      final DocumentSnapshot docUser = await firestore.collection('users').doc(currentUser.uid).get();

      if (docUser.exists) {
        dataUser = DataUser.fromDocument(docUser);
      }

      final docAdmin = await firestore.collection('admins').doc(dataUser?.id).get();
      if (docAdmin.exists) {
        dataUser?.admin = true;
      }
      // print(dataUser?.admin);
      notifyListeners();
    }
  }

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> signIn(DataUser dataUser, {Function(String)? onFail, Function? onSuccess}) async {
    loading = true;
    try {
      final result = await auth.signInWithEmailAndPassword(email: dataUser.email!, password: dataUser.password!);

      await _loadCurrentUser(user: result.user);

      if (onSuccess != null) {
        onSuccess();
      }
    } on FirebaseAuthException catch (error) {
      if (onFail != null) {
        onFail(getErrorString(error.code));
      }
    }
    loading = false;
  }

  Future<void> signUp({required DataUser dataUser, Function(String)? onFail, Function? onSuccess}) async {
    loading = true;
    try {
      final result = await auth.createUserWithEmailAndPassword(email: dataUser.email!, password: dataUser.password!);

      dataUser.id = result.user!.uid;
      await dataUser.saveData();

      if (onSuccess != null) {
        onSuccess();
      }
    } on FirebaseAuthException catch (error) {
      if (onFail != null) {
        onFail(getErrorString(error.code));
      }
    }
    loading = false;
  }

  Future<void> signOut() async {
    await auth.signOut();
    user = null;
    dataUser = null;
    notifyListeners();
  }

  bool get adminEnabled => dataUser != null && dataUser!.admin;
}
