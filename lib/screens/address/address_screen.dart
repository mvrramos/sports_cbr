import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as custom_tabs;
import 'package:provider/provider.dart';
import 'package:sportscbr/common/price_card.dart';
import 'package:sportscbr/models/cart/cart_manager.dart';
import 'package:sportscbr/screens/address/components/address_card.dart';
import 'package:sportscbr/screens/checkout/components/cpf_field.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

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
          SizedBox(height: 8),
          CpfField(),
          Consumer<CartManager>(
            builder: (_, cartManager, __) {
              return PriceCard(
                "Continuar para o pagamento",
                onPressed: cartManager.isAddressValid
                    ? () {
                        _createAndLaunchPreference(context, cartManager);
                        // Navigator.of(context).pushNamed('/checkout');
                        // Navigator.of(context).pushReplacement(
                        //   MaterialPageRoute(
                        //     builder: (context) => PaymentBricksScreen(),
                        //   ),
                        // );
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

void _createAndLaunchPreference(BuildContext context, CartManager cartManager) async {
  try {
    Response<Map> response;
    Dio dio = Dio();

    final data = {
      'title': "Camisa - Flamengo",
      'unit_price': 200,
      'quantity': 3,
      'email': "teste@abcmail.com"
    };

    response = await dio.post('http://10.0.2.2:3000/create_preferences', data: data);

    final res = response.data;

    if (res != null && res.containsKey("url")) {
      final String url = res["url"];

      if (await url_launcher.canLaunchUrl(Uri.parse(url))) {
        await custom_tabs.launchUrl(Uri.parse(url));
      } else {
        throw 'Não foi possível lançar $url';
      }
    } else {
      throw 'Resposta inválida, "url" não encontrada';
    }
  } catch (e) {
    print('Erro: $e');
  }
}
