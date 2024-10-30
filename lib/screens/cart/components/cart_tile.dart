import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../common/custom_icon_button.dart';
import '../../../models/cart/cart_product.dart';

class CartTile extends StatelessWidget {
  const CartTile(this.cartProduct, {super.key});

  final CartProduct cartProduct;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: cartProduct,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushNamed('/product', arguments: cartProduct.product),
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.network(cartProduct.product?.images?.first ?? ''),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cartProduct.product?.name ?? '',
                          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            "Tamanho: ${cartProduct.size}",
                            style: const TextStyle(fontWeight: FontWeight.w300),
                          ),
                        ),
                        Consumer<CartProduct>(
                          builder: (_, cartProduct, __) {
                            if (cartProduct.hasStock) {
                              return Text(
                                "R\$ ${cartProduct.unitPrice}",
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              );
                            } else {
                              return const Text(
                                "Estoque indisponível",
                                style: TextStyle(color: Colors.red, fontSize: 12),
                              );
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
                Consumer<CartProduct>(
                  builder: (_, cartProduct, __) {
                    return Column(
                      children: [
                        CustomIconButton(
                          Icons.add,
                          Colors.green,
                          cartProduct.increment,
                        ),
                        Text(
                          '${cartProduct.quantity}',
                          style: const TextStyle(fontSize: 20),
                        ),
                        CustomIconButton(
                          Icons.remove,
                          cartProduct.quantity > 1 ? const Color.fromARGB(255, 73, 5, 182) : Colors.red,
                          cartProduct.decrement,
                        ),
                      ],
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
