import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../common/custom_icon_button.dart';
import '../../../models/address.dart';
import '../../../models/cart/cart_manager.dart';

class CepInputField extends StatefulWidget {
  const CepInputField(this.address, {super.key});
  final Address address;

  @override
  State<CepInputField> createState() => _CepInputFieldState();
}

class _CepInputFieldState extends State<CepInputField> {
  final TextEditingController cepController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cartManager = context.watch<CartManager>();

    if (widget.address.zipCode == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            enabled: !cartManager.loading,
            controller: cepController,
            decoration: const InputDecoration(
              isDense: true,
              labelText: "CEP",
              hintText: "12.345-678",
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CepInputFormatter()
            ],
            keyboardType: TextInputType.number,
            validator: (cep) {
              if (cep!.isEmpty) {
                return "Campo obrigatório";
              } else if (cep.length != 10) {
                return "CEP inválido";
              }
              return null;
            },
          ),
          if (cartManager.loading)
            const LinearProgressIndicator(
              color: Color.fromARGB(100, 73, 5, 182),
              backgroundColor: Colors.transparent,
            ),
          ElevatedButton(
            onPressed: !cartManager.loading
                ? () async {
                    if (Form.of(context).validate()) {
                      try {
                        await context.read<CartManager>().getAddress(cepController.text);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("$e"),
                          backgroundColor: Colors.red,
                        ));
                      }
                    }
                  }
                : null,
            style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(200, 73, 5, 182)),
            child: const Text(
              "Calcular frete",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                "CEP: ${widget.address.zipCode}",
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
              ),
            ),
            CustomIconButton(
              Icons.edit,
              const Color.fromARGB(100, 73, 5, 182),
              () {
                context.read<CartManager>().removeAddress();
              },
            )
          ],
        ),
      );
    }
  }
}
