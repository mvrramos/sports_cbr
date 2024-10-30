

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart/cart_manager.dart';

class PriceCard extends StatelessWidget {
  const PriceCard(this.buttonText, {required this.onPressed, super.key});

  final String buttonText;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final cartManager = context.watch<CartManager>();
    final productsPrice = cartManager.productsPrice;
    final deliveryPrice = cartManager.deliveryPrice;
    final totalPrice = cartManager.totalPrice;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Resumo do pedido",
              textAlign: TextAlign.start,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Subtotal"),
                Text("R\$ $productsPrice", style: const TextStyle(fontSize: 16)),
              ],
            ),
            const Divider(),
            if (deliveryPrice != 0) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Entrega"),
                  Text("R\$ ${deliveryPrice.toStringAsFixed(2)}", style: const TextStyle(fontSize: 16)),
                ],
              ),
              const Divider(),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text("R\$ ${totalPrice.toStringAsFixed(2)}", style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(200, 73, 5, 182)),
              child: Text(
                buttonText,
                style: const TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
