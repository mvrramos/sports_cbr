import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportscbr/models/product_manager.dart';

class SelectProductScreen extends StatelessWidget {
  const SelectProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vincular produto"),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Consumer<ProductManager>(
        builder: (_, productManager, __) {
          return ListView.builder(
            itemCount: productManager.allProducts.length,
            itemBuilder: (_, index) {
              final product = productManager.allProducts[index];
              return ListTile(
                leading: Image.network(product.images!.first),
                title: Text(product.name!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white)),
                subtitle: Text("R\$ ${product.basePrice}", style: const TextStyle(fontSize: 18, color: Colors.white)),
                onTap: () {
                  Navigator.of(context).pop(product);
                },
              );
            },
          );
        },
      ),
    );
  }
}
