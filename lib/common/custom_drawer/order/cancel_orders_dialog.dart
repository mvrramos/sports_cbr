import 'package:flutter/material.dart';
import 'package:sportscbr/models/orders.dart';

class CancelOrdersDialog extends StatelessWidget {
  const CancelOrdersDialog(this.orders, {super.key});

  final Orders orders;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Cancelar pedido ${orders.formattedId}?",
        style: const TextStyle(color: Colors.red),
      ),
      content: const Text(
        "Essa ação não poderá ser desfeita",
        style: TextStyle(fontSize: 18),
      ),
      actions: [
        TextButton(
          onPressed: () {
            orders.cancel();
            Navigator.of(context).pop();
          },
          child: const Text("Cancelar"),
        ),
      ],
    );
  }
}
