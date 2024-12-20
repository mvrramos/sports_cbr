import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/home_manager.dart';
import '../../../models/section/section.dart';
import 'add_tile_widget.dart';
import 'item_tile.dart';
import 'section_header.dart';

class SectionList extends StatelessWidget {
  const SectionList(this.section, {super.key});

  final Section section;

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();

    return ChangeNotifierProvider.value(
      value: section,
      child: Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(section),
            SizedBox(
                height: 150,
                child: Consumer<Section>(
                  builder: (_, section, __) {
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, index) {
                        if (index < section.items.length) {
                          return SizedBox(
                            width: 150,
                            height: 150,
                            child: ItemTile(section.items[index]),
                          );
                        } else {
                          return AddTileWidget(section);
                        }
                      },
                      separatorBuilder: (_, __) => const SizedBox(width: 14),
                      itemCount: homeManager.editing ? section.items.length + 1 : section.items.length,
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }
}
