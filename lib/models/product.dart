import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sportscbr/models/item_size.dart';
import 'package:uuid/uuid.dart';

class Product extends ChangeNotifier {
  Product({this.pid, this.name, this.description, this.category, this.images, this.sizes}) {
    images = images ?? [];
    sizes = sizes ?? [];
  }

  Product.fromDocument(DocumentSnapshot doc) {
    pid = doc.id;
    name = doc['name'];
    description = doc['description'];
    // category = doc['category'];
    images = List<String>.from(doc['images'] as List<dynamic>);
    sizes = (doc['sizes'] as List<dynamic>).map((s) => ItemSize.fromMap(s as Map<String, dynamic>)).toList();
  }
  String? pid;
  String? name;
  String? description;
  String? category;
  List<String>? images;
  List<ItemSize>? sizes;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  List<dynamic>? newImages;

  ItemSize? _selectedSize;
  ItemSize? get selectedSize => _selectedSize;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentReference get firestoreRef => firestore.doc('products/$pid');

  final FirebaseStorage storage = FirebaseStorage.instance;
  Reference get storageRef => storage.ref().child('products').child(pid!);

  set selectedSize(ItemSize? value) {
    _selectedSize = value;
    notifyListeners();
  }

  int get totalStock {
    int stock = 0;
    for (final size in sizes!) {
      stock += size.stock!;
    }
    return stock;
  }

  bool get hasStock {
    return totalStock > 0;
  }

  num get basePrice {
    num lowest = double.infinity;
    for (final size in sizes!) {
      if (size.price! < lowest && size.hasStock) {
        lowest = size.price!;
      }
    }
    return lowest;
  }

  ItemSize? findSize(String name) {
    try {
      return sizes!.firstWhere((s) => s.name == name);
    } catch (error) {
      return null;
    }
  }

  List<Map<String, dynamic>> exportSizeList() {
    return sizes!.map((size) => size.toMap()).toList();
  }

  Future<void> save() async {
    loading = true;

    final Map<String, dynamic> data = {
      'name': name,
      'description': description,
      // 'category': category,
      'images': images,
      'sizes': exportSizeList(),
    };

    if (pid == null) {
      final doc = await firestore.collection('products').add(data);
      pid = doc.id;
    } else {
      await firestoreRef.update(data);
    }

    final List<String> updateImages = [];

    for (final newImage in newImages!) {
      if (images!.contains(newImage)) {
        updateImages.add(newImage as String);
      } else {
        final UploadTask task = storageRef.child(const Uuid().v1()).putFile(newImage);
        final TaskSnapshot snapshot = await task.whenComplete(() {});
        final String url = await snapshot.ref.getDownloadURL();
        updateImages.add(url);
      }
    }
    for (final image in images!) {
      if (!newImages!.contains(image) && image.contains('firebase')) {
        try {
          final ref = storage.refFromURL(image);
          ref.delete();
        } catch (error) {
          ScaffoldMessenger(
              child: SnackBar(
            backgroundColor: Colors.red,
            content: Text("Erro ao excluir imagem $image", style: const TextStyle(color: Colors.white)),
          ));
        }
      }
    }

    await firestoreRef.update({
      'images': updateImages
    });
    images = updateImages;

    loading = false;
  }

  Product clone() {
    return Product(
      pid: pid,
      name: name,
      description: description,
      category: category,
      images: List.from(images!),
      sizes: sizes!.map((e) => e.clone()).toList(),
    );
  }

  @override
  String toString() => 'Product{pid: $pid, name: $name, description: $description, images: $images}';
}
