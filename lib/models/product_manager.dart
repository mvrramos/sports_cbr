import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sportscbr/models/product.dart';

class ProductManager extends ChangeNotifier {
  ProductManager() {
    _loadAllProducts();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Product> allProducts = [];

  late String _search = '';
  String get search => _search;

  set search(String value) {
    _search = value;
    notifyListeners();
  }

  Future<void> _loadAllProducts() async {
    final QuerySnapshot snapProducts = await firestore.collection('products').get();

    allProducts = snapProducts.docs.map((product) => Product.fromDocument(product)).toList();

    notifyListeners();
  }

  List<Product> get filteredProducts {
    final List<Product> filteredProducts = [];

    if (search.isEmpty) {
      filteredProducts.addAll(allProducts);
    } else {
      filteredProducts.addAll(allProducts.where((p) => p.name!.toLowerCase().contains(search)));
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
}
