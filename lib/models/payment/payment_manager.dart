import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:mp_integration/mp_integration.dart';
import 'package:sportscbr/services/payment/payment_service.dart' as globalKeys;

class PaymentManager extends ChangeNotifier {
  Future<Map<String, dynamic>> createPreference() async {
    var mp = MP(globalKeys.clientId, globalKeys.clientSecret);

    var preference = {
      "items": [
        {
          "title": "Teste",
          "quantity": 1,
          "currency_id": "BRL",
          "unit_price": 100
        }
      ],
      "back_urls": {
        "success": "sportscbr://confirmation",
      },
      "auto_return": "approved",
    };

    var result = await mp.createPreference(preference);
    return result;
  }

  Future<String?> initMercadoPago() async {
    try {
      final result = await createPreference();
      if (result != null && result['response'] != null) {
        final initPoint = result['response']['sandbox_init_point'];
        final id = result['response']['id'];

        print(result['response']['sandbox_init_point']);
        launchMercadoPago(initPoint);
      } else {
        print('Resultado ou resposta nulos');
        return null;
      }
    } catch (e) {
      print('Erro ao criar preferência: $e');
      return null;
    }
    return null;
  }

  Future<void> launchMercadoPago(String url) async {
    try {
      await launchUrl(
        Uri.parse(url),
        customTabsOptions: CustomTabsOptions(
          shareState: CustomTabsShareState.on,
          showTitle: false,
          urlBarHidingEnabled: false,
        ),
      );
    } catch (erro) {
      print("Não foi possível abrir o navegador: $erro");
    }
  }

  bool getPayment() {
    if (condition) {
      return true;
    }

    return false;
  }
}
