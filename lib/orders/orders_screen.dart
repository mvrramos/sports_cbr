import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/custom_drawer/custom_drawer.dart';
import '../common/custom_drawer/order/orders_tile.dart';
import '../common/login_card.dart';
import '../models/orders/orders_manager.dart';
import '../screens/cart/components/empty_card.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Meus pedidos"),
        centerTitle: true,
      ),
      body: Consumer<OrdersManager>(
        builder: (_, ordersManager, __) {
          if (ordersManager.dataUser == null) {
            return const LoginCard();
          }
          if (ordersManager.orders.isEmpty) {
            return const EmptyCard(
              title: "Nenhuma compra encontrada!",
              iconData: Icons.remove_shopping_cart,
            );
          }
          return ListView.builder(
            itemCount: ordersManager.orders.length,
            itemBuilder: (_, index) {
              return OrdersTile(ordersManager.orders.reversed.toList()[index]);
            },
          );
        },
      ),
    );
  }
}
