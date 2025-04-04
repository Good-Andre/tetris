import 'package:flutter/material.dart';

class Pixel extends StatelessWidget {
  final Color? color;

  const Pixel({required this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      margin: const EdgeInsets.all(1),
    );
  }
}
