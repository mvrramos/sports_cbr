import 'package:flutter/material.dart';
import 'package:sportscbr/models/store.dart';

class StoreCard extends StatelessWidget {
  StoreCard(this.store, {super.key});

  final Store store;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: [
          Image.network(store.image!),
          Container(
            height: 140,
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      store.name!,
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
                    ),
                    Text(
                      store.addressText,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
