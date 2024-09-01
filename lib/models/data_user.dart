import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportscbr/models/address.dart';

class DataUser {
  DataUser({this.name, this.email, this.password, this.confirmPassword, this.id});

  DataUser.fromDocument(DocumentSnapshot document) {
    id = document.id;
    final data = document.data() as Map<String, dynamic>;

    name = document['name'];
    email = document['email'];
    if (data.containsKey('address')) {
      address = Address.fromMap(document['address'] as Map<String, dynamic>);
    }
  }

  String? id;
  String? name;
  String? email;
  String? password;
  String? confirmPassword;

  bool admin = false;

  Address? address;

  DocumentReference get firestoreRef => FirebaseFirestore.instance.doc('users/$id');
  CollectionReference get cartReference => firestoreRef.collection('cart');

  Future<void> saveData() async {
    await firestoreRef.set(toMap());
  }

  void setAddress(Address address) {
    this.address = address;

    saveData();
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      if (address != null) 'address': address!.toMap(),
    };
  }
}
