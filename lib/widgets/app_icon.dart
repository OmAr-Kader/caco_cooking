import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  final IconData icon;
  final Color backColor;
  final Color color;
  final double size;

  const AppIcon({Key? key,
    required this.icon,
    required this.size,
    this.backColor = const Color(0xd2fcf4e4),
    this.color = const Color(0xFF756d54)
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size / 2),
          color: backColor,
        ),
        child: Center(
          child: Icon(icon, color: color, size: size / 2),
        )
    );
  }
}
