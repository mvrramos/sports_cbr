import 'package:flutter/material.dart';
import '../../common/custom_drawer/order/orders_product_tile.dart';
import '../../models/orders/orders.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen(this.orders, {super.key});

  final Orders orders;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pedido confirmado"),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      orders.formattedId,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                    ),
                    Text(
                      'R\$ ${orders.price!.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
              ),
              Column(
                children: orders.items!.map((e) {
                  return OrdersProductTile(e);
                }).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
