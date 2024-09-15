import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportscbr/models/cart_manager.dart';
import 'package:sportscbr/models/product.dart';
import 'package:sportscbr/models/user_manager.dart';
import 'package:sportscbr/screens/product/components/size_widget.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen(this.product, {super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          title: Text(product.name ?? ''),
          centerTitle: true,
          actions: [
            Consumer<UserManager>(
              builder: (_, userManager, __) {
                if (userManager.adminEnabled && !product.deleted!) {
                  return IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/edit_product', arguments: product);
                    },
                    icon: const Icon(Icons.edit),
                  );
                }
                return Container(); // Fallback vazio
              },
            ),
          ],
        ),
        body: ListView(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: CarouselSlider(
                items: product.images!.map((url) {
                  return Image.network(
                    url,
                    fit: BoxFit.cover,
                  );
                }).toList(),
                options: CarouselOptions(
                  aspectRatio: 1,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name ?? '',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      "A partir de",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  Text(
                    "R\$${product.basePrice.toString()}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      "Descrição",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  Text(
                    product.description ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (product.deleted!)
                    const Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 16),
                      child: Text(
                        "Produto indisponível",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                      ),
                    )
                  else ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      child: Text(
                        "Tamanhos",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: product.sizes!.map((s) {
                        return SizeWidget(s);
                      }).toList(),
                    ),
                    const SizedBox(height: 60),
                    if (product.hasStock)
                      Consumer2<UserManager, Product>(
                        builder: (_, userManager, product, __) {
                          return SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton(
                              onPressed: product.selectedSize != null
                                  ? () {
                                      if (userManager.isLoggedIn) {
                                        context.read<CartManager>().addToCart(product);
                                        Navigator.of(context).pushNamed('/cart');
                                      } else {
                                        Navigator.of(context).pushNamed('/login');
                                      }
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(100, 73, 5, 182),
                              ),
                              child: Text(
                                userManager.isLoggedIn ? "Adicionar ao carrinho" : "Entre para comprar",
                                style: const TextStyle(color: Colors.white, fontSize: 18),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
