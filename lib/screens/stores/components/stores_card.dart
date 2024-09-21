import 'package:flutter/material.dart';
import 'package:sportscbr/common/custom_icon_button.dart';
import 'package:sportscbr/models/stores.dart';
import 'package:url_launcher/url_launcher.dart';

class StoresCard extends StatelessWidget {
  StoresCard(this.store, {super.key});

  final Stores store;

  @override
  Widget build(BuildContext context) {
    Color colorForStatus(StoreStatus status) {
      switch (status) {
        case StoreStatus.closed:
          return Colors.red;
        case StoreStatus.open:
          return Colors.green;
        case StoreStatus.closing:
          return Colors.yellow;

        default:
          return Colors.green;
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            height: 160,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  store.image!,
                  fit: BoxFit.cover,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8)),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Text(
                      store.statusText,
                      style: TextStyle(
                        color: colorForStatus(store.status!),
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 160,
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        store.name!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        store.addressText,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        store.openingText,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIconButton(
                      Icons.map,
                      Colors.black54,
                      () {},
                    ),
                    CustomIconButton(
                      Icons.phone,
                      Colors.black54,
                      openPhone,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void openPhone() async {
    final Uri phoneUrl = Uri(scheme: 'tel', path: store.cleanPhone);

    if (await canLaunchUrl(phoneUrl)) {
      await launchUrl(phoneUrl);
    } else {
      print('Erro ao tentar abrir o telefone.');
    }
  }
}
