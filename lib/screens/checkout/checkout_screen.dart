import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportscbr/common/price_card.dart';
import 'package:sportscbr/models/cart_manager.dart';
import 'package:sportscbr/models/checkout_manager.dart';

class CheckoutScreen extends StatelessWidget {
  CheckoutScreen({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<CartManager, CheckoutManager>(
      create: (_) => CheckoutManager(),
      update: (_, cartManager, checkoutManager) => checkoutManager!..updateCart(cartManager),
      lazy: false,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          title: const Text("Pagamento"),
          centerTitle: true,
        ),
        body: Consumer<CheckoutManager>(
          builder: (_, checkoutManager, __) {
            if (checkoutManager.loading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Color.fromARGB(100, 73, 5, 182)),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Processando seu pagamento...",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
                    )
                  ],
                ),
              );
            }
            return ListView(
              children: [
                PriceCard(
                  "Finalizar pedido",
                  onPressed: () {
                    checkoutManager.checkout(onStockFail: (e) {
                      ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
                        SnackBar(
                          content: Text(
                            "$e",
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      Navigator.of(context).popUntil((route) => route.settings.name == '/cart');
                    }, onSuccess: (orders) {
                      Navigator.of(context).popUntil((route) => route.settings.name == '/');
                      Navigator.of(context).pushNamed('/confirmation', arguments: orders);
                      // context.read<PageManager>().setPage(2);
                    });
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}