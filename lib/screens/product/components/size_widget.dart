import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportscbr/models/item_size.dart';
import 'package:sportscbr/models/product/product.dart';

class SizeWidget extends StatelessWidget {
  const SizeWidget(this.itemSize, {super.key});

  final ItemSize itemSize;

  @override
  Widget build(BuildContext context) {
    final product = context.watch<Product>();
    final selected = itemSize == product.selectedSize;

    Color color;

    if (!itemSize.hasStock) {
      color = Colors.red.withAlpha(50);
    } else if (selected) {
      color = const Color.fromARGB(100, 73, 5, 182);
    } else {
      color = Colors.green;
    }
    return GestureDetector(
      onTap: () {
        if (itemSize.hasStock) {
          product.selectedSize = itemSize;
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: color,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: color,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Text(
                itemSize.name ?? '',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "R\$ ${itemSize.price}",
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
