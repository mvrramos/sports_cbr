import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PaymentBricksScreen extends StatefulWidget {
  const PaymentBricksScreen({super.key});

  @override
  State<PaymentBricksScreen> createState() => _PaymentBricksScreenState();
}

class _PaymentBricksScreenState extends State<PaymentBricksScreen> {
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MercadoPago Payment'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: Uri.parse(''), 
        ),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        onLoadStop: (controller, url) async {
          // Aqui você pode carregar scripts adicionais ou interagir com o WebView se necessário.
        },
      ),
    );
  }
}
