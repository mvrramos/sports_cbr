import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton(this.iconData, this.color, this.onTap, {this.size, super.key});

  final IconData iconData;
  final Color color;
  final VoidCallback onTap;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Icon(
              iconData,
              color: color,
              size: size ?? 24,
            ),
          ),
        ),
      ),
    );
  }
}
