import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportscbr/models/payment/payment_manager.dart';

import '../../common/price_card.dart';
import '../../models/cart/cart_manager.dart';
import 'components/address_card.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final paymentManager = context.watch<PaymentManager>();

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
          SizedBox(height: 8),
          // CpfField(),
          Consumer<CartManager>(
            builder: (_, cartManager, __) {
              return PriceCard(
                "Continuar para o pagamento",
                onPressed: cartManager.isAddressValid
                    ? () {
                        paymentManager.initMercadoPago();
                        
                      }
                    : null,
              );
            },
          ),
        ],
      ),
    );
  }
}
