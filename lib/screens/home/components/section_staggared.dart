import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import '../../../models/home_manager.dart';
import '../../../models/section/section.dart';
import 'add_tile_widget.dart';
import 'item_tile.dart';
import 'section_header.dart';

class SectionStaggared extends StatelessWidget {
  const SectionStaggared(this.section, {super.key});

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
            Consumer<Section>(
              builder: (_, section, __) {
                return StaggeredGrid.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: List.generate(homeManager.editing ? section.items.length + 1 : section.items.length, (index) {
                    if (index < section.items.length) {
                      return StaggeredGridTile.count(
                        crossAxisCellCount: 2,
                        mainAxisCellCount: 2,
                        child: ItemTile(section.items[index]),
                      );
                    } else {
                      return AddTileWidget(section);
                    }
                  }),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
