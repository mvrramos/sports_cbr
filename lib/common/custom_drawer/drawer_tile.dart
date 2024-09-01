

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportscbr/models/page_manager.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile(this.iconData, this.title, this.page, {super.key});

  final IconData iconData;
  final String title;
  final int page;

  @override
  Widget build(BuildContext context) {
    final int currentPage = context.watch<PageManager>().page;

    return InkWell(
      onTap: () {
        context.read<PageManager>().setPage(page);
      },
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Icon(
                iconData,
                size: 32,
                color: currentPage == page ? const Color.fromARGB(100, 73, 5, 182) : Colors.black,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: currentPage == page ? const Color.fromARGB(100, 73, 5, 182) : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
