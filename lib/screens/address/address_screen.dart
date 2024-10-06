import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportscbr/common/price_card.dart';
import 'package:sportscbr/models/cart/cart_manager.dart';
import 'package:sportscbr/screens/address/components/address_card.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Entrega"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const AddressCard(),
          Consumer<CartManager>(
            builder: (_, cartManager, __) {
              return PriceCard(
                "Continuar para o pagamento",
                onPressed: cartManager.isAddressValid
                    ? () {
                        Navigator.of(context).pushNamed('/checkout');
                        // Navigator.of(context).pushReplacement(
                        //   MaterialPageRoute(
                        //     builder: (context) => PaymentBricksScreen(),
                        //   ),
                        // );
                      }
                    : null,
              );
            },
          )
        ],
      ),
    );
  }
}
