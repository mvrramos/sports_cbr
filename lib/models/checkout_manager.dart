import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sportscbr/models/cart/cart_manager.dart';
import 'package:sportscbr/models/orders/orders.dart';
import 'package:sportscbr/models/product/product.dart';

class CheckoutManager extends ChangeNotifier {
  CartManager cartManager = CartManager();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void updateCart(CartManager cartManager) {
    this.cartManager = cartManager;

    // print(cartManager.productsPrice);
  }

  Future<void> checkout({Function? onStockFail, Function? onSuccess}) async {
    loading = true;

    try {
      await _decrementStock();
    } catch (e) {
      onStockFail!(e);
      loading = false;
      return;
    }

    // TODO Processar pagamento

    final orderId = await _getOrderId();
    final order = Orders.fromCartManager(cartManager);

    order.orderId = orderId.toString();

    await order.save();
    cartManager.clear();
    onSuccess!(order);
    loading = false;
  }

  Future<int> _getOrderId() async {
    final ref = firestore.doc('aux/ordercounter');

    try {
      final result = await firestore.runTransaction((tx) async {
        final doc = await tx.get(ref);
        final orderId = doc['current'] as int;
        tx.update(ref, {
          'current': orderId + 1
        });
        return {
          'orderId': orderId
        };
      });
      return result['orderId'] as int;
    } catch (e) {
      debugPrint(e.toString());
      return Future.error("Falha ao gerar número do pedido");
    }
  }

  Future<void> _decrementStock() async {
    return firestore.runTransaction((tx) async {
      final List<Product> productsToUpdate = [];
      final List<Product> productsWithoutStock = [];

      for (final cartProduct in cartManager.items) {
        Product? product;

        if (productsToUpdate.any((p) => p.pid == cartProduct.productId)) {
          product = productsToUpdate.firstWhere((p) => p.pid == cartProduct.productId);
        } else {
          final doc = await tx.get(firestore.doc('products/${cartProduct.productId}'));
          product = Product.fromDocument(doc);
        }
        cartProduct.product = product;

        final size = product.findSize(cartProduct.size!);
        if (size != null && size.stock != null) {
          if (size.stock! - cartProduct.quantity < 0) {
            productsWithoutStock.add(product);
          } else {
            size.stock = (size.stock ?? 0) - cartProduct.quantity;
            productsToUpdate.add(product);
          }
        }
      }

      if (productsWithoutStock.isNotEmpty) {
        return productsWithoutStock.length > 1
            ? Future.error(
                '${productsWithoutStock.length} produtos sem estoque',
              )
            : Future.error(
                '${productsWithoutStock.length} produto sem estoque',
              );
      }

      for (final product in productsToUpdate) {
        tx.update(firestore.doc('products/${product.pid}'), {
          'sizes': product.exportSizeList()
        });
      }
    });
  }
}
