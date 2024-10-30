import 'dart:io';

import 'package:flutter/material.dart';
import '../../../models/section/section.dart';
import '../../../models/section/section_item.dart';
import '../../edit_product/components/image_source_sheet.dart';

class AddTileWidget extends StatelessWidget {
  const AddTileWidget(this.section, {super.key});
  final Section section;

  @override
  Widget build(BuildContext context) {
    void onImageSelected(File file) {
      section.addItem(SectionItem(image: file));
      Navigator.of(context).pop();
    }

    return AspectRatio(
      aspectRatio: 1,
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => ImageSourceSheet(onImageSelected),
          );
        },
        child: Container(
          color: Colors.white24,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
