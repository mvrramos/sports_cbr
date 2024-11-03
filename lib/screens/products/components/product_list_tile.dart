import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../models/product/product.dart';

class ProductListTile extends StatelessWidget {
  const ProductListTile(this.product, {super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/product', arguments: product);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child: Container(
          height: 100,
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Image(
                  image: CachedNetworkImageProvider(
                    product.images!.first,
                    maxHeight: 120,
                    maxWidth: 160,
                  ),
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) {
                      return child;
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        color: Color.fromARGB(100, 73, 5, 182),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name ?? '',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        "A partir de",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                    Text(
                      "R\$ ${product.basePrice.toString()}",
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.black),
                    ),
                    if (!product.hasStock)
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          "Sem estoque",
                          style: TextStyle(color: Colors.red, fontSize: 10),
                        ),
                      )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
