import 'package:cloud_firestore/cloud_firestore.dart';
import 'address.dart';

class DataUser {
  DataUser({this.name, this.email, this.password, this.confirmPassword, this.id, this.cpf});

  DataUser.fromDocument(DocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>;

    id = document.id;
    name = document['name'];
    email = document['email'];
    if (data.containsKey('cpf')) {
      cpf = document['cpf'];
    }
    if (data.containsKey('address')) {
      address = Address.fromMap(document['address'] as Map<String, dynamic>);
    }
  }

  String? id;
  String? name;
  String? email;
  String? cpf;
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

  void setCpf(String? cpf) {
    this.cpf = cpf;
    saveData();
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      if (address != null) 'address': address!.toMap(),
      if (cpf != null) 'cpf': cpf,
    };
  }
}
