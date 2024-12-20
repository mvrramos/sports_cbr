import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'product.dart';

class ProductManager extends ChangeNotifier {
  ProductManager() {
    _loadAllProducts();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Product> allProducts = [];

  String _search = '';
  String get search => _search;

  set search(String value) {
    _search = value;
    notifyListeners();
  }

  Future<void> _loadAllProducts() async {
    final QuerySnapshot snapProducts = await firestore.collection('products').where('deleted', isEqualTo: false).get();

    allProducts = snapProducts.docs.map((product) => Product.fromDocument(product)).toList();

    notifyListeners();
  }

  List<Product> get filteredProducts {
    final List<Product> filteredProducts = [];

    if (search.isEmpty) {
      filteredProducts.addAll(allProducts);
    } else {
      filteredProducts.addAll(allProducts.where((p) => p.name!.toLowerCase().contains(search.toLowerCase())));
    }

    return filteredProducts;
  }

  Product? finProductById(String id) {
    try {
      return allProducts.firstWhere((p) => p.pid == id);
    } catch (e) {
      return null;
    }
  }

  void update(Product product) {
    allProducts.removeWhere((p) => p.pid == product.pid);
    allProducts.add(product);

    notifyListeners();
  }

  void delete(Product product) {
    product.delete();
    allProducts.removeWhere((p) => p.pid == product.pid);

    notifyListeners();
  }
}
