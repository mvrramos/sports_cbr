import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sportscbr/models/item_size.dart';
import 'package:sportscbr/models/product.dart';

class CartProduct extends ChangeNotifier {
  Product? _product;
  Product? get product => _product;
  set product(Product? value) {
    _product = value;
    notifyListeners();
  }

  String? id;
  String? productId;
  int quantity = 1;
  String? size;
  num? fixedPrice;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CartProduct.fromProduct(this._product) {
    productId = product?.pid;
    quantity = 1;
    size = product?.selectedSize?.name;
  }

  CartProduct.fromDocument(DocumentSnapshot docSnapshot) {
    id = docSnapshot.id;
    productId = docSnapshot['pid'] as String;
    quantity = docSnapshot['quantity'];
    size = docSnapshot['size'] as String;

    firestore.doc('products/$productId').get().then((doc) {
      product = Product.fromDocument(doc);
    });
  }

  CartProduct.fromMap(Map<String, dynamic> map) {
    productId = map['pid'] as String;
    quantity = map['quantity'] as int;
    size = map['size'] as String;
    fixedPrice = map['fixedPrice'] as num?;

    firestore.doc('products/$productId').get().then((doc) {
      product = Product.fromDocument(doc);
    });
  }

  ItemSize? get itemSize {
    if (size == null) {
      return null;
    }
    return product?.findSize(size!);
  }

  num get unitPrice {
    ItemSize? itemSize = product?.findSize(size!);
    return itemSize?.price ?? 0;
  }

  num get totalPrice => unitPrice * quantity;

  Map<String, dynamic> toCartItemMap() {
    return {
      'pid': productId,
      'quantity': quantity,
      'size': size,
    };
  }

  Map<String, dynamic> toOrderItemMap() {
    return {
      'pid': productId,
      'quantity': quantity,
      'size': size,
      'fixedPrice': fixedPrice ?? unitPrice,
    };
  }

  bool stackable(Product product) {
    return product.pid == productId && product.selectedSize?.name == size;
  }

  void increment() {
    quantity++;
    notifyListeners();
  }

  void decrement() {
    if (quantity > 1) {
      quantity--;
    } else {
      quantity = 0;
    }
    notifyListeners();
  }

  bool get hasStock {
    final size = itemSize;

    if (size == null) return false;

    return size.stock! >= quantity;
  }
}
