import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportscbr/models/admin_orders_manager.dart';
import 'package:sportscbr/models/admin_users_manager.dart';
import 'package:sportscbr/models/cart_manager.dart';
import 'package:sportscbr/models/home_manager.dart';
import 'package:sportscbr/models/orders.dart';
import 'package:sportscbr/models/orders_manager.dart';
import 'package:sportscbr/models/product.dart';
import 'package:sportscbr/models/product_manager.dart';
import 'package:sportscbr/models/store_manager.dart';
import 'package:sportscbr/models/user_manager.dart';
import 'package:sportscbr/screens/address/address_screen.dart';
import 'package:sportscbr/screens/base/base_screen.dart';
import 'package:sportscbr/screens/cart/cart_screen.dart';
import 'package:sportscbr/screens/checkout/checkout_screen.dart';
import 'package:sportscbr/screens/confirmation/confirmation_screen.dart';
import 'package:sportscbr/screens/edit_product/edit_product_screen.dart';
import 'package:sportscbr/screens/home/home_screen.dart';
import 'package:sportscbr/screens/login/login_screen.dart';
import 'package:sportscbr/screens/product/product_screen.dart';
import 'package:sportscbr/screens/select_product/select_product_screen.dart';
import 'package:sportscbr/screens/signup/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserManager(), lazy: false),
        ChangeNotifierProvider(create: (_) => ProductManager(), lazy: false),
        ChangeNotifierProvider(create: (_) => HomeManager(), lazy: false),
        ChangeNotifierProvider(create: (_) => StoreManager()),
        ChangeNotifierProxyProvider<UserManager, CartManager>(
          create: (_) => CartManager(),
          lazy: false,
          update: (_, userManager, cartManager) => cartManager!..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, OrdersManager>(
          create: (_) => OrdersManager(),
          lazy: false,
          update: (_, userManager, ordersManager) => ordersManager!..updateUser(userManager.dataUser),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminUsersManager>(
          create: (_) => AdminUsersManager(),
          lazy: false,
          update: (_, userManager, adminUsersManager) => adminUsersManager!..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminOrdersManager>(
          create: (_) => AdminOrdersManager(),
          lazy: false,
          update: (_, userManager, adminOrdersManager) => adminOrdersManager!..updateAdmin(userManager.adminEnabled),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sports CBR',
        theme: ThemeData(
          primaryColor: Colors.black,
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: const AppBarTheme(
            elevation: 0,
          ),
        ),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/signup':
              return MaterialPageRoute(builder: (_) => SignUpScreen());

            case '/login':
              return MaterialPageRoute(builder: (_) => LoginScreen());

            case '/product':
              return MaterialPageRoute(builder: (_) => ProductScreen(settings.arguments as Product));

            case '/cart':
              return MaterialPageRoute(builder: (_) => const CartScreen(), settings: settings);

            case '/home':
              return MaterialPageRoute(builder: (_) => const HomeScreen());

            case '/edit_product':
              return MaterialPageRoute(builder: (_) => EditProductScreen(settings.arguments as Product));

            case '/select_product':
              return MaterialPageRoute(builder: (_) => const SelectProductScreen());

            case '/address':
              return MaterialPageRoute(builder: (_) => const AddressScreen());

            case '/checkout':
              return MaterialPageRoute(builder: (_) => CheckoutScreen());

            case '/confirmation':
              return MaterialPageRoute(builder: (_) => ConfirmationScreen(settings.arguments as Orders));

            case '/':
            default:
              return MaterialPageRoute(builder: (_) => const BaseScreen(), settings: settings);
          }
        },
      ),
    );
  }
}
