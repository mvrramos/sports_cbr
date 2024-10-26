// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:sportscbr/common/price_card.dart';
// import 'package:sportscbr/models/cart/cart_manager.dart';
// import 'package:sportscbr/models/checkout_manager.dart';
// import 'package:sportscbr/models/payment/credit_card.dart';
// import 'package:sportscbr/screens/checkout/components/credit_card_widget.dart';
// import 'package:url_launcher/url_launcher.dart';

// class CheckoutScreen extends StatelessWidget {
//   CheckoutScreen({super.key});
//   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();

//   final CreditCard creditCard = CreditCard();
//   final dio = Dio();

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProxyProvider<CartManager, CheckoutManager>(
//       create: (_) => CheckoutManager(),
//       update: (_, cartManager, checkoutManager) => checkoutManager!..updateCart(cartManager),
//       lazy: false,
//       child: Scaffold(
//         key: scaffoldKey,
//         appBar: AppBar(
//           backgroundColor: Colors.black,
//           foregroundColor: Colors.white,
//           title: const Text("Pagamento"),
//           centerTitle: true,
//         ),
//         body: Consumer<CheckoutManager>(
//           builder: (_, checkoutManager, __) {
//             if (checkoutManager.loading) {
//               return const Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     CircularProgressIndicator(
//                       valueColor: AlwaysStoppedAnimation(Color.fromARGB(100, 73, 5, 182)),
//                     ),
//                     SizedBox(height: 16),
//                     Text(
//                       "Processando seu pagamento...",
//                       style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
//                     )
//                   ],
//                 ),
//               );
//             }
//             return Form(
//               key: formKey,
//               child: ListView(
//                 children: [
//                   CreditCardWidget(creditCard),
//                   PriceCard(
//                     "Finalizar pedido",
//                     onPressed: () async {
//                       if (formKey.currentState!.validate()) {
//                         formKey.currentState!.save();

//                         try {
//                           Response<Map> response;
//                           response = await dio.post('http://10.0.2.2:3000/create_preferences');
//                           final res = response.data;

//                           if (res != null && res.containsKey("url")) {
//                             final String url = res["url"];

//                             if (await canLaunchUrl(Uri.parse(url))) {
//                               await launchUrl(Uri.parse(url));
//                             } else {
//                               throw 'Could not launch $url';
//                             }
//                           }
//                         } catch (e) {
//                           print('Erro: $e');
//                         }

//                         // checkoutManager.checkout(
//                         //     creditCard: creditCard,
//                         //     onStockFail: (e) {
//                         //       ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
//                         //         SnackBar(
//                         //           content: Text(
//                         //             "$e",
//                         //           ),
//                         //           backgroundColor: Colors.red,
//                         //         ),
//                         //       );
//                         //       Navigator.of(context).popUntil((route) => route.settings.name == '/cart');
//                         //     },
//                         //     onSuccess: (orders) {
//                         //       Navigator.of(context).popUntil((route) => route.settings.name == '/');
//                         //       Navigator.of(context).pushNamed('/confirmation', arguments: orders);
//                         //       // context.read<PageManager>().setPage(2);
//                         //     });
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
