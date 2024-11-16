import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportscbr/models/payment/payment_manager.dart';
// import 'package:sportscbr/screens/checkout/checkout_screen.dart';
import 'package:sportscbr/screens/confirmation/confirmation_screen.dart';
import 'package:sportscbr/screens/edit_product/edit_product_screen.dart';
import 'package:sportscbr/screens/home/home_screen.dart';
import 'package:sportscbr/screens/login/login_screen.dart';
import 'package:sportscbr/screens/product/product_screen.dart';
import 'package:sportscbr/screens/select_product/select_product_screen.dart';
import 'package:sportscbr/screens/signup/signup_screen.dart';

import 'models/admin_orders_manager.dart';
import 'models/cart/cart_manager.dart';
import 'models/data_user.dart';
import 'models/home_manager.dart';
import 'models/orders/orders.dart';
import 'models/orders/orders_manager.dart';
import 'models/product/product.dart';
import 'models/product/product_manager.dart';
import 'models/stores/stores_manager.dart';
import 'models/user/admin_users_manager.dart';
import 'models/user/user_manager.dart';
import 'screens/address/address_screen.dart';
import 'screens/base/base_screen.dart';
import 'screens/cart/cart_screen.dart';

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
        ChangeNotifierProvider(create: (_) => StoresManager()),
        ChangeNotifierProvider(create: (_) => PaymentManager(), lazy: false),
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
        Provider<DataUser>(create: (_) => DataUser()),
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
            // return MaterialPageRoute(builder: (_) => CheckoutScreen());

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
