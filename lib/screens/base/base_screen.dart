import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../models/page_manager.dart';
import '../../models/user/user_manager.dart';
import '../../orders/orders_screen.dart';
import '../admin_orders/admin_orders_screen.dart';
import '../admin_users/admin_users_screen.dart';
import '../home/home_screen.dart';
import '../products/products_screen.dart';
import '../stores/stores_screen.dart';

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
              const StoresScreen(),
              if (userManager.adminEnabled) ...[
                const AdminUsersScreen(),
                const AdminOrdersScreen()
              ],
            ],
          );
        },
      ),
    );
  }
}
