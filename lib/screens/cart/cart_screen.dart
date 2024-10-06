import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportscbr/common/login_card.dart';
import 'package:sportscbr/common/price_card.dart';
import 'package:sportscbr/models/cart/cart_manager.dart';
import 'package:sportscbr/screens/cart/components/cart_tile.dart';
import 'package:sportscbr/screens/cart/components/empty_card.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Carrinho"),
        centerTitle: true,
      ),
      body: Consumer<CartManager>(
        builder: (_, cartManager, __) {
          if (cartManager.dataUser == null) {
            return const LoginCard();
          }
          if (cartManager.items.isEmpty) {
            return const EmptyCard(
              iconData: Icons.remove_shopping_cart,
              title: "Nenhum item no carrinho",
            );
          }
          return ListView(
            children: [
              Column(
                children: cartManager.items.map((cartProduct) => CartTile(cartProduct)).toList(),
              ),
              PriceCard(
                "Continuar para entrega",
                onPressed: cartManager.isCartValid
                    ? () {
                        Navigator.of(context).pushNamed('/address');
                      }
                    : null,
              ),
            ],
          );
        },
      ),
    );
  }
}
