import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/address.dart';
import '../../../models/cart/cart_manager.dart';
import 'address_input_field.dart';
import 'cep_input_field.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Consumer<CartManager>(
            builder: (_, cartManager, __) {
              final address = cartManager.address ?? Address();

              return Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Endereço de entrega",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    CepInputField(address),
                    AddressInputField(address),
                  ],
                ),
              );
            },
          )),
    );
  }
}
