import 'package:flutter/material.dart';
import 'package:sportscbr/models/home_manager.dart';
import 'package:sportscbr/models/section/section.dart';

class AddSectionWidget extends StatelessWidget {
  const AddSectionWidget(this.homeManager, {super.key});

  final HomeManager homeManager;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              homeManager.addSection(Section(type: "List"));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
            child: const Text(
              "Adicionar lista",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              homeManager.addSection(Section(type: "Staggered"));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
            child: const Text(
              "Adicionar grade",
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
