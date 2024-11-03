import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../models/home_manager.dart';
import '../../../models/product/product.dart';
import '../../../models/product/product_manager.dart';
import '../../../models/section/section.dart';
import '../../../models/section/section_item.dart';

class ItemTile extends StatelessWidget {
  const ItemTile(this.item, {super.key});

  final SectionItem item;

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();

    return GestureDetector(
      onTap: () {
        if (item.product != null) {
          final product = item.product != null ? context.read<ProductManager>().finProductById(item.product!) : null;
          if (product != null) {
            Navigator.of(context).pushNamed('/product', arguments: product);
          }
        }
      },
      onLongPress: homeManager.editing
          ? () {
              showDialog(
                context: context,
                builder: (_) {
                  final product = item.product != null ? context.read<ProductManager>().finProductById(item.product!) : null;

                  return AlertDialog(
                    content: product != null
                        ? ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Image(
                              image: CachedNetworkImageProvider(
                                product.images!.first,
                                maxHeight: 120,
                                maxWidth: 160,
                              ),
                            ),
                            title: Text(product.name!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                            subtitle: Text("R\$ ${product.basePrice}", style: const TextStyle(fontSize: 18)),
                          )
                        : null,
                    title: const Text(
                      "Editar tela",
                      style: TextStyle(color: Colors.black),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          context.read<Section>().removeItem(item);
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
                        child: const Text(
                          "Excluir",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (product != null) {
                            item.product = null;
                          } else {
                            final Product? selectedProduct = await Navigator.of(context).pushNamed('/select_product') as Product?;
                            if (selectedProduct != null) {
                              item.product = selectedProduct.pid;
                            }
                          }
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          product != null ? "Desvincular" : "Vincular",
                          style: const TextStyle(color: Color.fromARGB(100, 73, 5, 182)),
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          : null,
      child: AspectRatio(
        aspectRatio: 1,
        child: item.image is String
            ? FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: item.image as String,
                fit: BoxFit.cover,
              )
            : Image.file(item.image as File, fit: BoxFit.cover),
      ),
    );
  }
}
