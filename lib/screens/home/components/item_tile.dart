import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportscbr/models/home_manager.dart';
import 'package:sportscbr/models/product.dart';
import 'package:sportscbr/models/product_manager.dart';
import 'package:sportscbr/models/section.dart';
import 'package:sportscbr/models/section_item.dart';
import 'package:transparent_image/transparent_image.dart';

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
                            leading: Image.network(product.images!.first),
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
                            final Product product = await Navigator.of(context).pushNamed('/select_product') as Product;
                            item.product = product.pid;
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
              : Image.file(item.image as File, fit: BoxFit.cover)),
    );
  }
}
