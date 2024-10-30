import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../common/custom_icon_button.dart';
import '../../../models/home_manager.dart';
import '../../../models/section/section.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.section, {super.key});

  final Section section;

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();

    if (homeManager.editing) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: section.name,
                  decoration: const InputDecoration(
                    hintText: "Título",
                    isDense: true,
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                  onChanged: (text) => section.name = text,
                ),
              ),
              CustomIconButton(Icons.remove, Colors.white, () {
                homeManager.removeSection(section);
              }),
            ],
          ),
          if (section.error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                section.error ?? '',
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            )
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          section.name ?? '',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
      );
    }
  }
}
