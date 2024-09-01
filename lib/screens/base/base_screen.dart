import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportscbr/common/custom_drawer/custom_drawer.dart';
import 'package:sportscbr/models/page_manager.dart';
import 'package:sportscbr/models/user_manager.dart';
import 'package:sportscbr/orders/orders_screen.dart';
import 'package:sportscbr/screens/admin_orders/admin_orders_screen.dart';
import 'package:sportscbr/screens/admin_users/admin_users_screen.dart';
import 'package:sportscbr/screens/home/home_screen.dart';
import 'package:sportscbr/screens/products/products_screen.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => PageManager(pageController),
      child: Consumer<UserManager>(
        builder: (_, userManager, __) {
          return PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              const HomeScreen(),
              const ProductsScreen(),
              const OrdersScreen(),
              Scaffold(
                drawer: const CustomDrawer(),
                appBar: AppBar(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                  title: const Text(
                    "Loja",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              if (userManager.adminEnabled) ...[
                const AdminUsersScreen(),
                const AdminOrdersScreen()
              ]
            ],
          );
        },
      ),
    );
  }
}
