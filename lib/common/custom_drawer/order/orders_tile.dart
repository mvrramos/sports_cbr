import 'package:flutter/material.dart';
import 'package:sportscbr/common/custom_drawer/order/cancel_orders_dialog.dart';
import 'package:sportscbr/common/custom_drawer/order/export_address_dialog.dart';
import 'package:sportscbr/common/custom_drawer/order/orders_product_tile.dart';
import 'package:sportscbr/models/orders.dart';

class OrdersTile extends StatelessWidget {
  const OrdersTile(this.orders, {this.showControls = false, super.key});

  final Orders orders;
  final bool showControls;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16),
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  orders.formattedId,
                  style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
                ),
                Text(
                  "R\$ ${orders.price!.toStringAsFixed(2)}",
                  style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
                ),
                // TODO Implementar status
              ],
            ),
            Text(
              orders.statusText,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: orders.status == Status.canceled ? Colors.red : Colors.grey,
              ),
            ),
          ],
        ),
        children: [
          Column(
            children: orders.items!.map((e) {
              return OrdersProductTile(e);
            }).toList(),
          ),
          if (showControls && orders.status != Status.canceled)
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => CancelOrdersDialog(orders),
                      );
                    },
                    style: flatButtonStyle,
                    child: const Text(
                      "Cancelar",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: orders.back,
                    style: flatButtonStyle,
                    child: const Text(
                      "Recuar",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: orders.advance,
                    style: flatButtonStyle,
                    child: const Text(
                      "Avançar",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => ExportAddressDialog(orders.address!),
                      );
                    },
                    style: flatButtonStyle,
                    child: const Text(
                      "Endereço",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
