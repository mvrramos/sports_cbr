import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sportscbr/models/page_manager.dart';
import 'package:sportscbr/models/user_manager.dart';
import 'package:sportscbr/orders/orders_screen.dart';
import 'package:sportscbr/screens/admin_orders/admin_orders_screen.dart';
import 'package:sportscbr/screens/admin_users/admin_users_screen.dart';
import 'package:sportscbr/screens/home/home_screen.dart';
import 'package:sportscbr/screens/stores/stores_screen.dart';
import 'package:sportscbr/screens/products/products_screen.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
  }

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
              const StoreScreen(),
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
